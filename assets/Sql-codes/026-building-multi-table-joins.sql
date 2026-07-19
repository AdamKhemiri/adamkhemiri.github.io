/*
    Project: AdventureWorks SQL Practice
    File: 026-building-multi-table-joins.sql
    Topic: Multi-Table INNER JOINs
    Database: AdventureWorks2022

    Objective:
    Practice combining data from several related tables,
    filtering joined results, and using a bridge table
    when two tables do not share a direct relationship.
*/


/*
    Exercise 1: Combine Contact Information

    Return each person's first name, last name,
    email address, and phone number.

    Join the Person, EmailAddress, and PersonPhone tables
    using their shared BusinessEntityID column.
*/

SELECT
    A.[FirstName],
    A.[LastName],
    B.[EmailAddress],
    C.[PhoneNumber]
FROM [AdventureWorks2022].[Person].[Person] AS A
INNER JOIN [AdventureWorks2022].[Person].[EmailAddress] AS B
    ON A.[BusinessEntityID] = B.[BusinessEntityID]
INNER JOIN [AdventureWorks2022].[Person].[PersonPhone] AS C
    ON A.[BusinessEntityID] = C.[BusinessEntityID];


/*
    Exercise 2: Filter Phone Numbers by Area Code

    Return the same contact information as Exercise 1,
    but include only phone numbers beginning with the
    Seattle area code 206.
*/

SELECT
    A.[FirstName],
    A.[LastName],
    B.[EmailAddress],
    C.[PhoneNumber]
FROM [AdventureWorks2022].[Person].[Person] AS A
INNER JOIN [AdventureWorks2022].[Person].[EmailAddress] AS B
    ON A.[BusinessEntityID] = B.[BusinessEntityID]
INNER JOIN [AdventureWorks2022].[Person].[PersonPhone] AS C
    ON A.[BusinessEntityID] = C.[BusinessEntityID]
WHERE C.[PhoneNumber] LIKE '206%';


/*
    Exercise 3: Add City Using a Bridge Table

    Return the same filtered contact information and include
    the city associated with each person's address.

    Person.Person and Person.Address do not share a direct key.
    Use Person.BusinessEntityAddress as a bridge between them.
*/

SELECT
    A.[FirstName],
    A.[LastName],
    B.[EmailAddress],
    C.[PhoneNumber],
    E.[City]
FROM [AdventureWorks2022].[Person].[Person] AS A
INNER JOIN [AdventureWorks2022].[Person].[EmailAddress] AS B
    ON A.[BusinessEntityID] = B.[BusinessEntityID]
INNER JOIN [AdventureWorks2022].[Person].[PersonPhone] AS C
    ON A.[BusinessEntityID] = C.[BusinessEntityID]
INNER JOIN [AdventureWorks2022].[Person].[BusinessEntityAddress] AS D
    ON A.[BusinessEntityID] = D.[BusinessEntityID]
INNER JOIN [AdventureWorks2022].[Person].[Address] AS E
    ON D.[AddressID] = E.[AddressID]
WHERE C.[PhoneNumber] LIKE '206%';