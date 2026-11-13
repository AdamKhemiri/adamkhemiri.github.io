-- Run once in the MSP_Analytics Warehouse.
-- Grain: one row per client, agreement term, and service month.
CREATE TABLE dbo.FactManagedContractMonth AS
WITH ServicePayroll AS (
    SELECT PayrollMonth AS ServiceMonth,
           CAST(SUM(CAST(LoadedPayrollCost AS decimal(18, 2))) * 100 AS bigint)
               AS ServicePayrollCents
    FROM dbo.StaffPayrollRaw
    WHERE Department = 'Service Delivery'
    GROUP BY PayrollMonth
), AllocationInputs AS (
    SELECT d.*,
           p.ServicePayrollCents
               - CAST(SUM(d.CoveredLaborCost) OVER (PARTITION BY d.ServiceMonth) * 100 AS bigint)
               AS UnassignedPayrollCents,
           SUM(CAST(d.EligibleWorkstations AS bigint)) OVER (PARTITION BY d.ServiceMonth)
               AS MonthlyEligibleWorkstations,
           ROW_NUMBER() OVER (
               PARTITION BY d.ServiceMonth
               ORDER BY d.EligibleWorkstations DESC, d.ClientId, d.AgreementId
           ) AS AllocationOrder
    FROM dbo.vw_ManagedContractDirectContribution AS d
    LEFT JOIN ServicePayroll AS p ON p.ServiceMonth = d.ServiceMonth
), RoundedShares AS (
    SELECT *,
           SIGN(UnassignedPayrollCents) * (
               (ABS(UnassignedPayrollCents) * EligibleWorkstations + MonthlyEligibleWorkstations / 2)
               / NULLIF(MonthlyEligibleWorkstations, 0)
           ) AS RoundedShareCents
    FROM AllocationInputs
), Allocated AS (
    SELECT *,
           CAST(
               (RoundedShareCents + CASE WHEN AllocationOrder = 1
                    THEN UnassignedPayrollCents - SUM(RoundedShareCents) OVER (PARTITION BY ServiceMonth)
                    ELSE 0
                END) / 100.0 AS decimal(18, 2)
           ) AS AllocatedUnassignedPayroll
    FROM RoundedShares
)
SELECT CAST(ClientId AS varchar(16)) AS ClientId,
       CAST(AgreementId AS varchar(20)) AS AgreementId,
       CAST(ServiceMonth AS varchar(7)) AS ServiceMonth,
       CONVERT(date, CAST(ServiceMonth AS varchar(7)) + '-01', 23) AS MonthStart,
       EligibleWorkstations,
       BilledWorkstations,
       CAST(CoveredHours AS decimal(12, 2)) AS CoveredHours,
       InvoicedRevenue,
       ExpectedRevenue,
       BillingGap,
       CoveredLaborCost,
       ToolsCost,
       DirectDeliveryCost,
       DirectContributionAsInvoiced,
       DirectContributionAtCorrectBilling,
       AllocatedUnassignedPayroll,
       DirectDeliveryCost + AllocatedUnassignedPayroll AS FullyAllocatedCost,
       DirectContributionAsInvoiced - AllocatedUnassignedPayroll AS ManagedGrossProfit,
       DirectContributionAtCorrectBilling - AllocatedUnassignedPayroll AS ManagedGrossProfitAtCorrectBilling
FROM Allocated;

-- Result 1. February 2025 Everywhere Dentistry.
SELECT CoveredHours, CoveredLaborCost, ToolsCost, DirectDeliveryCost,
       DirectContributionAsInvoiced, DirectContributionAtCorrectBilling,
       AllocatedUnassignedPayroll, FullyAllocatedCost, ManagedGrossProfit,
       ManagedGrossProfitAtCorrectBilling
FROM dbo.FactManagedContractMonth
WHERE ClientId = 'CLI-001' AND ServiceMonth = '2025-02';

-- Result 2. Expect 409 agreement-months, $2,131,124 revenue, $264,405.60 gross profit,
-- and 12.41% managed gross margin across the full two-year period.
SELECT COUNT(*) AS AgreementMonths,
       COUNT(*) - COUNT(AllocatedUnassignedPayroll) AS MissingAllocations,
       SUM(InvoicedRevenue) AS ManagedRevenue,
       SUM(ManagedGrossProfit) AS ManagedGrossProfit,
       CAST(100.0 * SUM(ManagedGrossProfit) / NULLIF(SUM(InvoicedRevenue), 0)
            AS decimal(9, 2)) AS ManagedGrossMarginPct,
       SUM(ExpectedRevenue) AS RevenueAtCorrectBilling,
       SUM(ManagedGrossProfitAtCorrectBilling) AS GrossProfitAtCorrectBilling,
       CAST(100.0 * SUM(ManagedGrossProfitAtCorrectBilling) / NULLIF(SUM(ExpectedRevenue), 0)
            AS decimal(9, 2)) AS GrossMarginPctAtCorrectBilling
FROM dbo.FactManagedContractMonth;

-- Result 3. Expect 24 months and zero payroll variances.
WITH PayrollByMonth AS (
    SELECT PayrollMonth AS ServiceMonth,
           SUM(CAST(LoadedPayrollCost AS decimal(18, 2))) AS ServicePayroll
    FROM dbo.StaffPayrollRaw
    WHERE Department = 'Service Delivery'
    GROUP BY PayrollMonth
), ReconciledByMonth AS (
    SELECT ServiceMonth,
           SUM(CoveredLaborCost + AllocatedUnassignedPayroll) AS ReconciledPayroll,
           COUNT(*) - COUNT(AllocatedUnassignedPayroll) AS MissingAllocations
    FROM dbo.FactManagedContractMonth
    GROUP BY ServiceMonth
)
SELECT COUNT(*) AS MonthsChecked,
       SUM(CASE WHEN p.ServicePayroll IS NULL OR f.ReconciledPayroll IS NULL
                     OR f.MissingAllocations > 0 OR p.ServicePayroll <> f.ReconciledPayroll
                THEN 1 ELSE 0 END) AS MonthsWithPayrollVariance
FROM PayrollByMonth AS p
FULL OUTER JOIN ReconciledByMonth AS f ON f.ServiceMonth = p.ServiceMonth;
