/*
    Project: AdventureWorks SQL Practice
    File: 010-filtering-numerical-values-by-range.sql
    Topic: Numerical Range Filters
    Database: AdventureWorks2022

    Objective:
    Practice filtering numerical values using comparison
    operators, multiple conditions, and the BETWEEN operator.
*/


/*
    Exercise 1: Filter Purchase Orders by Total Due and Freight

    Return purchase orders where TotalDue is greater than 50,000
    and Freight is less than 1,000.
*/

SELECT
    [OrderDate],
    [SubTotal],
    [TaxAmt],
    [Freight],
    [TotalDue]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader]
WHERE [TotalDue] > 50000
  AND [Freight] < 1000;


/*
    Exercise 2: Filter Subtotals Using BETWEEN

    Return purchase orders where SubTotal is between
    10,000 and 30,000, including both boundary values.
*/

SELECT
    [OrderDate],
    [SubTotal],
    [TaxAmt],
    [Freight],
    [TotalDue]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader]
WHERE [SubTotal] BETWEEN 10000 AND 30000;


/*
    Exercise 3: Filter Subtotals Using Comparison Operators

    Return purchase orders where SubTotal is greater than 10,000
    and less than 30,000, excluding both boundary values.
*/

SELECT
    [OrderDate],
    [SubTotal],
    [TaxAmt],
    [Freight],
    [TotalDue]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader]
WHERE [SubTotal] > 10000
  AND [SubTotal] < 30000;