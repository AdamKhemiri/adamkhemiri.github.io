/*
    Project: AdventureWorks SQL Practice
    File: 004-custom-values-and-literal-columns.sql
    Topic: Custom Values and Literal Columns
    Database: AdventureWorks2022

    Objective:
    Practice returning custom values and adding constant
    text or numeric columns to query results.
*/


/*
    Exercise 1: Return Custom Personal Values

    Return a first name and age as custom values.
    Name the output columns First Name and Age.
*/

SELECT
    'Adam' AS [First Name],
    26 AS [Age];


/*
    Exercise 2: Add a Custom Column to Sales Orders

    Return the first 5,000 rows from the
    Sales.SalesOrderHeader table.

    Include every column except rowguid and ModifiedDate.
    Add a column named Query Run By as the first column
    and display the name Adam in every returned row.
*/

SELECT TOP (5000)
    'Adam' AS [Query Run By],
    [SalesOrderID],
    [RevisionNumber],
    [OrderDate],
    [DueDate],
    [ShipDate],
    [Status],
    [OnlineOrderFlag],
    [SalesOrderNumber],
    [PurchaseOrderNumber],
    [AccountNumber],
    [CustomerID],
    [SalesPersonID],
    [TerritoryID],
    [BillToAddressID],
    [ShipToAddressID],
    [ShipMethodID],
    [CreditCardID],
    [CreditCardApprovalCode],
    [CurrencyRateID],
    [SubTotal],
    [TaxAmt],
    [Freight],
    [TotalDue],
    [Comment]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];