/* ==============================================================================
   SQL Window Aggregate Functions
-------------------------------------------------------------------------------
   These functions allow you to perform aggregate calculations over a set 
   of rows without the need for complex subqueries. They enable you to compute 
   counts, sums, averages, minimums, and maximums while still retaining access 
   to individual row details.

   Table of Contents:
    1. COUNT
    2. SUM
    3. AVG
    4. MAX / MIN
    5. ROLLING SUM & AVERAGE Use Case
===============================================================================
*/
USE SalesDB;

/* ============================================================
   SQL WINDOW AGGREGATION | COUNT
   ============================================================ */

/* TASK 1:
   Find the Total Number of Orders and the Total Number of Orders for Each Customer
*/
SELECT
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) [TotalOrders Per Customer]
FROM Sales.Orders;

/* TASK 2:
   - Find the Total Number of Customers
   - Find the Total Number of Scores for Customers
   - Find the Total Number of Countries
*/
SELECT
	*,
	COUNT(*) OVER() AS TotalCustomers,
	COUNT(Score) OVER() AS TotalScores,
	COUNT(Country) OVER()AS TotalCountries
FROM Sales.Customers;

/* TASK 3: Dupicates Check
   Check whether the table 'OrdersArchive' contains any duplicate rows
*/
SELECT *
FROM(
	-- Subquery
	SELECT
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
) t
WHERE CheckPK > 1

/* ============================================================
   SQL WINDOW AGGREGATION | SUM
   ============================================================ */
/* TASK 4:
   - Find the Total Sales Across All Orders 
   - Find the Total Sales for Each Product
*/
SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER() AS TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS SalesByProduct
FROM Sales.Orders;

/* TASK 5:
   Find the Percentage Contribution of Each Product's Sales to the Total Sales
*/
SELECT
    OrderID,
    ProductID,
    Sales,
	SUM(Sales) OVER() AS TotalSales,
	ROUND(CAST(Sales AS Float)/SUM(Sales) OVER() * 100, 2) AS PercentageOfTotal
FROM Sales.Orders

/* ============================================================
   SQL WINDOW AGGREGATION | AVG
   ============================================================ */
/* TASK 6:
   - Find the Average Sales Across All Orders 
   - Find the Average Sales for Each Product
*/
SELECT
	OrderID,
	ProductID,
	AVG(Sales) OVER() AvgSales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct
FROM Sales.Orders;

/* TASK 7:
   Find the Average Scores of Customers
*/
SELECT
	CustomerID,
	Score,
	AVG(Score) OVER() AS AvgScore,
	AVG(COALESCE(Score, 0)) OVER() AS AvgScoreWithoutNull
FROM Sales.Customers;

/* TASK 8:
   Find all orders where Sales exceed the average Sales across all orders
*/
SELECT *
FROM(
	-- Subquery
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER() AvgSales
	FROM Sales.Orders
)t
WHERE Sales > AvgSales

/* ============================================================
   SQL WINDOW AGGREGATION | MAX / MIN
   ============================================================ */
/* TASK 9:
   Find the Highest and Lowest Sales across all orders
*/
SELECT
	MIN(Sales) AS MinSales, 
	MAX(Sales) AS MaxSales
FROM Sales.Orders;

/* TASK 10:
   Find the Lowest Sales across all orders and by Product
*/
SELECT 
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    MIN(Sales) OVER () AS LowestSales,
    MIN(Sales) OVER (PARTITION BY ProductID) AS LowestSalesByProduct
FROM Sales.Orders

/* TASK 11:
   Show the employees who have the highest salaries
*/
SELECT *
FROM(
	SELECT
		*,
		MAX(Salary) OVER () HighestSalary
	FROM Sales.Employees
)t
WHERE Salary = HighestSalary;

/* TASK 12:
   Find the deviation of each Sale from the minimum and maximum Sales
*/
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

/* ============================================================
   Use Case | ROLLING SUM & AVERAGE
   ============================================================ */
   /* TASK 13:
   Calculate the moving average of Sales for each Product over time
*/

SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg -- MOVING AVERAGE
FROM
	Sales.Orders;

/* TASK 14:
   Calculate the moving average of Sales for each Product over time,
   including only the next order
*/
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(
		PARTITION BY ProductID
		ORDER BY OrderDate
		ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
	) RollingAvg -- ROLLING AVERAGE
FROM
	Sales.Orders;