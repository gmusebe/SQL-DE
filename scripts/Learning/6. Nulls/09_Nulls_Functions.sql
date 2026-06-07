/* ==============================================================================
   SQL NULL Functions
-------------------------------------------------------------------------------
   This script highlights essential SQL functions for managing NULL values.
   It demonstrates how to handle NULLs in data aggregation, mathematical operations,
   sorting, and comparisons. These techniques help maintain data integrity 
   and ensure accurate query results.

   Table of Contents:
     1. Handle NULL - Data Aggregation
     2. Handle NULL - Mathematical Operators
     3. Handle NULL - Sorting Data
     4. NULLIF - Division by Zero
     5. IS NULL - IS NOT NULL
     6. LEFT ANTI JOIN
     7. NULLs vs Empty String vs Blank Spaces
===============================================================================
*/
USE SalesDB;

/* ==============================================================================
   HANDLE NULL - DATA AGGREGATION
===============================================================================*/
/* TASK 1: 
   Find the average scores of the customers.
   Uses COALESCE to replace NULL Score with 0.
*/
SELECT 
	CustomerID,
	Score,
	COALESCE(Score, 0) AS Score2,
	AVG(Score) OVER () AvgScores,
	AVG(COALESCE(Score, 0)) OVER () AvgScores2
FROM sales.Customers;

/* ==============================================================================
   HANDLE NULL - MATHEMATICAL OPERATORS
===============================================================================*/
/* TASK 2: 
   Display the full name of customers in a single field by merging their
   first and last names, and add 10 bonus points to each customer's score.
*/

SELECT 
	CustomerID,
	FirstName,
	LastName,
	CONCAT(FirstName, ' ', COALESCE(LastName, '')) FullName,
	Score,
	COALESCE(Score, '') + 10 AS Added_Score
FROM sales.Customers;

/* ==============================================================================
   HANDLE NULL - SORTING DATA
===============================================================================*/

/* TASK 3: 
   Sort the customers from lowest to highest scores,
   with NULL values appearing last.
*/

SELECT 
 CustomerID,
 Score
FROM sales.Customers
ORDER BY
	CASE WHEN Score IS NULL THEN 1 ELSE 0  END,
	Score

/* ==============================================================================
   NULLIF - DIVISION BY ZERO
   -- Value to NULL
   -- Use Case: Prevention the error of dividing by zero
===============================================================================*/
SELECT 
 OrderID,
 ProductID,
 Sales,
 Quantity,
 NULLIF(Quantity,0) Effect,
 Sales/ NULLIF(Quantity,0) AS Price
FROM sales.Orders;

/* ==============================================================================
   IS NULL - IS NOT NULL
===============================================================================*/
/* TASK 5: 
   Identify the customers who have no scores 
*/

SELECT *
FROM Sales.Customers
WHERE Score IS NULL;

/* TASK 6: 
   Identify the customers who have scores 
*/
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL;

/* ==============================================================================
   LEFT ANTI JOIN
===============================================================================*/
/* TASK 7: 
   List all details for customers who have not placed any orders 
*/

SELECT
	a.*,
	b.OrderID
FROM Sales.Customers a
LEFT JOIN Sales.Orders b
ON a.CustomerID = b.CustomerID
WHERE b.CustomerID IS NULL

/* ==============================================================================
   NULLs vs EMPTY STRING vs BLANK SPACES
===============================================================================*/
/* TASK 8: 
   Demonstrate differences between NULL, empty strings, and blank spaces 
*/

WITH Orders AS (
	SELECT
		1 Id,
		'A' Category
	UNION
	SELECT
		2,
		NULL
	UNION
	SELECT
		3,
		''
	UNION
	SELECT
		4,
		'  '
)
SELECT
	*,
	DATALENGTH(Category) AS CategoryLen,  -- Same as LEN()
	-- Policy 1: Only Use NULLS & Empty Strings ''
	TRIM(Category) AS Policy1,
	DATALENGTH(TRIM(Category)) Policy1Len,
	-- Policy 2: Only use NULLS; NULLIF - If Equal Returns NULL | If Not Equal Returns First Value = NULL
	NULLIF(TRIM(Category), '') Policy2,
	-- Policy 3: For Visualisation, Known Value
	COALESCE(NULLIF(TRIM(Category), ''), 'UNKNOWN') Policy3
FROM Orders;