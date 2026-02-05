-- DDL 
-- CTAS
USE SalesDB;

-- REFRESH/UPDATE CTAS [faster than VIEWS]
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
    DROP TABLE Sales.MonthlyOrders;
GO
SELECT
    DATENAME(month, OrderDate) OrderMonth,
    COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY  DATENAME(month, OrderDate);


-- TEMPORARY TABLES
/*
SELECT...
INTO #New-Table
FROM...
WHERE...
*/

SELECT *
INTO #Orders
FROM Sales.Orders;

SELECT *
FROM #Orders;