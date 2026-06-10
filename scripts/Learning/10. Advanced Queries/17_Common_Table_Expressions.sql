/* ==============================================================================
   SQL Common Table Expressions (CTEs)
-------------------------------------------------------------------------------
   This script demonstrates the use of Common Table Expressions (CTEs) in SQL Server.
   It includes examples of non-recursive CTEs for data aggregation and segmentation,
   as well as recursive CTEs for generating sequences and building hierarchical data.

   Table of Contents:
     1. NON-RECURSIVE CTE
     2. RECURSIVE CTE | GENERATE SEQUENCE
     3. RECURSIVE CTE | BUILD HIERARCHY
===============================================================================
*/
USE SalesDB;

/* ==============================================================================
   NON-RECURSIVE CTE
===============================================================================*/
-- Standalone CTEs
-- Used Independently in the query
WITH CTE_TotalSales AS (
	-- #Step 1: Find the Total Sales per Customer
	SELECT
		CustomerID,
		SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
),
CTE_LastOrder AS (
	-- #Step 2: Find the Last Order of each Customer
	-- Multiple CTEs
	SELECT 
		CustomerID,
		MAX(OrderDate) LastOrder
	FROM Sales.Orders
	GROUP BY CustomerID
),
CTE_CustomerRank AS (
	-- #Step 3: Rank Customers based on Total Sales Per Customer
	SELECT 
		CustomerID,
		TotalSales,
		RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
	FROM CTE_TotalSales
),
CTE_CustomerSegments AS (
	-- #Step 4: Segment Customers based on their Total Sales
	SELECT 
		CustomerID,
		CASE
			WHEN TotalSales > 100 THEN 'High'
			WHEN TotalSales > 50 THEN 'Medium'
			ELSE 'Low'
		END CustomerSegments
	FROM CTE_TotalSales
)
-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.TotalSales,
	clo.LastOrder,
	ccr.CustomerRank,
	ccs.CustomerSegments
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts
ON cts.CustomerID =c.CustomerID
LEFT JOIN CTE_LastOrder clo
ON clo.CustomerID =c.CustomerID
LEFT JOIN CTE_CustomerRank ccr
ON ccr.CustomerID =c.CustomerID
LEFT JOIN CTE_CustomerSegments ccs
ON ccs.CustomerID =c.CustomerID


/* ==============================================================================
   RECURSIVE CTE | GENERATE SEQUENCE
===============================================================================*/
/* TASK 2:
   Generate a sequence of numbers from 1 to 20.
*/

WITH Series AS (
	-- Anchor Query
	SELECT 1 AS MyNumber
	UNION ALL
	--Recursive Query
	SELECT
		MyNumber + 1
	FROM Series
	WHERE MyNumber < 20
)
-- Main Query
SELECT *
FROM Series
OPTION(MAXRECURSION 20)

/* ==============================================================================
   RECURSIVE CTE | BUILD HIERARCHY
===============================================================================*/
-- Show Employee Hierarchy and displaying  each employee's level whithin the Organisation
WITH CTE_EmpHierarchy AS (
	-- Anchor Query
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID IS NULL
	UNION ALL
	--Recursive Query
	SELECT
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level + 1
	FROM Sales.Employees AS e
	INNER JOIN CTE_EmpHierarchy ceh
	ON  e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT *
FROM CTE_EmpHierarchy