/*
    Project: AdventureWorks SQL Practice
    File: 031-filtering-aggregate-calculations-with-having.sql
    Topic: GROUP BY and HAVING
    Database: AdventureWorks2022

    Objective:
    Practice filtering grouped results with HAVING,
    combining tables with INNER JOIN, and applying
    row-level filters before aggregation.
*/


/*
    Exercise 1: Identify Frequently Used First Names

    Return first names shared by more than 50 people.

    Sort the results by the number of occurrences
    in descending order.
*/

SELECT
    [FirstName],
    COUNT(*) AS [Name Count]
FROM [AdventureWorks2022].[Person].[Person]
GROUP BY
    [FirstName]
HAVING COUNT(*) > 50
ORDER BY
    [Name Count] DESC;


/*
    Exercise 2: Identify Products with Low Purchase Totals

    Return products whose combined LineTotal values in
    Purchasing.PurchaseOrderDetail are less than $10,000.

    Include the product name, number of purchase-order
    detail records, and total purchase amount.

    Sort by total purchase amount in ascending order.
*/

SELECT
    B.[Name] AS [Product],
    COUNT(*) AS [Purchase Count],
    SUM(A.[LineTotal]) AS [Total Purchase Amount]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderDetail] AS A
INNER JOIN [AdventureWorks2022].[Production].[Product] AS B
    ON A.[ProductID] = B.[ProductID]
GROUP BY
    B.[Name]
HAVING SUM(A.[LineTotal]) < 10000
ORDER BY
    [Total Purchase Amount] ASC;


/*
    Exercise 3: Exclude Product Names Containing Numbers

    Return the same grouped results as Exercise 2,
    but exclude products whose names contain a number.
*/

SELECT
    B.[Name] AS [Product],
    COUNT(*) AS [Purchase Count],
    SUM(A.[LineTotal]) AS [Total Purchase Amount]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderDetail] AS A
INNER JOIN [AdventureWorks2022].[Production].[Product] AS B
    ON A.[ProductID] = B.[ProductID]
WHERE B.[Name] NOT LIKE '%[0-9]%'
GROUP BY
    B.[Name]
HAVING SUM(A.[LineTotal]) < 10000
ORDER BY
    [Total Purchase Amount] ASC;