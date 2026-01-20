USE SalesDB;

-- SYNTAX
-- RANK() OVER(PARTITION BY Col_1 ORDER BY Col_2)
-- ORDER BY [MANDATORY]

--#CATEGORY 1: TOP/BOTTOM N
-- A. ROW_NUMBER(): Assign unique number to each row:
-- DOES NOT HANDLE TIES
-- Rank Orders from Highest to Lowest based on their Sales
SELECT
	*,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) Ranking
FROM Sales.Orders;

-- RANK()
-- Handles Ties; Leaves Gaps
SELECT 
	*,
	RANK() OVER(ORDER BY Sales DESC) Ranking,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) RankingBySales_Row
FROM Sales.Orders

-- DENSE_RANK()
-- Handles Ties & Does not leave gaps
SELECT
	*,
	DENSE_RANK() OVER(ORDER BY Sales DESC) [Dense_Rank],
	RANK() OVER(ORDER BY Sales DESC) Ranking
FROM Sales.Orders;

-- USE CASES
-- Find Top Highest Sales for Each Product
SELECT *
FROM(
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) [RankByProduct]
FROM Sales.Orders
)t 
WHERE RankByProduct = 1;

-- Find the lowest 2 customers based on their total sales
SELECT *
FROM(
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
)t WHERE RankCustomers <= 2;

-- Assign Unique IDs
SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
	*
FROM Sales.OrdersArchive;

-- Identify Duplicates
-- Identify and Return Without Duplicates
SELECT *
FROM(
SELECT 
	ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
	*
FROM Sales.OrdersArchive
)t
WHERE rn = 1;

--#CATEGORY 2: DISTRIBUTION
-- PERCENT_RANK()
-- CUME_DIST()


-- NTILE(n)
