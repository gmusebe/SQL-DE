-- Write a query
-- For US Customers Find the total number of customers and the average score
USE SalesDB;

SELECT
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA';

-- Turn Query into a stored procedure:
/*...
CREATE PROCEDURE GetCustomerSummary AS
BEGIN

    SELECT
        COUNT(*) TotalCustomers,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA'
END;


-- Execute the Stored Procedure
EXEC GetCustomerSummary;
...*/


-- PARAMETERS
-- For German Customers  Find the total number of customers and the average score:
/*
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
SELECT
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'Germany'
END

-- Execute the Stored Procedure
EXEC GetCustomerSummary;
...*/

-- PARAMETERS
-- For German Customers  Find the total number of customers and the average score:
/*
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) AS
BEGIN
SELECT
    COUNT(*) TotalCustomeXrs,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country
END
*/

-- Execute the Stored Procedure
/* EXEC GetCustomerSummary @Country = 'Germany'; */

/*  EXEC GetCustomerSummary @Country = 'USA'; */


-- DROP
DROP PROCEDURE GetCustomerSummaryGermany;

-- Setting Default value
/*
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS 
BEGIN
SELECT
    COUNT(*) TotalCustomeXrs,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country
END

EXEC GetCustomerSummary @Country  = 'USA';
*/

-- Multi Queries in Stored Procedures
--  Find the total Nr. of Orders  and Total Sales
SELECT
    COUNT(OrderID) TotalOrders,
    SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE C.Country = 'USA'



ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS 
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;

    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
    PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR) ;

    --  Find the total Nr. of Orders  and Total Sales
    SELECT
        COUNT(OrderID) TotalOrders,
        SUM(Sales) TotalSales
    FROM Sales.Orders o
    JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    WHERE C.Country = @Country;

END

EXEC GetCustomerSummary @Country = 'Germany'


-- Variables