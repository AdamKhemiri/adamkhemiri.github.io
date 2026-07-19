/*
    Project: AdventureWorks SQL Practice
    File: 005-select-all-columns-and-top-rows.sql
    Topic: SELECT * and TOP
    Database: AdventureWorks2022

    Objective:
    Practice returning all columns from a table and limiting
    the number of rows returned using the TOP clause.
*/


/*
    Exercise 1: Select All Customer Data

    Return all columns and all rows from the
    Sales.Customer table.
*/

SELECT *
FROM [AdventureWorks2022].[Sales].[Customer];


/*
    Exercise 2: Select the First 100 Products

    Return all columns from the Production.Product table
    and limit the output to 100 rows.
*/

SELECT TOP (100)
    *
FROM [AdventureWorks2022].[Production].[Product];