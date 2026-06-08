/* ==============================================================================
   SQL Window Functions
-------------------------------------------------------------------------------
   SQL window functions enable advanced calculations across sets of rows 
   related to the current row without resorting to complex subqueries or joins.
   This script demonstrates the fundamentals and key clauses of window functions,
   including the OVER, PARTITION, ORDER, and FRAME clauses, as well as common rules 
   and a GROUP BY use case.

   Window Function perform aggreagates on a specific subset of data , without loosing level of details of rows

   Table of Contents:
     1. SQL Window Basics
     2. SQL Window OVER Clause
     3. SQL Window PARTITION Clause
     4. SQL Window ORDER Clause
     5. SQL Window FRAME Clause
     6. SQL Window Rules
     7. SQL Window with GROUP BY
=================================================================================
*/
USE SalesDB;

/* ==============================================================================
   SQL WINDOW FUNCTIONS | BASICS
===============================================================================*/
/* TASK 1: 
   Calculate the Total Sales Across All Orders 
*/
SELECT
	SUM(Sales) TotalSales
FROM Sales.Orders;

/* TASK 2: 
   Calculate the Total Sales for Each Product 
*/
SELECT
	ProductID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID;

/* ==============================================================================
   SQL WINDOW FUNCTIONS | OVER CLAUSE
===============================================================================*/
/* TASK 3: 
   Find the total sales across all orders,
   additionally providing details such as OrderID and OrderDate 
*/
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() TotalSalesByProducts
FROM Sales.Orders;

/* ==============================================================================
SYNTAX of window functions
Window Function OVER(...)
	a. Partition  Clause
	b. Order By  Clause
	c. Frame Clause (ROWS, UNBOUNDED, PRECEDING)
===============================================================================*/


/* ==============================================================================
   SQL WINDOW FUNCTIONS | PARTITION CLAUSE
===============================================================================*/
-- 1. PARTITION BY

/* TASK 4: 
   Find the total sales across all orders and for each product,
   additionally providing details such as OrderID and OrderDate 
*/
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders;

/* TASK 5: 
   Find the total sales across all orders, for each product,
   and for each combination of product and order status,
   additionally providing details such as OrderID and OrderDate 
*/
SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) TotalSalesByProduct
FROM Sales.Orders;

/* ==============================================================================
   SQL WINDOW FUNCTIONS | ORDER CLAUSE
===============================================================================*/
/* TASK 6: 
   Rank each order by Sales from highest to lowest */

SELECT 
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) Rank_Sales
FROM Sales.Orders;

/* ==============================================================================
   SQL WINDOW FUNCTIONS | FRAME CLAUSE
===============================================================================*/
/* TASK 7: 
   Calculate Total Sales by Order Status for current and next two orders 
*/
SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
	) SumOverStatus
FROM Sales.Orders;

/* TASK 8: 
   Calculate Total Sales by Order Status for current and previous two orders 
*/
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	) TotalSales
FROM Sales.Orders

/* TASK 9: (Same as Task 8)
   Calculate Total Sales by Order Status from previous two orders only 
*/
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS 2 PRECEDING
	) TotalSales
FROM Sales.Orders

/* TASK 10: 
   Calculate cumulative Total Sales by Order Status up to the current order 
*/
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS UNBOUNDED PRECEDING
	) TotalSales
FROM Sales.Orders

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) TotalSales
FROM Sales.Orders

/* ==============================================================================
   SQL WINDOW FUNCTIONS | RULES

	1. Window Functions can be used only in SELECT  & ORDER BY clauses
	2. Nesting Window Functions is not allowed
	3. SQL executes Window Functions  after WHERE clause
===============================================================================*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus) AS Total_Sales
FROM Sales.Orders
WHERE SUM(Sales) OVER (PARTITION BY OrderStatus) > 100;  -- Invalid: window function in WHERE clause

/* RULE 2: 
   Window functions cannot be nested 
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(SUM(Sales) OVER (PARTITION BY OrderStatus)) OVER (PARTITION BY OrderStatus) AS Total_Sales  -- Invalid nesting
FROM Sales.Orders;

/* ==============================================================================
   SQL WINDOW FUNCTIONS | GROUP BY
   Window Functions can be used together with the GROUP BY clause only if you use same columns
===============================================================================*/
/* TASK 12: 
   Rank customers by their total sales 
*/
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER (
		ORDER BY SUM(Sales) DESC
		) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID 