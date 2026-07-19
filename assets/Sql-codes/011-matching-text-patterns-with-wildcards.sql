/*
    Project: AdventureWorks SQL Practice
    File: 011-matching-text-patterns-with-wildcards.sql
    Topic: Text Pattern Matching
    Database: AdventureWorks2022

    Objective:
    Practice filtering text values using LIKE, NOT LIKE,
    wildcard characters, and character lists.
*/


/*
    Exercise 1: Find First Names Ending with a Period

    Return people whose FirstName value ends with a period.
*/

SELECT *
FROM [AdventureWorks2022].[Person].[Person]
WHERE [FirstName] LIKE '%.';


/*
    Exercise 2: Match Multiple Name Patterns

    Return people whose first name begins with T,
    middle name begins with L, and last name begins with C.
*/

SELECT *
FROM [AdventureWorks2022].[Person].[Person]
WHERE [FirstName] LIKE 'T%'
  AND [MiddleName] LIKE 'L%'
  AND [LastName] LIKE 'C%';


/*
    Exercise 3: Find First Names Without Vowels

    Return people whose FirstName does not contain
    any of the vowels a, e, i, o, or u.
*/

SELECT *
FROM [AdventureWorks2022].[Person].[Person]
WHERE [FirstName] NOT LIKE '%[aeiou]%';