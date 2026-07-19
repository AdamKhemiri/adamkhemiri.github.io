/*
    Project: AdventureWorks SQL Practice
    File: 002-selecting-columns-and-top-rows.sql
    Topic: Selecting Columns and Limiting Results
    Database: AdventureWorks2022

    Objective:
    Practice selecting specific columns and limiting the number
    of rows returned using the TOP clause.
*/


/*
    Exercise 1: Select Person Information

    Return the first 3,000 rows from the Person.Person table.
    Display the Title, LastName, and FirstName columns in that order.
*/

SELECT TOP (3000)
    [Title],
    [LastName],
    [FirstName]
FROM [AdventureWorks2022].[Person].[Person];


/*
    Exercise 2: Select Sales Order Information

    Return the first 500 rows from the Sales.SalesOrderHeader table.
    Display the OrderDate, DueDate, ShipDate, and TotalDue columns
    in that order.
*/

SELECT TOP (500)
    [OrderDate],
    [DueDate],
    [ShipDate],
    [TotalDue]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];


/*
    Exercise 3: Select Salesperson Performance Data

    Return the first 100 rows from the Sales.SalesPerson table.
    Display the SalesLastYear and SalesYTD columns in that order.
*/

SELECT TOP (100)
    [SalesLastYear],
    [SalesYTD]
FROM [AdventureWorks2022].[Sales].[SalesPerson];