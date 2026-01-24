-- Standalone CTEs
-- Used Independently in the query
WITH CTE_TotalSales AS
	-- #Step 1: Find the Total Sales per Customer
	(SELECT
		 CustomerID,
		 SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	),
	-- #Step 2: Find the Last Order of each Customer
	-- Multiple CTEs
	CTE_LastOrder AS
	(SELECT 
		CustomerID,
		MAX(OrderDate) LastOrder
	FROM Sales.Orders
	GROUP BY CustomerID
	),
	-- #Step 3: Rank Customers based on Total Sales Per Customer
	CTE_CustomerRank AS
	(SELECT 
		CustomerID,
		TotalSales,
		RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
	FROM CTE_TotalSales
	),
	-- #Step 4: Segment Customers based on their Total Sales
	CTE_CustomerSegments AS
	(SELECT 
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


-- RECURSIVE CTEs
-- Generate a sequence of numbers 1 - 20

WITH Series AS (
-- ANCHOR QUERY
SELECT 
	1 AS MyNumber
	UNION ALL

	--RECURSIVE QUERY
	SELECT
		MyNumber + 1
	FROM Series
	WHERE MyNumber < 20
)

-- MAIN QUERY
SELECT *
FROM Series
OPTION(MAXRECURSION 10)


-- Show Employee Hierarchy and displaying  enployee's level in the Organisation

WITH CTE_EmpHierarchy AS (
	-- ANCHOR QUERY
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