/*
    Project: AdventureWorks SQL Practice
    File: 029-summarizing-data-with-aggregate-functions.sql
    Topic: COUNT, SUM, MAX, and AVG
    Database: AdventureWorks2022

    Objective:
    Practice summarizing purchase-order data using
    common SQL aggregate functions.
*/


/*
    Exercise 1: Count High-Value Purchase Orders

    Display the number of purchase orders where
    TotalDue is greater than $20,000.
*/

SELECT
    COUNT(*) AS [Purchase Order Count]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader]
WHERE [TotalDue] > 20000;


/*
    Exercise 2: Calculate the Total Amount Due

    Display the sum of TotalDue for all purchase orders.
*/

SELECT
    SUM([TotalDue]) AS [Total Amount Due]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader];


/*
    Exercise 3: Find the Largest Purchase Order Amount

    Display the largest individual TotalDue value
    from all purchase orders.
*/

SELECT
    MAX([TotalDue]) AS [Largest Amount Due]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader];


/*
    Exercise 4: Calculate the Average Subtotal and Freight

    Display the average combined SubTotal and Freight
    amount for all purchase orders.
*/

SELECT
    AVG([SubTotal] + [Freight]) AS [Average Subtotal and Freight]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader];