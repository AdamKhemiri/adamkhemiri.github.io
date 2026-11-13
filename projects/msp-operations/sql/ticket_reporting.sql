-- Run in MSP_Analytics. Creates four physical Warehouse tables for the first Power BI matrix.
-- Run once after the full ticket delivery and reference-table checkpoints.

CREATE TABLE dbo.DimClient AS
SELECT CAST(ClientId AS VARCHAR(16)) AS ClientId,
       CAST(ClientName AS VARCHAR(100)) AS ClientName,
       CAST(Industry AS VARCHAR(60)) AS Industry,
       CAST(AccountStatus AS VARCHAR(30)) AS AccountStatus
FROM dbo.ClientRaw;

CREATE TABLE dbo.DimClosingActor AS
SELECT CAST(StaffId AS VARCHAR(24)) AS ClosingActorKey,
       CAST(FullName AS VARCHAR(100)) AS ClosingActorName,
       CAST('Technician' AS VARCHAR(20)) AS ClosingActorType
FROM dbo.StaffRateRaw
UNION ALL SELECT 'ACTOR-AUTOMATION', 'Automation', 'Automation'
UNION ALL SELECT 'ACTOR-UNKNOWN', 'Unknown', 'Unknown';

CREATE TABLE dbo.DimDate AS
WITH Calendar AS (
    SELECT CAST(DATEADD(DAY, value, CAST('2024-11-01' AS DATE)) AS DATE) AS CalendarDate
    FROM GENERATE_SERIES(0, DATEDIFF(DAY, CAST('2024-11-01' AS DATE), CAST('2026-10-31' AS DATE)), 1)
)
SELECT CalendarDate,
       CAST(DATEFROMPARTS(YEAR(CalendarDate), MONTH(CalendarDate), 1) AS DATE) AS MonthStart,
       CONVERT(VARCHAR(7), CalendarDate, 120) AS YearMonth
FROM Calendar;

CREATE TABLE dbo.FactTicket AS
WITH Typed AS (
    SELECT CAST(t.TicketId AS VARCHAR(20)) AS TicketId,
           CAST(t.ClientId AS VARCHAR(16)) AS ClientId,
           CAST(t.AgreementId AS VARCHAR(20)) AS AgreementId,
           CAST(t.AssignedStaffId AS VARCHAR(16)) AS AssignedStaffId,
           CAST(NULLIF(t.ClosingActorKey, '') AS VARCHAR(24)) AS ClosingActorKey,
           CAST(t.IssueCode AS VARCHAR(40)) AS IssueCode,
           CAST(t.IssueCategory AS VARCHAR(80)) AS IssueCategory,
           CAST(t.Priority AS VARCHAR(30)) AS Priority,
           CAST(t.Status AS VARCHAR(30)) AS Status,
           TRY_CONVERT(DATETIME2(0), NULLIF(LEFT(CONVERT(VARCHAR(33), t.CreatedAtUtc, 126), 19), ''), 126) AS CreatedAtUtc,
           TRY_CONVERT(DATETIME2(0), NULLIF(LEFT(CONVERT(VARCHAR(33), t.FirstResponseAtUtc, 126), 19), ''), 126) AS FirstResponseAtUtc,
           TRY_CONVERT(DATETIME2(0), NULLIF(LEFT(CONVERT(VARCHAR(33), t.ResolvedAtUtc, 126), 19), ''), 126) AS ResolvedAtUtc,
           TRY_CONVERT(DATETIME2(0), NULLIF(LEFT(CONVERT(VARCHAR(33), t.ClosedAtUtc, 126), 19), ''), 126) AS ClosedAtUtc,
           TRY_CONVERT(INT, p.FirstResponseTargetMinutes) AS FirstResponseTargetMinutes,
           TRY_CONVERT(INT, p.ResolutionTargetMinutes) AS ResolutionTargetMinutes
    FROM dbo.vw_TicketLatest AS t
    LEFT JOIN dbo.SlaPolicyRaw AS p ON p.Priority = t.Priority
), Durations AS (
    SELECT *,
           DATEDIFF(SECOND, CreatedAtUtc, FirstResponseAtUtc) AS FirstResponseSeconds,
           DATEDIFF(SECOND, CreatedAtUtc, ResolvedAtUtc) AS ResolutionSeconds
    FROM Typed
)
SELECT TicketId, ClientId, AgreementId, AssignedStaffId, ClosingActorKey, IssueCode, IssueCategory,
       Priority, Status, CreatedAtUtc, FirstResponseAtUtc, ResolvedAtUtc, ClosedAtUtc,
       CAST(CreatedAtUtc AS DATE) AS CreatedDate,
       CAST(ClosedAtUtc AS DATE) AS ClosedDate,
       CAST(CASE WHEN Status = 'Closed' AND ClosedAtUtc IS NOT NULL THEN 1 ELSE 0 END AS INT) AS IsClosed,
       CAST(FirstResponseSeconds / 60.0 AS DECIMAL(12,2)) AS FirstResponseMinutes,
       CAST(ResolutionSeconds / 60.0 AS DECIMAL(12,2)) AS ResolutionMinutes,
       CAST(CASE WHEN FirstResponseSeconds IS NULL OR FirstResponseSeconds < 0
                       OR FirstResponseTargetMinutes IS NULL THEN NULL
                 WHEN FirstResponseSeconds <= FirstResponseTargetMinutes * 60 THEN 1
                 ELSE 0 END AS INT) AS FirstResponseSlaMet,
       CAST(CASE WHEN ResolutionSeconds IS NULL OR ResolutionSeconds < 0
                       OR ResolutionTargetMinutes IS NULL THEN NULL
                 WHEN ResolutionSeconds <= ResolutionTargetMinutes * 60 THEN 1
                 ELSE 0 END AS INT) AS ResolutionSlaMet
