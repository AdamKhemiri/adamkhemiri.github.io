/*
    Project: AdventureWorks SQL Practice
    File: 003-aliasing-columns.sql
    Topic: Column Aliases
    Database: AdventureWorks2022

    Objective:
    Practice using column aliases to make query output
    easier to read and understand.
*/


/*
    Exercise 1: Add Spaces to Column Names

    Return employee information and use aliases so that
    each output column contains spaces between its words.
*/

SELECT
    [OrganizationLevel] AS [Organization Level],
    [JobTitle] AS [Job Title],
    [HireDate] AS [Hire Date],
    [VacationHours] AS [Vacation Hours]
FROM [AdventureWorks2022].[HumanResources].[Employee];


/*
    Exercise 2: Rename Product Columns

    Return the Name and ListPrice columns from the
    Production.Product table.

    Rename the output columns to Product Name and List Price $$.
*/

SELECT
    [Name] AS [Product Name],
    [ListPrice] AS [List Price $$]
FROM [AdventureWorks2022].[Production].[Product];


/*
    Exercise 3: Rename Purchase Order Columns

    Return the PurchaseOrderID, OrderQty, and LineTotal columns
    from the Purchasing.PurchaseOrderDetail table.

    Rename PurchaseOrderID to OrderID and OrderQty to
    OrderQuantity. Keep LineTotal unchanged.
*/

SELECT
    [PurchaseOrderID] AS [OrderID],
    [OrderQty] AS [OrderQuantity],
    [LineTotal]
FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderDetail];