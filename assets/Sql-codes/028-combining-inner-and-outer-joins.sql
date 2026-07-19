/*
    Project: AdventureWorks SQL Practice
    File: 028-combining-inner-and-outer-joins.sql
    Topic: INNER JOIN and LEFT JOIN Conditions
    Database: AdventureWorks2022

    Objective:
    Practice preserving unmatched records with LEFT JOIN,
    filtering right-table matches inside the ON clause,
    and combining one-to-many detail records with INNER JOIN.
*/


/*
    Exercise 1: Calculate Each Order's Percentage of Sales YTD

    Return sales orders with a TotalDue greater than $2,000.

    Include all qualifying sales orders, even when no salesperson
    is associated with the order.

    Calculate Percent of Sales YTD by dividing TotalDue by
    the salesperson's SalesYTD value and multiplying by 100.

    Sort the results by SalesOrderID in ascending order.
*/

SELECT
    A.[SalesOrderID],
    A.[OrderDate],
    A.[TotalDue],
    (A.[TotalDue] / B.[SalesYTD]) * 100 AS [Percent of Sales YTD]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorks2022].[Sales].[SalesPerson] AS B
    ON A.[SalesPersonID] = B.[BusinessEntityID]
WHERE A.[TotalDue] > 2000
ORDER BY
    A.[SalesOrderID] ASC;


/*
    Exercise 2: Filter Salesperson Matches Inside the JOIN

    Return the same sales orders as Exercise 1.

    Match salesperson records only when SalesYTD is less
    than $2,000,000. Keep the condition inside the ON clause
    so the total number of sales-order records does not change.
*/

SELECT
    A.[SalesOrderID],
    A.[OrderDate],
    A.[TotalDue],
    (A.[TotalDue] / B.[SalesYTD]) * 100 AS [Percent of Sales YTD]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorks2022].[Sales].[SalesPerson] AS B
    ON A.[SalesPersonID] = B.[BusinessEntityID]
   AND B.[SalesYTD] < 2000000
WHERE A.[TotalDue] > 2000
ORDER BY
    A.[SalesOrderID] ASC;


/*
    Exercise 3: Add Matching Sales Order Details

    Add SalesOrderDetailID and LineTotal from
    Sales.SalesOrderDetail.

    Use INNER JOIN so only sales orders with matching detail
    records are included.

    Because one sales order can contain several detail records,
    the same SalesOrderID may appear multiple times.
*/

SELECT
    A.[SalesOrderID],
    A.[OrderDate],
    A.[TotalDue],
    (A.[TotalDue] / B.[SalesYTD]) * 100 AS [Percent of Sales YTD],
    C.[SalesOrderDetailID],
    C.[LineTotal]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorks2022].[Sales].[SalesPerson] AS B
    ON A.[SalesPersonID] = B.[BusinessEntityID]
   AND B.[SalesYTD] < 2000000
INNER JOIN [AdventureWorks2022].[Sales].[SalesOrderDetail] AS C
    ON A.[SalesOrderID] = C.[SalesOrderID]
WHERE A.[TotalDue] > 2000
ORDER BY
    A.[SalesOrderID] ASC;