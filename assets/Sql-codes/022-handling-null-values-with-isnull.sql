/*
    Project: AdventureWorks SQL Practice
    File: 022-handling-null-values-with-isnull.sql
    Topic: Handling NULL Values with ISNULL
    Database: AdventureWorks2022

    Objective:
    Practice replacing NULL values with temporary replacement
    values for filtering and displaying query results.
*/


/*
    Exercise 1: Include Products with NULL Weights

    Return products whose Weight is less than 10.

    Use ISNULL to temporarily treat NULL Weight values as 0
    so that those records are included in the results.

    Display the product Name and Color.
*/

SELECT
    [Name],
    [Color]
FROM [AdventureWorks2022].[Production].[Product]
WHERE ISNULL([Weight], 0) < 10;


/*
    Exercise 2: Replace Missing Colors

    Return the same products as Exercise 1.

    Replace NULL values in the Color column with the word None.
*/

SELECT
    [Name],
    ISNULL([Color], 'None') AS [Color]
FROM [AdventureWorks2022].[Production].[Product]
WHERE ISNULL([Weight], 0) < 10;