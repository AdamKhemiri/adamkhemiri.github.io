/*
    Project: AdventureWorks SQL Practice
    File: 012-sorting-data-with-order-by.sql
    Topic: Sorting Data with ORDER BY
    Database: AdventureWorks2022

    Objective:
    Practice sorting query results using database column names,
    column aliases, and column positions.
*/


/*
    Exercise 1: Sort Using Database Column Names

    Return employee organization, job title, vacation-hour,
    and sick-leave information.

    Sort first by OrganizationLevel in ascending order,
    then by VacationHours in descending order.
*/

SELECT
    [OrganizationLevel] AS [Organization Level],
    [JobTitle] AS [Job Title],
    [VacationHours] AS [Vacation Hours],
    [SickLeaveHours] AS [Sick Leave Hours]
FROM [AdventureWorks2022].[HumanResources].[Employee]
ORDER BY
    [OrganizationLevel] ASC,
    [VacationHours] DESC;


/*
    Exercise 2: Sort Using Column Aliases

    Return the same results as Exercise 1, but use the output
    column aliases in the ORDER BY clause.
*/

SELECT
    [OrganizationLevel] AS [Organization Level],
    [JobTitle] AS [Job Title],
    [VacationHours] AS [Vacation Hours],
    [SickLeaveHours] AS [Sick Leave Hours]
FROM [AdventureWorks2022].[HumanResources].[Employee]
ORDER BY
    [Organization Level] ASC,
    [Vacation Hours] DESC;


/*
    Exercise 3: Sort Using Column Positions

    Return the same results again, but sort using the positions
    of the columns in the SELECT list.

    Column 1 represents Organization Level.
    Column 3 represents Vacation Hours.
*/

SELECT
    [OrganizationLevel] AS [Organization Level],
    [JobTitle] AS [Job Title],
    [VacationHours] AS [Vacation Hours],
    [SickLeaveHours] AS [Sick Leave Hours]
FROM [AdventureWorks2022].[HumanResources].[Employee]
ORDER BY
    1 ASC,
    3 DESC;