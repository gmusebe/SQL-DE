/* ==============================================================================
   SQL SET Operations
-------------------------------------------------------------------------------
   SQL set operations enable you to combine results from multiple queries
   into a single result set. This script demonstrates the rules and usage of
   set operations, including UNION, UNION ALL, EXCEPT, and INTERSECT.
   
   Table of Contents:
     1. SQL Operation Rules
     2. UNION
     3. UNION ALL
     4. EXCEPT
     5. INTERSECT
=================================================================================
*/

/* ==============================================================================
   Rules to Note:
-------------------------------------------------------------------------------
#1. Rule | SQL CLAUSES
    SET Operators can be used in all clauses:
    WHERE | JOIN | GROUP BY | HAVING
    ORDER BY is only allowed once and at the end of the query

#2. Rule | NUMBER OF COLUMNS MUST BE THE SAME

#3. Rule | DATA TYPES
    Data types of columns in each query must be compatible

#4. Rule | ORDER OF COLUMNS
    Order of columns in each query must be the same

#5. Rule | COLUMN ALIASES
    The column names in the result set are determined by column names specified in the first query

#6. Rule | CORRECT COLUMNS
    The result might be wrong if the incorrect columns have been selected
===============================================================================*/

/* ==============================================================================
   RULES OF SET OPERATIONS
===============================================================================*/
USE SalesDB;

/* RULE: Data Types
   The data types of columns in each query should match.
*/
SELECT
    FirstName,
    LastName,
    Country
FROM Sales.Customers
UNION
SELECT
    FirstName,
    LastName
FROM Sales.Employees;

/* RULE: Data Types (Example)
   The data types of columns in each query should match.
*/
SELECT
    CustomerID,
    LastName
FROM Sales.Customers
UNION
SELECT
    FirstName,
    LastName
FROM Sales.Employees;

/* RULE: Column Order
   The order of the columns in each query must be the same.
*/
SELECT
    LastName,
    CustomerID
FROM Sales.Customers
UNION
SELECT
    EmployeeID,
    LastName
FROM Sales.Employees;

/* RULE: Column Aliases
   The column names in the result set are determined by the column names
   specified in the first SELECT statement.
*/
SELECT
    CustomerID AS ID,
    LastName AS Last_Name
FROM Sales.Customers
UNION
SELECT
    EmployeeID,
    LastName
FROM Sales.Employees;

/* RULE: Correct Columns
   Ensure that the correct columns are used to maintain data consistency.
*/
SELECT
    FirstName,
    LastName
FROM Sales.Customers
UNION
SELECT
    LastName,
    FirstName
FROM Sales.Employees;

/* ==============================================================================
   SETS: UNION, UNION ALL, EXCEPT, INTERSECT
===============================================================================*/

/* TASK 1: 
   Combine the data from Employees and Customers into one table using UNION 
*/

-- UNION: Return all distinct rows from both queries: Removes all duplicates.
SELECT
	FirstName AS First_Name,
	LastName AS Last_Name
FROM Sales.Customers
UNION
SELECT
	FirstName,
	LastName
FROM Sales.Employees;

/* TASK 2: 
   Combine the data from Employees and Customers into one table, including duplicates, using UNION ALL 
*/
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

/* TASK 3: 
   Find employees who are NOT customers using EXCEPT 
*/
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

/* TASK 4: 
   Find employees who are also customers using INTERSECT 
*/
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

/* TASK 5: 
   Combine order data from Orders and OrdersArchive into one report without duplicates 
*/
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