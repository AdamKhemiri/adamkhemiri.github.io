/*
    Project: AdventureWorks SQL Practice
    File: 027-preserving-unmatched-records-with-left-join.sql
    Topic: LEFT OUTER JOIN
    Database: AdventureWorks2022

    Objective:
    Practice combining related tables while preserving all rows
    from the primary table, even when no matching record exists.
*/


/*
    Exercise 1: Combine Salespeople with Territories

    Return each salesperson's BusinessEntityID, SalesQuota,
    SalesYTD, and associated territory name.

    Include every salesperson even when no matching territory
    record exists.
*/

SELECT
    A.[BusinessEntityID],
    A.[SalesQuota],
    A.[SalesYTD],
    B.[Name] AS [TerritoryName]
FROM [AdventureWorks2022].[Sales].[SalesPerson] AS A
LEFT OUTER JOIN [AdventureWorks2022].[Sales].[SalesTerritory] AS B
    ON A.[TerritoryID] = B.[TerritoryID];


/*
    Exercise 2: Filter Salespeople by Year-to-Date Sales

    Return the same salesperson and territory information,
    but include only salespeople whose SalesYTD value is
    less than $2,000,000.
*/

SELECT
    A.[BusinessEntityID],
    A.[SalesQuota],
    A.[SalesYTD],
    B.[Name] AS [TerritoryName]
FROM [AdventureWorks2022].[Sales].[SalesPerson] AS A
LEFT OUTER JOIN [AdventureWorks2022].[Sales].[SalesTerritory] AS B
    ON A.[TerritoryID] = B.[TerritoryID]
WHERE A.[SalesYTD] < 2000000;