/*
    Project: AdventureWorks SQL Practice
    File: 021-formatting-numbers-and-dates-with-format.sql
    Topic: FORMAT Function
    Database: AdventureWorks2022

    Objective:
    Practice formatting numerical and date values as
    currency, percentages, and custom date strings.
*/


/*
    Exercise 1: Format Salesperson Values

    Return each salesperson's BusinessEntityID, SalesQuota,
    Bonus, and CommissionPct.

    Format SalesQuota and Bonus as U.S. currency.
    Format CommissionPct as a percentage.
*/

SELECT
    [BusinessEntityID],
    FORMAT([SalesQuota], 'C', 'en-US') AS [SalesQuota],
    FORMAT([Bonus], 'C', 'en-US') AS [Bonus],
    FORMAT([CommissionPct], 'P') AS [CommissionPct]
FROM [AdventureWorks2022].[Sales].[SalesPerson];


/*
    Exercise 2: Format Purchase Order Dates and Amounts

    Return purchase orders placed during 2013.

    Format OrderDate as a four-digit year followed by
    a hyphen and two-digit month.

    Format TaxAmt, Freight, and TotalDue as U.S. currency.

    Example:
    2013-04-20 becomes 2013-04.
*/


/*
    Version 1:
    Filter the OrderDate by extracting its year.
*/

SELECT
    FORMAT([OrderDate], 'yyyy-MM') AS [OrderYearMonth],
    FORMAT([TaxAmt], 'C', 'en-US') AS [TaxAmt],
    FORMAT([Freight], 'C', 'en-US') AS [Freight],
    FORMAT([TotalDue], 'C', 'en-US') AS [TotalDue]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader]
WHERE YEAR([OrderDate]) = 2013;


/*
    Version 2:
    Filter the formatted year as a text value.
*/

SELECT
    FORMAT([OrderDate], 'yyyy-MM') AS [OrderYearMonth],
    FORMAT([TaxAmt], 'C', 'en-US') AS [TaxAmt],
    FORMAT([Freight], 'C', 'en-US') AS [Freight],
    FORMAT([TotalDue], 'C', 'en-US') AS [TotalDue]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader]
WHERE FORMAT([OrderDate], 'yyyy') = '2013';