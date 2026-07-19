/*
    Project: AdventureWorks SQL Practice
    File: 019-date-math-with-dateadd-and-datediff.sql
    Topic: Date Calculations
    Database: AdventureWorks2022

    Objective:
    Practice adding time intervals to dates, calculating
    differences between dates, and building dynamic date filters.
*/


/*
    Exercise 1: Calculate a Date 100 Days from Today

    Use GETDATE and DATEADD to return the date and time
    that occurs 100 days from the current date.
*/

SELECT
    DATEADD(DAY, 100, GETDATE()) AS [Date 100 Days from Today];


/*
    Exercise 2: Calculate a Date Six Months from Today

    Use DATEADD to return the date and time that occurs
    six months from the current date.
*/

SELECT
    DATEADD(MONTH, 6, GETDATE()) AS [Date Six Months from Today];


/*
    Exercise 3: Find Orders Placed Before Christmas

    Return sales orders placed during the seven days leading
    up to and including December 25, 2013.

    Version 1 uses a direct date-range filter.
*/

SELECT *
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
WHERE [OrderDate] >= DATEADD(
        DAY,
        -7,
        DATEFROMPARTS(2013, 12, 25)
      )
  AND [OrderDate] < DATEADD(
        DAY,
        1,
        DATEFROMPARTS(2013, 12, 25)
      );


/*
    Version 2 uses DATEDIFF to calculate the number of days
    between each OrderDate and December 25, 2013.
*/

SELECT *
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
WHERE DATEDIFF(
        DAY,
        [OrderDate],
        DATEFROMPARTS(2013, 12, 25)
      ) BETWEEN 0 AND 7;


/*
    Bonus Exercise: Create a Dynamic Christmas Date Filter

    Return sales orders placed during the seven days leading
    up to and including December 25 of each order's year.

    Version 1 uses a direct date-range filter.
*/

SELECT *
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
WHERE [OrderDate] >= DATEADD(
        DAY,
        -7,
        DATEFROMPARTS(YEAR([OrderDate]), 12, 25)
      )
  AND [OrderDate] < DATEADD(
        DAY,
        1,
        DATEFROMPARTS(YEAR([OrderDate]), 12, 25)
      );


/*
    Version 2 uses DATEDIFF with a dynamically generated
    Christmas date for each order's year.
*/

SELECT *
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
WHERE DATEDIFF(
        DAY,
        [OrderDate],
        DATEFROMPARTS(YEAR([OrderDate]), 12, 25)
      ) BETWEEN 0 AND 7;