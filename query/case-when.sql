-- Evaluates a list of conditions and returns a value when the first condition is met

-- SYNTAX
-- CASE
--     WHEN COND_1 THEN RESULT_1
--     WHEN CONND_2 THEN RESULT_2
--     ...
--     ELSE RESULT

-- END

-- USE CASE
-- GENERATING NEW COLUMNS FOR ANALYTICS
-- CATEGORIZE DATA:
USE SalesDB;


-- SUBQUERY

SELECT
	Category,
	SUM(Sales) AS TotalSales
FROM(
	SELECT 
		OrderID,
		Sales,
		CASE
			WHEN Sales > 50 THEN 'High'
			WHEN Sales > 20 THEN 'Medium'
			ELSE 'Low'
		END Category
	FROM Sales.Orders
)t
GROUP BY
	Category
ORDER BY TotalSales DESC

-- MAP VALUES
-- Retrieve employee details with gender displayed as full text
SELECT
	EmployeeID,
	FirstName,
	LastName,
	Gender,
	CASE 
		WHEN Gender = 'F' THEN 'Female'
		WHEN Gender = 'M' THEN 'Male'
		ELSE 'Not Available'
	END Gender_F
FROM Sales.Employees;

-- Retrieve customer details with abbreviated country code:
SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'Not Available'
	END CountryAbbr
FROM Sales.Customers;


-- Short/Quick Form
SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'Not Available'
	END CountryAbbr
FROM Sales.Customers;

-- Handling Nulls
SELECT 
	CustomerID,
	LastName,
	FirstName,
	Score,
	CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END Score2, 
	AVG(Score) OVER()  AvgCustomer,
	AVG(CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END) OVER() AvgCustomer2
FROM Sales.Customers

-- Conditional Aggregation
-- Count how many times each customer has made and order with sales greater than 30
SELECT
	OrderID,
	CustomerID,
	Sales,
	CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END Flag
FROM Sales.Orders
ORDER BY CustomerID


SELECT
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID