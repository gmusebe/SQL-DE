-- Performance Tips: FETCHING DATA
-- =============================================
-- Tip 1: Select Only What You Need
-- =============================================
USE SalesDB;

-- Bad Practice
SELECT *
FROM Sales.Customers;

-- Good Practice
SELECT 
	CustomerID,
	FirstName,
	LastName
FROM
	Sales.Customers;

-- =============================================
-- Tip 2: Avoid Unnecessary DISTINCT & ORDER BY
-- =============================================

-- Bad Practice
SELECT DISTINCT
	FirstName
FROM 
	Sales.Customers
ORDER BY FirstName;

-- Good Practice
SELECT
	FirstName
FROM 
	Sales.Customers;


-- =============================================
-- Tip 3: For Exploration Purposes, Limit Rows!
-- =============================================

-- Bad Practice
SELECT
	OrderID,
	Sales
FROM Sales.Orders;

-- Good Practice
SELECT TOP 10
	OrderID,
	Sales
FROM Sales.Orders;

-- Performance Tips: FILTERING
-- ===========================================================================
-- Tip 4: Create Nonclustered Index on Frequently used Columns in WHERE Clause
-- ===========================================================================
SELECT * FROM Sales.Orders WHERE OrderStatus = 'Delivered'

CREATE NONCLUSTERED INDEX Idx_Orders_OrderStatus
ON Sales.Orders(OrderStatus);

-- ==========================================================
-- Tip 5: Avoid Applying functions to columns in WHERE Clause
-- ==========================================================

-- Bad Practice
SELECT * FROM Sales.Orders
WHERE LOWER(OrderStatus) = 'delivered'; --SQL will not use the Index

-- Good Practice
SELECT * FROM Sales.Orders
WHERE OrderStatus = 'Delivered';


-- Example 2
-- Bad Practice
SELECT *
FROM Sales.Customers
WHERE SUBSTRING(FirstName, 1, 1) = 'A';

-- Good Practice
SELECT *
FROM Sales.Customers
WHERE FirstName LIKE 'A%';

-- ==========================================================
-- Tip 6: Avoid Leading Wildcards as they prevent index usage
-- ==========================================================

-- Bad Practice
SELECT *
FROM Sales.Customers
WHERE LastName LIKE '%Gold%'; --SQL will not use the Index


-- Good Practice
SELECT *
FROM Sales.Customers
WHERE LastName LIKE 'Gold%';

-- =====================================
-- Tip 7: Use IN Insted of Multiple ORs
-- =====================================

-- Bad Practice
SELECT *
FROM Sales.Orders
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3;

-- Good Practice
SELECT *
FROM Sales.Orders
WHERE CustomerID IN ( 1, 2, 3);


-- Performance Tips: JOINING
-- =============================================================================
-- Tip 8: Use Explicit Join (ANSI Join) Instead of Implicit Join (non-ANSI Join)
-- =============================================================================

-- Bad Practice
SELECT
	o.OrderID,
	c.FirstName
FROM
	Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID;

-- Good Practice - Good Readability, Same Performance
SELECT
	o.OrderID,
	c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID;

-- =======================================================
-- Tip 9: Make sure to Index the columns used in ON Clause
-- =======================================================
SELECT
	c.FirstName,
	o.orderID
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID;


CREATE NONCLUSTERED INDEX Idx_Orders_CustomerID
ON Sales.Orders(CustomerID)

CREATE NONCLUSTERED INDEX Idx_Customers_CustomerID
ON Sales.Customers(CustomerID)


-- ==========================================
-- Tip 10: Filter Before Joining (Big Tables)
-- ==========================================

-- Filter After Join (WHERE)
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered';



-- Filter During Join (ON)
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
AND o.OrderStatus = 'Delivered';

-- Filter Before Join (SUBQUERY) -- Best
-- Isolate the Preparation Step in a CTE or subquery
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN (
	SELECT OrderID, CustomerID
	FROM Sales.Orders
	WHERE OrderStatus = 'Delivered'
) o
ON c.CustomerID = o.CustomerID
AND o.OrderStatus = 'Delivered';


-- ==========================================
-- Tip 11: Aggregate Before Joining (Big Tables)
-- ==========================================
-- Best Practice
SELECT 
	c.CustomerID,
	c.FirstName,
	o.OrderCount
