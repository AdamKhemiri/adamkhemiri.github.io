/*
    Project: AdventureWorks SQL Practice
    File: 007-inequality-and-null-filters.sql
    Topic: Inequality and NULL Conditions
    Database: AdventureWorks2022

    Objective:
    Practice filtering records using inequality operators,
    IS NULL, IS NOT NULL, and combined conditions.
*/


/*
    Exercise 1: Exclude a Person Type

    Return people whose PersonType is not equal to IN.
    Exclude BusinessEntityID and rowguid from the output.
*/

SELECT
    [PersonType],
    [NameStyle],
    [Title],
    [FirstName],
    [MiddleName],
    [LastName],
    [Suffix],
    [EmailPromotion],
    [AdditionalContactInfo],
    [Demographics],
    [ModifiedDate]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [PersonType] <> 'IN';


/*
    Exercise 2: Find People with a Title

    Return people who have a value listed in the Title column.
    Exclude BusinessEntityID and rowguid from the output.
*/

SELECT
    [PersonType],
    [NameStyle],
    [Title],
    [FirstName],
    [MiddleName],
    [LastName],
    [Suffix],
    [EmailPromotion],
    [AdditionalContactInfo],
    [Demographics],
    [ModifiedDate]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [Title] IS NOT NULL;


/*
    Exercise 3: Find People Without a Middle Name

    Return people who do not have a value listed
    in the MiddleName column.

    Exclude BusinessEntityID and rowguid from the output.
*/

SELECT
    [PersonType],
    [NameStyle],
    [Title],
    [FirstName],
    [MiddleName],
    [LastName],
    [Suffix],
    [EmailPromotion],
    [AdditionalContactInfo],
    [Demographics],
    [ModifiedDate]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [MiddleName] IS NULL;


/*
    Bonus Exercise: Exclude the Mr. Title

    Return people whose title is not Mr.
    Include records where the Title value is NULL.
*/

SELECT
    [PersonType],
    [NameStyle],
    [Title],
    [FirstName],
    [MiddleName],
    [LastName],
    [Suffix],
    [EmailPromotion],
    [AdditionalContactInfo],
    [Demographics],
    [ModifiedDate]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [Title] <> 'Mr.'
   OR [Title] IS NULL;