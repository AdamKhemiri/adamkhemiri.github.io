/*
    Project: AdventureWorks SQL Practice
    File: 017-advanced-text-manipulation-with-nested-functions.sql
    Topic: LEFT, REPLACE, UPPER, and LOWER
    Database: AdventureWorks2022

    Objective:
    Practice extracting portions of text, nesting string functions,
    and changing text capitalization.
*/


/*
    Exercise 1: Create a Nickname

    Return each person's first and last name.

    Create a Nickname column by combining the first character
    of the first name, a hyphen, and the first three characters
    of the last name.

    Example:
    Adam Khemiri becomes A-Khe.
*/

SELECT
    [FirstName],
    [LastName],
    LEFT([FirstName], 1) + '-' + LEFT([LastName], 3) AS [Nickname]
FROM [AdventureWorks2022].[Person].[Person];


/*
    Exercise 2: Remove Multiple Punctuation Marks

    Return the reviewer name and original comments.

    Create a Cleaned Comments column that removes all
    periods and commas from the Comments value.
*/

SELECT
    [ReviewerName],
    [Comments],
    REPLACE(
        REPLACE([Comments], '.', ''),
        ',',
        ''
    ) AS [Cleaned Comments]
FROM [AdventureWorks2022].[Production].[ProductReview];


/*
    Exercise 3: Change Text Capitalization

    Return each FirstName value.

    Create one derived column that converts the first name
    to uppercase and another that converts it to lowercase.
*/

SELECT
    [FirstName],
    UPPER([FirstName]) AS [FirstNameUpper],
    LOWER([FirstName]) AS [FirstNameLower]
FROM [AdventureWorks2022].[Person].[Person];