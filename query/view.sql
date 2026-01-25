-- SQL VIEWS
-- CREATE | UPDATE | DROP
--OPTION 1: Find running Total of Sales for each month

WITH CTE_Monthly_Summary AS (
SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate)
)

SELECT 
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary


-- Test Views
SELECT *
FROM V_Monthly_Summary;

--OPTION 2 VIEWS: Find running Total of Sales for each month
SELECT 
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM V_Monthly_Summary

-- Provide VIEW that combines details from orders, products, customers,  and employees
SELECT *
FROM Sales.V_Order_Details