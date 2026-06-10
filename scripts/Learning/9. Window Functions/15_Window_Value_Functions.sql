/* ==============================================================================
   SQL Window Value Functions
-------------------------------------------------------------------------------
   These functions let you reference and compare values from other rows 
   in a result set without complex joins or subqueries, enabling advanced 
   analysis on ordered data.

   The functions give you access to values in another rows.

   Table of Contents:
     1. LEAD
     2. LAG
     3. FIRST_VALUE
     4. LAST_VALUE

=================================================================================
*/

USE SalesDB;

/* ============================================================
   SQL WINDOW VALUE | LEAD, LAG
   ============================================================ */

/* TASK 1: Time Series Analysis
   Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
   Between the Current and Previous Months
*/

SELECT
	*,
	CurrentMonthSales - PreviousMonthSales AS MoMChange,
	CONCAT(COALESCE(ROUND(CAST((CurrentMonthSales - NULLIF(PreviousMonthSales,0)) AS FLOAT) * 100/PreviousMonthSales, 2),0), '%')
FROM
(SELECT
	MONTH(OrderDate) AS OrderMonth,
	SUM(Sales) AS CurrentMonthSales,
	COALESCE(LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)),0) AS PreviousMonthSales
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
) t;

/* TASK 2:
   Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders
*/
SELECT
	CustomerID,
	AVG(DaysUntilNextOrder) AS AvgDays,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) AS Ranking
FROM
(SELECT
	OrderID,
	CustomerID,
	OrderDate AS CurrentOrder,
	COALESCE(LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) AS NextOrder,
	COALESCE(DATEDIFF(DAY, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)),0) AS DaysUntilNextOrder
FROM Sales.Orders
)t
GROUP BY CustomerID;

/* ============================================================
   SQL WINDOW VALUE | FIRST & LAST VALUE
   ============================================================ */
/* TASK 3:
   Find the Lowest and Highest Sales for Each Product,
   and determine the difference between the current Sales and the lowest Sales for each Product.
*/
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS LowestSales,
	LAST_VALUE(Sales) OVER (
        PARTITION BY ProductID 
        ORDER BY Sales 
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS HighestSales,
    Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM Sales.Orders;