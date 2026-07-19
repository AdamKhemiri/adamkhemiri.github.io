/*
    Project: AdventureWorks SQL Practice
    File: 018-working-with-dates-and-datetimes.sql
    Topic: Date and Datetime Functions
    Database: AdventureWorks2022

    Objective:
    Practice retrieving the current date and time, extracting
    date components, constructing dates, and filtering records
    within a date range.
*/


/*
    Exercise 1: Display the Current Date and Date Components

    Return the current date and time, the current month number,
    and the current year number using SQL date functions.
*/

SELECT
    GETDATE() AS [Today],
    MONTH(GETDATE()) AS [This Month],
    YEAR(GETDATE()) AS [This Year];


/*
    Exercise 2: Filter Purchase Orders by Date and Amount

    Return purchase orders placed from January 1, 2011,
    through July 31, 2011, where TotalDue is greater than $10,000.

    Include PurchaseOrderID, OrderDate, and TotalDue.
*/

SELECT
    [PurchaseOrderID],
    [OrderDate],
    [TotalDue]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader]
WHERE [OrderDate] >= DATEFROMPARTS(2011, 1, 1)
  AND [OrderDate] < DATEFROMPARTS(2011, 8, 1)
  AND [TotalDue] > 10000;