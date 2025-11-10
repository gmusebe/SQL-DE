-- #1. Rule | SQL CLAUSES
-- SET Operators can be used in all clauses:
--  WHERE | JOIN | GROUP BY | HAVING
-- ORDER BY is only allowed once and at the end of the query

-- #2. Rule | NUMBER OF COLUMNS MUST BE THE SAME

-- #3. Rule | DATA TYPES
-- Data types of columns in each query must be compatible

-- #4. Rule | ORDER OF COLUMNS
-- Order of columns in each query must be the same

-- #5. Rule | COLUMN ALIASES
-- The column names in the result set are determined by column names specified in the first query

-- #6. Rule | CORRECT COLUMNS
-- The result might be wrong if the incorrect columns have been selected


-- SET OPERATORS
-- UNION: Return all distinct rows from both queries: Removes all duplicates.
--  Each row appears only once.

USE SalesDB;

SELECT
	FirstName AS First_Name,
	LastName AS Last_Name
FROM Sales.Customers
UNION
SELECT
	FirstName,
	LastName
FROM Sales.Employees;

-- UNION ALL: With Duplicates
SELECT
	FirstName AS First_Name,
	LastName AS Last_Name
FROM Sales.Customers
UNION ALL
SELECT
	FirstName,
	LastName
FROM Sales.Employees;

-- EXCEPT
-- Returns all distinct rows from the first query that are not found in the second query
-- Equivalent to the LEFT Anti-join  in terms of columns

SELECT
	FirstName AS First_Name,
	LastName AS Last_Name
FROM Sales.Employees
EXCEPT
SELECT
	FirstName,
	LastName
FROM Sales.Customers;

-- INTERSECT
-- Returns only rows common in both queries (Inner Join😎)
SELECT
	FirstName AS First_Name,
	LastName AS Last_Name
FROM Sales.Employees
INTERSECT
SELECT
	FirstName,
	LastName
FROM Sales.Customers;

-- USE Cases
-- #1. Combine similar tables before data analysis
SELECT
'Orders' AS SourceTable,
[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
FROM Sales.Orders
UNION
SELECT
'OrdersArchive' AS SourceTable,
[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID;

-- #2. Data Engineers: EXCEPT use case DELTA DETECTION
-- Identify the differences between or changes (delta) two batches of data

-- #3. Data Completeness Check
-- EXCEPT can be used to compare tables to detect descripancies between databases - Data Quality
-- Must be empty