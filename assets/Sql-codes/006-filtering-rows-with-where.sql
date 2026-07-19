/*
    Project: AdventureWorks SQL Practice
    File: 006-filtering-rows-with-where.sql
    Topic: Filtering Rows with WHERE
    Database: AdventureWorks2022

    Objective:
    Practice filtering table rows using equality conditions
    in the WHERE clause.
*/


/*
    Exercise 1: Filter People by First Name

    Return records from the Person.Person table where
    the FirstName value is Pilar.

    Include every column except BusinessEntityID,
    rowguid, and ModifiedDate.
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
    [Demographics]
FROM [AdventureWorks2022].[Person].[Person]
WHERE [FirstName] = 'Pilar';


/*
    Exercise 2: Find a Vendor by Name

    Return records from the Purchasing.Vendor table
    where the Name value is Northwind Traders.

    Include every column except BusinessEntityID
    and ModifiedDate.
*/

SELECT
    [AccountNumber],
    [Name],
    [CreditRating],
    [PreferredVendorStatus],
    [ActiveFlag],
    [PurchasingWebServiceURL]
FROM [AdventureWorks2022].[Purchasing].[Vendor]
WHERE [Name] = 'Northwind Traders';


/*
    Exercise 3: Filter Preferred Vendors

    Modify the previous query by commenting out the vendor-name
    filter and filtering for preferred vendors instead.

    Preferred vendors have a PreferredVendorStatus value of 1.
*/

SELECT
    [AccountNumber],
    [Name],
    [CreditRating],
    [PreferredVendorStatus],
    [ActiveFlag],
    [PurchasingWebServiceURL]
FROM [AdventureWorks2022].[Purchasing].[Vendor]
-- WHERE [Name] = 'Northwind Traders'
WHERE [PreferredVendorStatus] = 1;

