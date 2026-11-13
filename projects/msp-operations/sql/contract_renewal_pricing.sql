-- Run once in MSP_Analytics. One row per agreement in effect on October 31, 2026.
-- Pricing uses up to six observed months for the same agreement term.
CREATE TABLE dbo.FactContractRenewalSnapshot AS
WITH ReportingPeriod AS (
    SELECT CAST('2026-10-31' AS date) AS AsOfDate,
           CAST('2026-05-01' AS date) AS LookbackStart
), RecentCosts AS (
    SELECT f.ClientId,
           f.AgreementId,
           COUNT(DISTINCT f.MonthStart) AS ObservedMonths,
           SUM(f.EligibleWorkstations) AS EligibleWorkstationMonths,
           CAST(SUM(f.FullyAllocatedCost) AS decimal(18, 2)) AS DeliveryCost,
           CAST(SUM(f.ManagedGrossProfit) AS decimal(18, 2)) AS GrossProfitAsInvoiced,
           CAST(SUM(f.ManagedGrossProfitAtCorrectBilling) AS decimal(18, 2))
               AS GrossProfitAtCorrectBilling
    FROM dbo.FactManagedContractMonth AS f
    CROSS JOIN ReportingPeriod AS p
    WHERE f.MonthStart BETWEEN p.LookbackStart AND p.AsOfDate
    GROUP BY f.ClientId, f.AgreementId
), CurrentAgreements AS (
    SELECT CAST(a.ClientId AS varchar(16)) AS ClientId,
           CAST(a.AgreementId AS varchar(20)) AS AgreementId,
           p.AsOfDate,
           CAST(a.RenewalDate AS date) AS RenewalDate,
           CAST(a.NoticeDeadlineDate AS date) AS NoticeDeadline,
           CAST(a.SignedRatePerWorkstation AS decimal(10, 2)) AS SignedRatePerWorkstation
    FROM dbo.AgreementRaw AS a
    CROSS JOIN ReportingPeriod AS p
    WHERE p.AsOfDate BETWEEN CAST(a.EffectiveStartDate AS date) AND CAST(a.EffectiveEndDate AS date)
)
SELECT a.ClientId,
       a.AgreementId,
       a.AsOfDate,
       a.RenewalDate,
       a.NoticeDeadline,
       DATEDIFF(day, a.AsOfDate, a.NoticeDeadline) AS DaysUntilNoticeDeadline,
       CAST(CASE
           WHEN a.NoticeDeadline IS NULL THEN 'Missing deadline'
           WHEN a.NoticeDeadline < a.AsOfDate THEN 'Deadline passed'
           WHEN DATEDIFF(day, a.AsOfDate, a.NoticeDeadline) <= 60 THEN 'Due within 60 days'
           ELSE 'Due later'
       END AS varchar(24)) AS NoticeTiming,
       a.SignedRatePerWorkstation,
       COALESCE(c.ObservedMonths, 0) AS ObservedMonths,
       c.EligibleWorkstationMonths,
       c.DeliveryCost,
       c.GrossProfitAsInvoiced,
       c.GrossProfitAtCorrectBilling,
       -- Divide by 70% to leave 30% gross margin. Round the target rate up to a cent.
       CAST(CEILING(100.0 * c.DeliveryCost / NULLIF(0.70 * c.EligibleWorkstationMonths, 0))
            / 100.0 AS decimal(10, 2)) AS RateFor30PctMargin
FROM CurrentAgreements AS a
LEFT JOIN RecentCosts AS c ON c.ClientId = a.ClientId AND c.AgreementId = a.AgreementId;

-- Result 1. Validate counts and the snapshot date.
SELECT COUNT(*) AS CurrentAgreements,
       COUNT(DISTINCT AgreementId) AS UniqueAgreements,
       SUM(CASE WHEN NoticeTiming = 'Deadline passed' THEN 1 ELSE 0 END) AS DeadlinesPassed,
       SUM(CASE WHEN NoticeTiming = 'Due within 60 days' THEN 1 ELSE 0 END) AS DeadlinesWithin60Days,
       COUNT(*) - COUNT(RateFor30PctMargin) AS MissingRateEstimates,
       SUM(CASE WHEN SignedRatePerWorkstation < RateFor30PctMargin THEN 1 ELSE 0 END)
           AS RatesBelowTarget,
       MIN(AsOfDate) AS AsOfDate
FROM dbo.FactContractRenewalSnapshot;

-- Result 2. Check two loss-making accounts with different billing issues.
SELECT c.ClientName, r.ObservedMonths, r.SignedRatePerWorkstation, r.RateFor30PctMargin,
       r.GrossProfitAsInvoiced, r.GrossProfitAtCorrectBilling, r.NoticeDeadline, r.RenewalDate
FROM dbo.FactContractRenewalSnapshot AS r
JOIN dbo.DimClient AS c ON c.ClientId = r.ClientId
WHERE r.ClientId IN ('CLI-001', 'CLI-004')
ORDER BY r.NoticeDeadline;
