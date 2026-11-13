-- Run once in the MSP_Analytics Warehouse after verifying the three Business Sources loads.
-- FactProject has one row per project. FactBusinessMonth has one row per calendar month.

CREATE TABLE dbo.FactProject AS
WITH UniqueProjectInvoiceLines AS (
    -- Preserve separate invoice lines and collapse exact replays of those lines.
    SELECT DISTINCT InvoiceLineId, ProjectId, ClientId, ServiceMonth,
           CAST(LineAmount AS decimal(18, 2)) AS LineAmount
    FROM dbo.InvoiceLineRaw
    WHERE LineType = 'Project_Fixed_Fee'
      AND InvoiceStatus IN ('Paid', 'Issued')
), ProjectInvoices AS (
    SELECT ProjectId, ClientId, ServiceMonth,
           CAST(SUM(LineAmount) AS decimal(18, 2)) AS ProjectRevenue
    FROM UniqueProjectInvoiceLines
    GROUP BY ProjectId, ClientId, ServiceMonth
), ProjectLabor AS (
    SELECT ProjectId, ClientId,
           CAST(SUM(CAST(LoadedLaborCost AS decimal(18, 2))) AS decimal(18, 2)) AS LoggedProjectLabor
    FROM dbo.TimeEntryRaw
    WHERE WorkType = 'Project'
    GROUP BY ProjectId, ClientId
), ApprovedWorkOrders AS (
    SELECT ProjectId, ClientId,
           CAST(SUM(CAST(Amount AS decimal(18, 2))) AS decimal(18, 2)) AS ApprovedContractorCost
    FROM dbo.ContractorWorkOrderRaw
    WHERE WorkOrderStatus = 'Approved'
    GROUP BY ProjectId, ClientId
), ProjectAmounts AS (
    SELECT CAST(p.ProjectId AS varchar(16)) AS ProjectId,
           CAST(p.ClientId AS varchar(16)) AS ClientId,
           CAST(p.ProjectName AS varchar(120)) AS ProjectName,
           CAST(p.ProjectType AS varchar(40)) AS ProjectType,
           CONVERT(date, CONCAT(p.ServiceMonth, '-01'), 23) AS MonthStart,
           CAST(p.ContractAmount AS decimal(18, 2)) AS ContractAmount,
           i.ProjectRevenue,
           COALESCE(l.LoggedProjectLabor, 0.00) AS LoggedProjectLabor,
           COALESCE(w.ApprovedContractorCost, 0.00) AS ApprovedContractorCost
    FROM dbo.ProjectRaw AS p
    LEFT JOIN ProjectInvoices AS i ON i.ProjectId = p.ProjectId
        AND i.ClientId = p.ClientId AND i.ServiceMonth = p.ServiceMonth
    LEFT JOIN ProjectLabor AS l ON l.ProjectId = p.ProjectId AND l.ClientId = p.ClientId
    LEFT JOIN ApprovedWorkOrders AS w ON w.ProjectId = p.ProjectId AND w.ClientId = p.ClientId
)
SELECT *,
       LoggedProjectLabor + ApprovedContractorCost AS DirectProjectCost,
       ProjectRevenue - LoggedProjectLabor - ApprovedContractorCost AS DirectProjectGrossProfit
FROM ProjectAmounts;

