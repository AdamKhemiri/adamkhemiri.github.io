/*
    Project: AdventureWorks SQL Practice
    File: 001-sql-string-functions-practice.sql
    Topic: SQL String Functions
    Database: AdventureWorks2022

    Objective:
    Practice using LEN, RIGHT, and REPLACE to format
    and clean text values.
*/


/*
    Exercise 1: Format National ID Numbers

    Display each employee's National ID number and its current length.
    Format each value so that it contains exactly 10 characters by
    adding zeros to the left when necessary.
*/

SELECT
    [NationalIDNumber],
    LEN([NationalIDNumber]) AS [OriginalLength],
    RIGHT('0000000000' + [NationalIDNumber], 10) AS [PaddedNationalID]
FROM [AdventureWorks2022].[HumanResources].[Employee];


/*
    Exercise 2: Clean Product Descriptions

    Clean the Description column by removing semicolons
    and periods from the text.
*/

SELECT
    [Description],
    REPLACE(
        REPLACE([Description], ';', ''),
        '.',
        ''
    ) AS [CleanedDescription]
FROM [AdventureWorks2022].[Production].[ProductDescription];