FROM Durations;

-- Checkpoint 1. Expect 28,600 tickets and zero exceptions.
SELECT COUNT(*) AS CurrentTickets,
       COUNT(DISTINCT f.TicketId) AS UniqueTicketIds,
       SUM(CASE WHEN f.CreatedDate IS NULL OR f.Status = 'Closed' AND f.ClosedDate IS NULL
                THEN 1 ELSE 0 END) AS MissingRequiredDates,
       SUM(CASE WHEN c.ClientId IS NULL THEN 1 ELSE 0 END) AS MissingClients,
       SUM(CASE WHEN f.IsClosed = 1 AND a.ClosingActorKey IS NULL THEN 1 ELSE 0 END) AS MissingClosingActors,
       SUM(CASE WHEN p.Priority IS NULL THEN 1 ELSE 0 END) AS MissingSlaPriorities
FROM dbo.FactTicket AS f
LEFT JOIN dbo.DimClient AS c ON c.ClientId = f.ClientId
LEFT JOIN dbo.DimClosingActor AS a ON a.ClosingActorKey = f.ClosingActorKey
LEFT JOIN dbo.SlaPolicyRaw AS p ON p.Priority = f.Priority;

-- Checkpoint 2. Expect 1,116 February closures, 104 for Dentistry, and 14 by Liam at Dentistry.
SELECT COUNT(*) AS FebruaryClosures,
       SUM(CASE WHEN c.ClientId = 'CLI-001' THEN 1 ELSE 0 END) AS DentistryClosures,
       SUM(CASE WHEN c.ClientId = 'CLI-001' AND a.ClosingActorKey = 'STF-201' THEN 1 ELSE 0 END) AS DentistryLiamClosures,
       SUM(CASE WHEN a.ClosingActorType = 'Automation' THEN 1 ELSE 0 END) AS AutomatedClosures,
       SUM(CASE WHEN a.ClosingActorType = 'Unknown' THEN 1 ELSE 0 END) AS UnknownClosures
FROM dbo.FactTicket AS f
JOIN dbo.DimClient AS c ON c.ClientId = f.ClientId
JOIN dbo.DimClosingActor AS a ON a.ClosingActorKey = f.ClosingActorKey
JOIN dbo.DimDate AS d ON d.CalendarDate = f.ClosedDate
WHERE f.IsClosed = 1 AND d.YearMonth = '2025-02';
