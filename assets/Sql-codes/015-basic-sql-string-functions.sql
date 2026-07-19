/*
    Project: AdventureWorks SQL Practice
    File: 015-basic-sql-string-functions.sql
    Topic: RIGHT, REPLACE, and LEN Functions
    Database: AdventureWorks2022

    Objective:
    Practice extracting, replacing, and measuring
    text values with basic SQL string functions.
*/


/*
    Exercise 1: Extract the Last Four Digits

    Return each credit card number and create a derived column
    containing only its last four digits.
*/

SELECT
    [CardNumber],
    RIGHT([CardNumber], 4) AS [Last Four Digits]
FROM [AdventureWorks2022].[Sales].[CreditCard];


/*
    Exercise 2: Remove Commas from Review Comments

    Return the reviewer name and original comments.

    Create a Cleaned Comments column that removes
    all commas from the Comments value.
*/

SELECT
    [ReviewerName],
    [Comments],
    REPLACE([Comments], ',', '') AS [Cleaned Comments]
FROM [AdventureWorks2022].[Production].[ProductReview];


/*
    Exercise 3: Filter by Last Name Length

    Return the first and last names of people whose
    last name contains at least 10 characters.
*/

SELECT
    [FirstName],
    [LastName]
FROM [AdventureWorks2022].[Person].[Person]
WHERE LEN([LastName]) >= 10;


/*
    Bonus Exercise: Sort by Last Name Length

    Return people whose last name contains at least 10 characters.

    Sort the results from the longest last name
    to the shortest last name.
*/

SELECT
    [FirstName],
    [LastName]
FROM [AdventureWorks2022].[Person].[Person]
WHERE LEN([LastName]) >= 10
ORDER BY
    LEN([LastName]) DESC;