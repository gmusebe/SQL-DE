-- ACCESS VALUE FROM OTHER ROW

-- LAG
-- LEAD
-- SYNTAX LEAD(Sales[R], 2[O, De=1], 10[O, De=NULL]) OVER(PARTITION BY ProductID ORDER BY OrderDate)

-- TIME SERIES ANALYSIS
-- Analyse the Month-over-month performance by finding the % Change
-- in sales between the current and previous month

SELECT 
	*,
	MonthlySales - SalesPreviousMonth AS MoM_Change,
	ROUND(CAST((MonthlySales - SalesPreviousMonth ) AS FLOAT)/SalesPreviousMonth * 100, 1) AS [MoM%]
FROM(
SELECT
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) MonthlySales,
	LAG(SUM(Sales), 1) OVER(ORDER BY MONTH(OrderDate)) SalesPreviousMonth
FROM
	Sales.Orders
GROUP BY MONTH(OrderDate)
)t

-- Customer Retention Analysis
-- In order to analyse customer loyalty,
-- rank customers based on the average days between their orders
SELECT 
	CustomerID,
	AVG(DaysUntilNextOrder) AvgDays,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder), 99999)) RankAvg
FROM(
SELECT
	OrderID,
	CustomerID,
	OrderDate CurrentOrder,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
FROM
	Sales.Orders
)t
GROUP BY
	CustomerID;

--FIRST_VALUE
-- LAST_VALUE()
-- Find the Lowest and Highest Sales for each Product
SELECT 
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSale,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales 
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSale,
	--ALTERNATIVE
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSale2,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSale2,
	MAX(Sales) OVER(PARTITION BY ProductID) HighestSale3
FROM Sales.Orders;