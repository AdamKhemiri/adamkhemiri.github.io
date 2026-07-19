/*
    Project: AdventureWorks SQL Practice
    File: 016-combining-values-with-concat-ws.sql
    Topic: CONCAT_WS
    Database: AdventureWorks2022

    Objective:
    Practice combining multiple column values into formatted
    text strings using CONCAT_WS.
*/


/*
    Exercise 1: Create a Full Address

    Combine AddressLine1, AddressLine2, City, and PostalCode
    into one column named Full Address.

    Separate each available address component with a space.
*/

SELECT
    CONCAT_WS(
        ' ',
        [AddressLine1],
        [AddressLine2],
        [City],
        [PostalCode]
    ) AS [Full Address]
FROM [AdventureWorks2022].[Person].[Address];


/*
    Exercise 2: Combine Product Name and Price

    Combine each product name and list price into one column
    named Product Price.

    Separate the values with a colon, space, and dollar sign.
    Include only products with a ListPrice greater than $1,000.
*/

SELECT
    CONCAT_WS(': $', [Name], [ListPrice]) AS [Product Price]
FROM [AdventureWorks2022].[Production].[Product]
WHERE [ListPrice] > 1000;