CREATE TABLE dbo.FactBusinessMonth AS
WITH ManagedByMonth AS (
    SELECT MonthStart,
           CAST(SUM(InvoicedRevenue) AS decimal(18, 2)) AS ManagedRevenue,
           CAST(SUM(ManagedGrossProfit) AS decimal(18, 2)) AS ManagedGrossProfit
    FROM dbo.FactManagedContractMonth
    GROUP BY MonthStart
), ProjectsByMonth AS (
    SELECT MonthStart,
           CAST(SUM(ProjectRevenue) AS decimal(18, 2)) AS ProjectRevenue,
           CAST(SUM(LoggedProjectLabor) AS decimal(18, 2)) AS LoggedProjectLabor,
           CAST(SUM(ApprovedContractorCost) AS decimal(18, 2)) AS ApprovedContractorCost,
           CAST(SUM(DirectProjectGrossProfit) AS decimal(18, 2)) AS DirectProjectGrossProfit
    FROM dbo.FactProject
    GROUP BY MonthStart
), EngineeringPayrollByMonth AS (
    SELECT PayrollMonth,
           CAST(SUM(CAST(LoadedPayrollCost AS decimal(18, 2))) AS decimal(18, 2))
               AS ProjectEngineeringPayroll
    FROM dbo.StaffPayrollRaw
    WHERE Department = 'Project Engineering'
    GROUP BY PayrollMonth
), MonthlyResults AS (
    SELECT d.MonthStart,
           m.ManagedRevenue,
           m.ManagedGrossProfit,
           p.ProjectRevenue,
           p.LoggedProjectLabor,
           p.ApprovedContractorCost,
           p.DirectProjectGrossProfit,
           e.ProjectEngineeringPayroll,
           -- Project Engineering payroll already includes the labor logged to projects.
           e.ProjectEngineeringPayroll - p.LoggedProjectLabor AS UnassignedProjectPayroll,
           p.ProjectRevenue - e.ProjectEngineeringPayroll - p.ApprovedContractorCost
               AS ProjectDepartmentGrossProfit,
           CAST(o.TotalOverheadCost AS decimal(18, 2)) AS OperatingOverhead
    FROM dbo.DimDate AS d
    LEFT JOIN ManagedByMonth AS m ON m.MonthStart = d.MonthStart
    LEFT JOIN ProjectsByMonth AS p ON p.MonthStart = d.MonthStart
    LEFT JOIN EngineeringPayrollByMonth AS e ON e.PayrollMonth = d.YearMonth
    LEFT JOIN dbo.MonthlyOverheadRaw AS o ON o.OverheadMonth = d.YearMonth
    WHERE d.CalendarDate = d.MonthStart
)
SELECT *,
       ManagedRevenue + ProjectRevenue AS CompanyRevenue,
       ManagedGrossProfit + ProjectDepartmentGrossProfit AS CompanyGrossProfit,
       ManagedGrossProfit + ProjectDepartmentGrossProfit - OperatingOverhead AS OperatingProfit
FROM MonthlyResults;

-- Result 1. Project invoice coverage and contractor control.
SELECT COUNT(*) AS Projects,
       SUM(CASE WHEN ProjectRevenue IS NULL OR ProjectRevenue <> ContractAmount
                THEN 1 ELSE 0 END) AS ProjectInvoiceExceptions,
       SUM(ApprovedContractorCost) AS ApprovedContractorCost
FROM dbo.FactProject;

-- Result 2. February rollout. Expect $10,000 revenue, $7,000 direct cost, and 30% margin.
SELECT ProjectId, ProjectName, ProjectRevenue, LoggedProjectLabor, ApprovedContractorCost,
       DirectProjectCost, DirectProjectGrossProfit,
       CAST(100.0 * DirectProjectGrossProfit / NULLIF(ProjectRevenue, 0) AS decimal(9, 2))
           AS DirectProjectMarginPct
FROM dbo.FactProject
WHERE ProjectId = 'PRJ-201';

-- Result 3. Company results at three report selections.
SELECT 'February 2025' AS ReportingPeriod, COUNT(*) AS Months,
       COUNT(*) - COUNT(OperatingProfit) AS MonthsWithMissingInputs,
       SUM(CompanyRevenue) AS CompanyRevenue, SUM(CompanyGrossProfit) AS CompanyGrossProfit,
       SUM(OperatingOverhead) AS OperatingOverhead, SUM(OperatingProfit) AS OperatingProfit
FROM dbo.FactBusinessMonth
WHERE MonthStart = '2025-02-01'
UNION ALL
SELECT 'May-Oct 2026', COUNT(*), COUNT(*) - COUNT(OperatingProfit),
       SUM(CompanyRevenue), SUM(CompanyGrossProfit), SUM(OperatingOverhead), SUM(OperatingProfit)
FROM dbo.FactBusinessMonth
WHERE MonthStart BETWEEN '2026-05-01' AND '2026-10-01'
UNION ALL
SELECT 'Full 24 months', COUNT(*), COUNT(*) - COUNT(OperatingProfit),
       SUM(CompanyRevenue), SUM(CompanyGrossProfit), SUM(OperatingOverhead), SUM(OperatingProfit)
FROM dbo.FactBusinessMonth;