FROM Sales.Customers c
INNER JOIN(
	SELECT
		CustomerID,
		Count(OrderID) OrderCount
	FROM Sales.Orders
	GROUP BY CustomerID
) o
ON c.CustomerID = o.CustomerID


-- ====================================================
-- Tip 12: Use Union Instead of OR while Joining Tables
-- ====================================================
-- Bad Practice
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OR c.CustomerID = o.SalesPersonID --Performance Killer


-- Good Practice
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
UNION
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.SalesPersonID

-- ====================================================
-- Tip 13: Check for Nested Loops & Use SQL Hints
-- ====================================================
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- Good Practice
SELECT 
	c.FirstName,
	o.orderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN)


-- =============================================================
-- Tip 14: Use UNION ALL  instead of UNION  | Accept Duplicates
-- =============================================================
SELECT CustomerID FROM Sales.Orders
UNION
SELECT CustomerID FROM Sales.OrdersArchive

-- Best Practice
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchive

-- =================================================================================
-- Tip 15: Use UNION ALL + DISTINCT  instead of USING UNION  | Accept Not Duplicates
-- =================================================================================
-- Bad
SELECT CustomerID FROM Sales.Orders
UNION
SELECT CustomerID FROM Sales.OrdersArchive


-- Best Practice
SELECT DISTINCT CustomerID
FROM(
	SELECT CustomerID FROM Sales.Orders
	UNION ALL
	SELECT CustomerID FROM Sales.OrdersArchive
) AS CombinedDATA


-- Performance Tips: AGGREGATION
-- ===============================================================
-- Tip 16: Use	COLUMNSTORE Index for Aggregations on Large Tables
-- ===============================================================
SELECT
	CustomerID,
	COUNT(OrderID) OrderCount
FROM Sales.Orders
GROUP BY CustomerID

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_ColumnStore
ON Sales.Orders


-- ==================================================================
-- Tip 17: Pre-Aggregate Data and store it in new Table for Reporting
-- ==================================================================
-- For Large Tables for Reporting
-- To be Updated to get UpToDate Summaries
SELECT
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) TotalSales
/*KEY*/
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY MONTH(OrderDate);


-- Performance Tips: SUBQUERIES
-- ===============================================================
-- Tip 18: 
-- ===============================================================
-- EXISTS -- Best Practice
SELECT
	o.OrderID,
	o.Sales
FROM Sales.Orders o
WHERE EXISTS (
	SELECT 1
	FROM Sales.Customers c
	WHERE c.CustomerID = O.CustomerID
	AND c.Country = 'USA'
)

-- =============================
-- Tip 19: Avoid Redundant Logic
-- =============================

SELECT 
	EmployeeID,
	FirstName,
	'Above Average' [Status]
FROM Sales.Employees
WHERE Salary > (SELECT AVG(Salary) FROM Sales.Employees)
UNION ALL
SELECT 
	EmployeeID,
	FirstName,
	'Below Average' [Status]
FROM Sales.Employees
WHERE Salary < (SELECT AVG(Salary) FROM Sales.Employees)

-- Redudnt Query Fix Them
-- Best
SELECT 
	EmployeeID,
	FirstName,
	CASE
		WHEN Salary > AVG(Salary) OVER() THEN 'Above Average'
		WHEN Salary < AVG(Salary) OVER() THEN 'Below Average'
		ELSE 'Average'
	END [Status]
FROM Sales.Employees


-- Performance Tips: DDL
-- =============================================================================================
-- Tip 20: Avoid VARCHAR & TEXT | Avoid MAX & Large Links | USE NOT NULL | CLUSTERED Primary Key
-- =============================================================================================
CREATE TABLE CustomerInfo(
	CustomerID INT PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Country VARCHAR(15) NOT NULL,
	TotalPurchase FLOAT,
	Score INT,
	Birthdate DATE,
	EmployeeID INT,
	-- NONCLUSTERED Index for foreign Keys
	CONSTRAINT FK_CustomerInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

CREATE NONCLUSTERED INDEX Idx_Good_Customers_EmployeeID
ON CustomerInfo(EmployeeID)

-- Performance Tips: INDEXING
-- =======================================================
-- Tip 21: Avoid Over Indexing
-- Tip 22: Drop unused Indexes
-- Tip 23: Update Statistics (Weekly)
-- Tip 24: Rebuild & Reorganize Indexes (Weekly)
-- =======================================================