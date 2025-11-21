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