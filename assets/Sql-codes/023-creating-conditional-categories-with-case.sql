/*
    Project: AdventureWorks SQL Practice
    File: 023-creating-conditional-categories-with-case.sql
    Topic: CASE Statements
    Database: AdventureWorks2022

    Objective:
    Practice using CASE expressions to classify records
    based on numerical values and multiple conditions.
*/


/*
    Exercise 1: Categorize Products by Price

    Return each product's Name and ListPrice.

    Create a Price Category column with the following values:

    - Premium for products priced at $1,000 or more
    - Mid-Range for products priced above $100 but below $1,000
    - Value for all remaining products
*/

SELECT
    [Name],
    [ListPrice],
    CASE
        WHEN [ListPrice] >= 1000 THEN 'Premium'
        WHEN [ListPrice] > 100 THEN 'Mid-Range'
        ELSE 'Value'
    END AS [Price Category]
FROM [AdventureWorks2022].[Production].[Product];


/*
    Exercise 2: Categorize Employees by Tenure

    Return each employee's BusinessEntityID, HireDate,
    and SalariedFlag.

    Create an Employee Tenure column based on salaried status
    and the number of years between HireDate and the current date.
*/

SELECT
    [BusinessEntityID],
    [HireDate],
    [SalariedFlag],
    CASE
        WHEN [SalariedFlag] = 1
         AND DATEDIFF(YEAR, [HireDate], GETDATE()) >= 10
            THEN 'Non-Exempt - 10+ Years'

        WHEN [SalariedFlag] = 1
         AND DATEDIFF(YEAR, [HireDate], GETDATE()) < 10
            THEN 'Non-Exempt - < 10 Years'

        WHEN [SalariedFlag] = 0
         AND DATEDIFF(YEAR, [HireDate], GETDATE()) >= 10
            THEN 'Exempt - 10+ Years'

        ELSE 'Exempt - < 10 Years'
    END AS [Employee Tenure]
FROM [AdventureWorks2022].[HumanResources].[Employee];