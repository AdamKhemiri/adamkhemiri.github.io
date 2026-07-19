/*
    Project: AdventureWorks SQL Practice
    File: 032-combining-grouped-values-with-string-agg.sql
    Topic: STRING_AGG with GROUP BY and HAVING
    Database: AdventureWorks2022

    Objective:
    Practice grouping sales-order details, calculating aggregate
    totals, and combining multiple product names into one
    comma-separated text value.
*/


/*
    Exercise: Summarize Products by Sales Order

    Return one row for each distinct SalesOrderID.

    For each sales order:
    - Calculate the sum of its LineTotal values.
    - Create an alphabetically sorted, comma-separated list
      of its product names.
    - Include only orders whose total LineTotal exceeds $5,000.
*/

SELECT
    A.[SalesOrderID],
    SUM(A.[LineTotal]) AS [Line Total Sum],
    STRING_AGG(B.[Name], ', ')
        WITHIN GROUP (ORDER BY B.[Name] ASC) AS [Product Names]
FROM [AdventureWorks2022].[Sales].[SalesOrderDetail] AS A
INNER JOIN [AdventureWorks2022].[Production].[Product] AS B
    ON A.[ProductID] = B.[ProductID]
GROUP BY
    A.[SalesOrderID]
HAVING
    SUM(A.[LineTotal]) > 5000;