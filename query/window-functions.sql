-- Aggregates
USE MyDatabase;

-- Find the 
SELECT
	customer_id,
	COUNT(*) TotalOrders,
	SUM(sales) TotalSales,
	AVG(sales) AvgSales,
	MAX(sales) HighestSales,
	MIN(sales) LowestSales
FROM Orders
GROUP BY customer_id;

-- Window Functions:
-- Windows VS GROUP BY
-- Window Function perform aggreagates on a specific subset of data , without loosing level of details of rows
-- Find total sales across all orders;
USE SalesDB;

SELECT
	SUM(Sales) TotalSales
FROM Sales.Orders

-- Find Total Sales for each product
SELECT
	ProductID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID

-- -- Find Total Sales for each product, additionaly details such as OrderID & Order date
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders

-- SYNTAX of window functions
-- Window Function [Partition  Clause | Order Clause | Frame Clause (ROWS, UNBOUNDED, PRECEDING)]
-- The OVER clause signifies the windows function

-- 1. Partion Clause - PARTITION BY
-- Without PARTITION BY
-- Find total sales across all orders providing any additional details
SELECT
	OrderID,
	OrderDate,
	SUM(Sales) OVER() TotalSales
FROM Sales.Orders

-- PARTITION BY [single column]
-- Find total sales for each product providing any additional details
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders

-- PARTITION BY [multiple column]
-- Find total sales for each combination of product and order status providing any additional details
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) TotalSalesByProduct_Status
FROM Sales.Orders


-- ORDER CLAUSE
-- A MUST for Ranking and Value (Analytics) Functions
-- Rank each order based on their sales from the highest to the lowest.
SELECT
	OrderID,
	OrderDate,
	RANK() OVER(ORDER BY Sales DESC) RankSales
FROM Sales.Orders


-- FRAME CLAUSE
-- Define a subset of rows within each window that is relevant to the calculation
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (
		PARTITION BY OrderStatus ORDER BY OrderDate
		ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
	) TotalSales
FROM Sales.Orders
