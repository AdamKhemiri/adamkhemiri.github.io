/*
    Project: AdventureWorks SQL Practice
    File: 030-grouping-aggregate-calculations-with-group-by.sql
    Topic: GROUP BY, COUNT, SUM, and ISNULL
    Database: AdventureWorks2022

    Objective:
    Practice grouping records, calculating aggregate values,
    and replacing NULL values in grouped results.
*/


/*
    Exercise 1: Count Products by Color

    Display the number of products associated with each color.
*/

SELECT
    [Color],
    COUNT(*) AS [Product Count]
FROM [AdventureWorks2022].[Production].[Product]
GROUP BY
    [Color];


/*
    Exercise 2: Group Products by Color and Style

    Display the number of products and the total ListPrice
    for each Color and Style combination.
*/

SELECT
    [Color],
    [Style],
    COUNT(*) AS [Product Count],
    SUM([ListPrice]) AS [List Price Total]
FROM [AdventureWorks2022].[Production].[Product]
GROUP BY
    [Color],
    [Style];


/*
    Exercise 3: Replace NULL Group Values

    Return the same grouped summary as Exercise 2.

    Replace NULL Color values with No Color and
    NULL Style values with NA.
*/

SELECT
    ISNULL([Color], 'No Color') AS [Color],
    ISNULL([Style], 'NA') AS [Style],
    COUNT(*) AS [Product Count],
    SUM([ListPrice]) AS [List Price Total]
FROM [AdventureWorks2022].[Production].[Product]
GROUP BY
    ISNULL([Color], 'No Color'),
    ISNULL([Style], 'NA');