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

--#CATEGORY 2: DISTRIBUTION [PERCENTAGE BASED RANKING]
-- PERCENT_RANK()
-- REALTIVE POSITION OF EACH ROW
-- PositionNr - 1/No.OfRows

-- CUME_DIST()
-- CUMULATIVE DISTRIBUTION: Distribution of Data Point within a Window
-- PositionNr/No.OfRows

-- Find the Products that fall within the highest 40% of prices
SELECT
	*,
	CONCAT(DistRank*100, '%') [DistRank%]
FROM (
	SELECT 
		Product,
		Price,
		CUME_DIST()  OVER(ORDER BY Price DESC) DistRank
	FROM Sales.Products
	)t
WHERE DistRank <=0.4;

-- NTILE(n)
-- Divide Rows into Specified Number of Approximately Equal Groups
-- Bucket Size = No.OfRows/No.OfBuckets
SELECT
	OrderID,
	Sales,
	NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
	NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket
FROM 
	Sales.Orders

-- d-ANALYST
-- DATA SEGMENTATION
--Segment All Orders in 3 Categories
SELECT
	*,
	CASE
		WHEN Buckets = 1 THEN 'High'
		WHEN Buckets = 2 THEN 'Medium'
		ELSE 'Low'
	END Categories
FROM(
	SELECT 
		OrderID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) Buckets
	FROM Sales.Orders
)t

-- d-ENGINEER
-- ETL PROCESSING
-- LOAD BALANCING
SELECT
	NTILE(2) OVER(ORDER BY OrderID) Buckets,
	*
FROM Sales.Orders;