/*
    Project: AdventureWorks SQL Practice
    File: 014-creating-basic-derived-columns.sql
    Topic: Derived Columns and Basic Calculations
    Database: AdventureWorks2022

    Objective:
    Practice creating derived columns by combining text values
    and performing arithmetic calculations.
*/


/*
    Exercise 1: Create a Person Title

    Create a derived column named Person Title containing
    the person's first name, last name, and person type.

    Format:
    FirstName LastName-PersonType
*/

SELECT
    [FirstName] + ' ' + [LastName] + '-' + [PersonType]
        AS [Person Title]
FROM [AdventureWorks2022].[Person].[Person];


/*
    Exercise 2: Calculate Total Time Off

    Return hourly employees whose SalariedFlag value is 0.

    Calculate Total Time Off by adding VacationHours
    and SickLeaveHours.
*/

SELECT
    [BusinessEntityID],
    [VacationHours],
    [SickLeaveHours],
    [VacationHours] + [SickLeaveHours] AS [Total Time Off]
FROM [AdventureWorks2022].[HumanResources].[Employee]
WHERE [SalariedFlag] = 0
ORDER BY
    [Total Time Off] ASC;


/*
    Exercise 3: Calculate Weekly Pay

    Return employee pay-history records and calculate
    Weekly Pay using the hourly Rate and an assumed
    40-hour workweek.

    Sort the results by Weekly Pay in descending order.
*/

SELECT
    [BusinessEntityID],
    [Rate],
    [Rate] * 40 AS [Weekly Pay]
FROM [AdventureWorks2022].[HumanResources].[EmployeePayHistory]
ORDER BY
    [Weekly Pay] DESC;

/*
    Bonus Exercise: Convert Time-Off Hours to Days

    Calculate Total Days Off using the combined vacation and
    sick-leave hours and an assumed eight-hour workday.

    Divide by 8.0 instead of 8 to prevent integer division.
*/

SELECT
    [BusinessEntityID],
    [VacationHours],
    [SickLeaveHours],
    [VacationHours] + [SickLeaveHours] AS [Total Time Off],
    ([VacationHours] + [SickLeaveHours]) / 8.0 AS [Total Days Off]
FROM [AdventureWorks2022].[HumanResources].[Employee]
WHERE [SalariedFlag] = 0
ORDER BY
    [Total Time Off] ASC;