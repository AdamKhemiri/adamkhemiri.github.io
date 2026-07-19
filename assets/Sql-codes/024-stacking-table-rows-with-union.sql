/*
    Project: AdventureWorks SQL Practice
    File: 024-stacking-table-rows-with-union.sql
    Topic: Combining Rows with UNION
    Database: AdventureWorks2022

    Objective:
    Practice combining rows from tables with similar structures
    by using UNION and aligning corresponding columns.
*/


/*
    Exercise 1: Select High-Value Purchase Order Details

    Return purchase-order detail records whose LineTotal
    is greater than $10,000.
*/

SELECT
    [PurchaseOrderID],
    [PurchaseOrderDetailID],
    [OrderQty],
    [LineTotal]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderDetail]
WHERE [LineTotal] > 10000;


/*
    Exercise 2: Select High-Value Sales Order Details

    Return sales-order detail records whose LineTotal
    is greater than $10,000.
*/

SELECT
    [SalesOrderID],
    [SalesOrderDetailID],
    [OrderQty],
    [LineTotal]
FROM [AdventureWorks2022].[Sales].[SalesOrderDetail]
WHERE [LineTotal] > 10000;


/*
    Exercise 3: Combine Purchase and Sales Order Details

    Stack the results from the purchase-order and sales-order
    detail tables vertically.

    Rename the first two output columns to OrderID
    and OrderDetailID.
*/

SELECT
    [PurchaseOrderID] AS [OrderID],
    [PurchaseOrderDetailID] AS [OrderDetailID],
    [OrderQty],
    [LineTotal]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderDetail]
WHERE [LineTotal] > 10000

UNION

SELECT
    [SalesOrderID],
    [SalesOrderDetailID],
    [OrderQty],
    [LineTotal]
FROM [AdventureWorks2022].[Sales].[SalesOrderDetail]
WHERE [LineTotal] > 10000;


/*
    Exercise 4: Add Run Date and Order Type

    Add a RunDate column containing the current date
    and an OrderType column identifying each row as
    either Purchase or Sale.

    Sort the combined results by LineTotal
    in descending order.
*/

SELECT
    [PurchaseOrderID] AS [OrderID],
    [PurchaseOrderDetailID] AS [OrderDetailID],
    [OrderQty],
    [LineTotal],
    CAST(GETDATE() AS DATE) AS [RunDate],
    'Purchase' AS [OrderType]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderDetail]
WHERE [LineTotal] > 10000

UNION

SELECT
    [SalesOrderID],
    [SalesOrderDetailID],
    [OrderQty],
    [LineTotal],
    CAST(GETDATE() AS DATE),
    'Sale'
FROM [AdventureWorks2022].[Sales].[SalesOrderDetail]
WHERE [LineTotal] > 10000

ORDER BY
    [LineTotal] DESC;