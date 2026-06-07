/* ==============================================================================
   SQL CASE Statement
-------------------------------------------------------------------------------
   This script demonstrates various use cases of the SQL CASE statement, including
   data categorization, mapping, quick form syntax, handling nulls, and conditional 
   aggregation.

   Evaluates a list of conditions and returns a value when the first condition is met.
   
   Table of Contents:
     1. Categorize Data
     2. Mapping
     3. Quick Form of Case Statement
     4. Handling Nulls
     5. Conditional Aggregation

		SYNTAX:
			CASE
				WHEN COND_1 THEN RESULT_1
				WHEN CONND_2 THEN RESULT_2
				...
				ELSE RESULT
			END
=================================================================================
*/
USE SalesDB;

/* ==============================================================================
   USE CASE: CATEGORIZE DATA
===============================================================================*/
/* TASK 1: 
   Create a report showing total sales for each category:
	   - High: Sales over 50
	   - Medium: Sales between 20 and 50
	   - Low: Sales 20 or less
   The results are sorted from highest to lowest total sales.
*/

SELECT
	Category,
	SUM(Sales) AS TotalSales
FROM(
	--SubQuery
	SELECT 
		OrderID,
		Sales,
		-- Categorisation:
		CASE
			WHEN Sales > 50 THEN 'High'
			WHEN Sales > 20 THEN 'Medium'
			ELSE 'Low'
		END Category
	FROM Sales.Orders
)t
GROUP BY
	Category
ORDER BY TotalSales DESC;

/* ==============================================================================
   USE CASE: MAPPING
===============================================================================*/
/* TASK 2: 
   Retrieve customer details with abbreviated country codes 
*/

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	-- Mapping
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'Not Available'
	END CountryAbbr
FROM Sales.Customers;

-- Retrieve employee details with gender displayed as full text
SELECT
	EmployeeID,
	FirstName,
	LastName,
	Gender,
	-- Mapping
	CASE 
		WHEN Gender = 'F' THEN 'Female'
		WHEN Gender = 'M' THEN 'Male'
		ELSE 'Not Available'
	END Gender_F
FROM Sales.Employees;

/* ==============================================================================
   QUICK FORM SYNTAX
===============================================================================*/
/* TASK 3: 
   Retrieve customer details with abbreviated country codes using quick form 
*/
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE 
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA'     THEN 'US'
        ELSE 'n/a'
    END AS CountryAbbr,
	-- Quick Form
    CASE Country
        WHEN 'Germany' THEN 'DE'
        WHEN 'USA'     THEN 'US'
        ELSE 'n/a'
    END AS CountryAbbr2
FROM Sales.Customers;

/* ==============================================================================
   HANDLING NULLS
===============================================================================*/
/* TASK 4: 
   Calculate the average score of customers, treating NULL as 0,
   and provide CustomerID and LastName details.
*/
SELECT 
	CustomerID,
	LastName,
	FirstName,
	Score,
	CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END AS ScoreClean, 
	AVG(
		CASE
			WHEN Score IS NULL THEN 0
			ELSE Score
		END
	) OVER() AS AvgCustomerClean,
	AVG(Score) OVER()  AvgCustomer
FROM Sales.Customers

/* ==============================================================================
   CONDITIONAL AGGREGATION
===============================================================================*/
/* TASK 5: 
   Count how many orders each customer made with sales greater than 30 
*/
SELECT
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) AS TotalOrdersHighSales,
	COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY CustomerID
