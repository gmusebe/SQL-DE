-- NULLS
-- Means nothing, unknown; until filled.
-- It is not equal to zero 

-- NULL to Value
-- ISNULL
-- ISNULL(value, replacement_value)


-- COALESCE***
-- Accepts multiple value checks
-- COALESCE(value1, value2, value3, ...)


-- Average Score for Customers
USE SalesDB;

SELECT 
 CustomerID,
 Score,
 AVG(Score) OVER () AvgScores,
 AVG(COALESCE(Score, 0)) OVER () AvgScores2
FROM sales.Customers;

SELECT 
 AVG(Score) AvgScores,
 AVG(COALESCE(Score, 0)) AvgScores2
FROM sales.Customers;

-- Handling NULL
-- 1. Adding Data
SELECT 
 CustomerID,
 FirstName,
 LastName,
 FirstName + ' ' +  COALESCE(LastName, '') FullName,
 Score,
 COALESCE(Score, '') + 10 AS Added_Score
FROM sales.Customers;

--2. Before Joining Data
SELECT
 a.year, a.type, a.orders, b.sales
FROM Table1 a
INNER JOIN Table2 b
ON a.year = b.year
AND COALESCE(a.type, '') = COALESCE(b.type, '') -- You can replace COALESCE with ISNULL

--2. Before Sorting
SELECT 
 CustomerID,
 Score
FROM sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0  END, Score

-- Value to NULL
-- NULLIF** - Accepts two values
-- Use Case: Prevention the error of dividing by zero
SELECT 
 OrderID,
 ProductID,
 Sales,
 Quantity,
 Sales/ NULLIF(Quantity,0) AS Price
FROM sales.Orders;

-- Check Nulls
-- IS NULL
-- IS NOT NULL
-- Use Case
USE MyDatabase;
SELECT
*
FROM customers
WHERE score IS NULL

SELECT
*
FROM customers
WHERE score IS NOT NULL

-- ANTI JOIN
USE SalesDB;

SELECT
a.*,
b.OrderID
FROM Sales.Customers a
LEFT JOIN Sales.Orders b
ON a.CustomerID = b.CustomerID
WHERE b.CustomerID IS NULL


-- Data Policy
WITH Orders AS (
	SELECT 1 Id, 'A' Category UNION
	SELECT 2, NULL UNION
	SELECT 3,  '' UNION
	SELECT 4, '  '
)
SELECT
	*,
	DATALENGTH(Category) CategoryLen,
	-- Policy 1: Only Use NULLS & Empty Strings ''
	TRIM(Category) AS Policy1,
	DATALENGTH(TRIM(Category)) Policy1Len,
	-- Policy 2: Only use NULLS; NULLIF - If Equal Returns NULL | If Not Equal Returns First Value = NULL
	NULLIF(TRIM(Category), '') Policy2,
	-- Policy 3: For Visualisation, Known Value
	COALESCE(NULLIF(TRIM(Category), ''), 'UNKNOWN') Policy3
FROM Orders;