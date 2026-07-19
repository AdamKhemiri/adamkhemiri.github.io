/*
    Project: AdventureWorks SQL Practice
    File: 009-combining-and-or-conditions.sql
    Topic: Combining AND, OR, and IN Conditions
    Database: AdventureWorks2022

    Objective:
    Practice combining AND and OR conditions, grouping criteria
    with parentheses, and simplifying repeated OR conditions with IN.
*/


/*
    Exercise 1: Filter Female Employees by Job Title

    Return female employees whose job title is either
    Network Manager or Application Specialist.

    Use OR to evaluate the two possible job titles.
*/

SELECT *
FROM [AdventureWorks2022].[HumanResources].[Employee]
WHERE [Gender] = 'F'
  AND (
        [JobTitle] = 'Network Manager'
        OR [JobTitle] = 'Application Specialist'
      );


/*
    Exercise 2: Simplify the Job Title Filter with IN

    Return the same employee records as Exercise 1,
    but replace the repeated OR conditions with IN.
*/

SELECT *
FROM [AdventureWorks2022].[HumanResources].[Employee]
WHERE [Gender] = 'F'
  AND [JobTitle] IN (
        'Network Manager',
        'Application Specialist'
      );


/*
    Exercise 3: Find Employees with Missing Name Information

    Return people whose PersonType is EM and who have either
    a missing MiddleName or a missing Title.
*/

SELECT
    [BusinessEntityID],
    [PersonType] AS [Person Type],
    [Title],
    [FirstName] AS [First Name],
    [MiddleName] AS [Middle Name],
    [LastName] AS [Last Name],
    [Suffix]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [PersonType] = 'EM'
  AND (
        [MiddleName] IS NULL
        OR [Title] IS NULL
      );


/*
    Exercise 4: Find Employees or Salespeople with Missing Name Information

    Return people whose PersonType is EM or SP and who have
    a missing MiddleName, Title, or Suffix.
*/

SELECT
    [BusinessEntityID],
    [PersonType] AS [Person Type],
    [Title],
    [FirstName] AS [First Name],
    [MiddleName] AS [Middle Name],
    [LastName] AS [Last Name],
    [Suffix]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [PersonType] IN ('EM', 'SP')
  AND (
        [MiddleName] IS NULL
        OR [Title] IS NULL
        OR [Suffix] IS NULL
      );