-- COUNT
-- Allows all data types
-- Count the Number of Rows in our Table:

-- #1. OVERALL ANALYSIS
-- Find The Total No. of Order
SELECT
	COUNT(*) TotalOrders
FROM Sales.Orders;

-- Provide details of Order ID and Date:
SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() TotalOrders
FROM Sales.Orders;


-- #2. CATEGORY ANALYSIS / #3. QUALITY CHECK NULLS
-- Find the Total Number of Orders for each Customer
SELECT
	CustomerID,
	COUNT(*) OVER(PARTITION BY CustomerID) [TotalOrders Per Customer]
FROM Sales.Orders;

-- Find the Total No. of Customers, Provide All Customer Details
SELECT
	*,
	COUNT(*) OVER() TotalCustomers
FROM Sales.Customers;

-- #3. IDENTIFY DUPLICATES
-- Find Total No. of Scores for customers
SELECT
	CustomerID,
	COUNT(Score) OVER() ScoreCount
FROM
	Sales.Customers;

-- COUNT to Identify Duplicates
SELECT *
FROM(
	SELECT
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
) t
WHERE CheckPK > 1


-- SUM
-- Total Sales for all orders & For Each Product
-- #1. OVERALL ANALYSIS
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders;

SELECT *
FROM Sales.Orders

-- #2. COMPARISON ANALYSIS
-- Find % Contibution of Each Product's Sales to Total Sales
-- PART TO WHOLE ANALYSIS
SELECT
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSales,
	ROUND(CAST (Sales AS Float)/SUM(Sales) OVER() * 100, 2) [%ofTotal]

FROM Sales.Orders;


-- AVERAGE
SELECT
	OrderID,
	ProductID,
	AVG(Sales) OVER() AvgSales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct
FROM Sales.Orders;

-- Average Scores of Customers
SELECT
	AVG(COALESCE( Score, 0)) OVER() AvgScore
FROM Sales.Customers

SELECT *
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER() AvgSales
	FROM Sales.Orders
)t
WHERE Sales > AvgSales



-- MIN & MAX
SELECT *
FROM(
	SELECT
		*,
		MAX(Salary) OVER () HighestSalary
	FROM Sales.Employees
)t
WHERE Salary = HighestSalary;


-- Find the deviation of each sales from the minimum and maximum sales amounts
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales,
	Sales - MIN(Sales) OVER() DeviationFromMin,
	MAX(Sales) OVER() - Sales DeviationFromMax
FROM
	Sales.Orders

-- ANALYSIS OVER TIME
-- #RUNNING & ROLLING TOTAL
-- Calculate the moving averages of sales for each product overtime
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg -- MOVING AVERAGE
FROM
	Sales.Orders;


-- Calculate the moving Average of sales for each product over time, including only the next order
-- Limited to two orders
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg -- ROLLING AVERAGE
FROM
	Sales.Orders;