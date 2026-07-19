/*
    Project: AdventureWorks SQL Practice
    File: 013-selecting-unique-values-with-distinct.sql
    Topic: Selecting Unique Values
    Database: AdventureWorks2022

    Objective:
    Practice removing duplicate results with DISTINCT
    and sorting unique values with ORDER BY.
*/


/*
    Exercise 1: Select Unique Person Types

    Return a list of the unique PersonType values
    from the Person.Person table.

    Sort the results in ascending order.
*/

SELECT DISTINCT
    [PersonType]
FROM [AdventureWorks2022].[Person].[Person]
ORDER BY
    [PersonType] ASC;


/*
    Exercise 2: Select Unique Name Combinations

    Return unique combinations of FirstName, MiddleName,
    and LastName.

    Include only people who have a MiddleName value.
    Sort first by LastName and then by FirstName,
    both in ascending order.
*/

SELECT DISTINCT
    [FirstName],
    [MiddleName],
    [LastName]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [MiddleName] IS NOT NULL
ORDER BY
    [LastName] ASC,
    [FirstName] ASC;