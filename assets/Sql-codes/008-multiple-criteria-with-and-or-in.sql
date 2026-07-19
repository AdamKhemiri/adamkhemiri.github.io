/*
    Project: AdventureWorks SQL Practice
    File: 008-multiple-criteria-with-and-or-in.sql
    Topic: Multiple Filtering Criteria
    Database: AdventureWorks2022

    Objective:
    Practice combining multiple filtering conditions using
    AND, OR, and the IN operator.
*/


/*
    Exercise 1: Filter by First and Last Name

    Return people whose first name is Laura
    and whose last name is Norman.

    Include only PersonType, Title, FirstName,
    and LastName in the output.
*/

SELECT
    [PersonType],
    [Title],
    [FirstName],
    [LastName]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [FirstName] = 'Laura'
  AND [LastName] = 'Norman';


/*
    Exercise 2: Filter by Multiple Person Types Using OR

    Return people whose PersonType is either SP or EM.
*/

SELECT
    [PersonType],
    [Title],
    [FirstName],
    [LastName]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [PersonType] = 'SP'
   OR [PersonType] = 'EM';


/*
    Exercise 3: Filter by Multiple Person Types Using IN

    Rewrite the previous filter using the IN operator.
*/

SELECT
    [PersonType],
    [Title],
    [FirstName],
    [LastName]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [PersonType] IN ('SP', 'EM');