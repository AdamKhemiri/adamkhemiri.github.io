/*
    Project: AdventureWorks SQL Practice
    File: 020-working-with-data-types-and-cast.sql
    Topic: Data Types and CAST
    Database: AdventureWorks2022

    Objective:
    Practice converting values between data types, removing
    timestamp components, and converting numerical values
    for use in text expressions.
*/


/*
    Exercise 1: Calculate Yesterday's Date

    Calculate yesterday's date dynamically with GETDATE
    and DATEADD.

    Convert the result to the DATE data type so that
    the timestamp is removed.
*/

SELECT
    CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) AS [Yesterday];


/*
    Exercise 2: Calculate Days Until the End of the Year

    Calculate the number of days between the current date
    and December 31 of the current year.

    Version 1 constructs the end-of-year date with DATEFROMPARTS.
*/

SELECT
    DATEDIFF(
        DAY,
        GETDATE(),
        DATEFROMPARTS(YEAR(GETDATE()), 12, 31)
    ) AS [Days Until End of Year];


/*
    Version 2 constructs the end-of-year date as text
    and converts it to the DATE data type with CAST.
*/

SELECT
    DATEDIFF(
        DAY,
        GETDATE(),
        CAST(CONCAT(YEAR(GETDATE()), '-12-31') AS DATE)
    ) AS [Days Until End of Year];


/*
    Exercise 3: Create a Person ID

    Return people whose MiddleName is not NULL and who also
    have either a Title or a Suffix.

    Create PersonID by combining PersonType, a hyphen,
    and BusinessEntityID.

    Convert BusinessEntityID to VARCHAR before combining it
    with the text values.
*/

SELECT
    [Title],
    [FirstName],
    [MiddleName],
    [LastName],
    [Suffix],
    CONCAT(
        [PersonType],
        '-',
        CAST([BusinessEntityID] AS VARCHAR(10))
    ) AS [PersonID]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [MiddleName] IS NOT NULL
  AND (
        [Title] IS NOT NULL
        OR [Suffix] IS NOT NULL
      );