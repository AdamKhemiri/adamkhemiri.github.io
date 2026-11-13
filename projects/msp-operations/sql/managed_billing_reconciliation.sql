-- Fabric Warehouse view. Expects AgreementRaw, DeviceSnapshotRaw, and InvoiceLineRaw.
-- One row per client, agreement term, and service month.
CREATE OR ALTER VIEW dbo.vw_ManagedBillingReconciliation AS
WITH DeviceMonths AS (
    SELECT ClientId, AgreementId, SnapshotMonth AS ServiceMonth,
           COUNT(DISTINCT CASE WHEN IsActive = 1 AND IsBillable = 1
                               THEN DeviceId END) AS EligibleWorkstations
    FROM dbo.DeviceSnapshotRaw
    GROUP BY ClientId, AgreementId, SnapshotMonth
), UniqueManagedLines AS (
    SELECT DISTINCT InvoiceLineId, ClientId, AgreementId, ServiceMonth,
           CAST(BilledQuantity AS int) AS BilledQuantity,
           CAST(LineAmount AS decimal(18, 2)) AS LineAmount
    FROM dbo.InvoiceLineRaw
    WHERE LineType = 'Managed_Agreement'
), InvoiceMonths AS (
    SELECT ClientId, AgreementId, ServiceMonth,
           SUM(BilledQuantity) AS BilledWorkstations,
           CAST(SUM(LineAmount) AS decimal(18, 2)) AS InvoicedRevenue
    FROM UniqueManagedLines
    GROUP BY ClientId, AgreementId, ServiceMonth
), BillingAmounts AS (
    SELECT COALESCE(d.ClientId, i.ClientId) AS ClientId,
           COALESCE(d.AgreementId, i.AgreementId) AS AgreementId,
           COALESCE(d.ServiceMonth, i.ServiceMonth) AS ServiceMonth,
           d.EligibleWorkstations,
           COALESCE(i.BilledWorkstations, 0) AS BilledWorkstations,
           CAST(a.SignedRatePerWorkstation AS decimal(10, 2)) AS SignedRate,
           CAST(d.EligibleWorkstations * CAST(a.SignedRatePerWorkstation AS decimal(10, 2))
                AS decimal(18, 2)) AS ExpectedRevenue,
           COALESCE(i.InvoicedRevenue, 0.00) AS InvoicedRevenue,
           CASE
               WHEN d.ClientId IS NULL THEN 'Missing device snapshot'
               WHEN a.AgreementId IS NULL THEN 'Missing agreement'
               WHEN i.ClientId IS NULL THEN 'Missing invoice'
               ELSE 'Matched'
           END AS MatchStatus
    FROM DeviceMonths AS d
    FULL OUTER JOIN InvoiceMonths AS i
        ON d.ClientId = i.ClientId
       AND d.AgreementId = i.AgreementId
       AND d.ServiceMonth = i.ServiceMonth
    LEFT JOIN dbo.AgreementRaw AS a
        ON a.ClientId = COALESCE(d.ClientId, i.ClientId)
       AND a.AgreementId = COALESCE(d.AgreementId, i.AgreementId)
)
SELECT *,
       EligibleWorkstations - BilledWorkstations AS WorkstationGap,
       ExpectedRevenue - InvoicedRevenue AS BillingGap
FROM BillingAmounts;
