/*
    Project: AdventureWorks SQL Practice
    File: 025-combining-related-tables-with-inner-joins.sql
    Topic: INNER JOIN
    Database: AdventureWorks2022

    Objective:
    Practice combining related records from multiple tables
    by matching shared key columns.
*/


/*
    Exercise 1: Combine People with Email Addresses

    Return each person's first name, last name,
    and associated email address.

    Join Person.Person and Person.EmailAddress
    using BusinessEntityID.
*/

SELECT
    A.[FirstName],
    A.[LastName],
    B.[EmailAddress]
FROM [AdventureWorks2022].[Person].[Person] AS A
INNER JOIN [AdventureWorks2022].[Person].[EmailAddress] AS B
    ON A.[BusinessEntityID] = B.[BusinessEntityID];


/*
    Exercise 2: Combine Products with Product Reviews

    Return the product name, list price, reviewer name,
    and review comments.

    Join Production.Product and Production.ProductReview
    using ProductID.
*/

SELECT
    A.[Name],
    A.[ListPrice],
    B.[ReviewerName],
    B.[Comments]
FROM [AdventureWorks2022].[Production].[Product] AS A
INNER JOIN [AdventureWorks2022].[Production].[ProductReview] AS B
    ON A.[ProductID] = B.[ProductID];