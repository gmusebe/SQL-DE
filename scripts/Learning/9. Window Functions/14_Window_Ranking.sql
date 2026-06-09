/* ==============================================================================
   SQL Window Ranking Functions
-------------------------------------------------------------------------------
   These functions allow you to rank and order rows within a result set 
   without the need for complex joins or subqueries. They enable you to assign 
   unique or non-unique rankings, group rows into buckets, and analyze data 
   distributions on ordered data.

   Table of Contents:
     1. ROW_NUMBER
     2. RANK
     3. DENSE_RANK
     4. NTILE
     5. CUME_DIST
	
=================================================================================
*/

USE SalesDB;

/* ============================================================
   SQL WINDOW RANKING | ROW_NUMBER, RANK, DENSE_RANK

   -- Syntax:
	RANK() OVER(PARTITION BY Col_1 ORDER BY Col_2)
	ORDER BY [Mandatory]
   ============================================================ */
   /* TASK 1:
   Rank Orders Based on Sales from Highest to Lowest
*/
SELECT
    OrderID,
    ProductID,
    Sales,
	-- Assign unique number to each row:
	-- Unique Ranks: Does not account for  duplicates/repetition
	ROW_NUMBER() OVER(ORDER BY Sales DESC),
	-- Handles Ties; Leaves Gaps
	RANK() OVER(ORDER BY Sales DESC),
	-- Handles Ties & Does not leave gaps
	DENSE_RANK() OVER(ORDER BY Sales DESC)
FROM Sales.Orders;


/* TASK 2:
   Use Case | Top-N Analysis: Find the Highest Sale for Each Product
*/
SELECT *
FROM(
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) [RankByProduct]
FROM Sales.Orders
)t 
WHERE RankByProduct = 1;

/* TASK 3:
   Use Case | Bottom-N Analysis: Find the Lowest 2 Customers Based on Their Total Sales
*/
SELECT *
FROM(
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
)t WHERE RankCustomers <= 2;

/* TASK 4:
   Use Case | Assign Unique IDs to the Rows of the 'Order Archive'
*/
SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
	*
FROM Sales.OrdersArchive;

/* TASK 5:
   Use Case | Identify Duplicates:
   Identify Duplicate Rows in 'Order Archive' and return a clean result without any duplicates
*/
SELECT *
FROM(
SELECT 
	ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
	*
FROM Sales.OrdersArchive
)t
WHERE rn = 1;

/* ============================================================
   SQL WINDOW RANKING | NTILE
   Divide Rows into Specified Number of Approximately Equal Groups
   Bucket Size = No.OfRows/No.OfBuckets
   ============================================================ */
/* TASK 6:
   Divide Orders into Groups Based on Sales
*/

SELECT 
    OrderID,
    Sales,
    NTILE(1) OVER (ORDER BY Sales) AS OneBucket,
    NTILE(2) OVER (ORDER BY Sales) AS TwoBuckets,
    NTILE(3) OVER (ORDER BY Sales) AS ThreeBuckets,
    NTILE(4) OVER (ORDER BY Sales) AS FourBuckets,
    NTILE(2) OVER (PARTITION BY ProductID ORDER BY Sales) AS TwoBucketByProducts
FROM Sales.Orders;

/* TASK 7: Data Segmentation (Data Analyst)
   Segment all Orders into 3 Categories: High, Medium, and Low Sales.
*/
SELECT
    OrderID,
    Sales,
    Buckets,
    CASE 
        WHEN Buckets = 1 THEN 'High'
        WHEN Buckets = 2 THEN 'Medium'
        WHEN Buckets = 3 THEN 'Low'
    END AS SalesSegmentations
FROM (
    SELECT
        OrderID,
        Sales,
        NTILE(3) OVER (ORDER BY Sales DESC) AS Buckets
    FROM Sales.Orders
) AS SalesBuckets;

/* TASK 8: ETL Processing & Load Balancing
   Divide Orders into Groups for Processing
*/
SELECT 
    NTILE(5) OVER (ORDER BY OrderID) AS Buckets,
    *
FROM Sales.Orders;

/* ============================================================
   SQL WINDOW RANKING | CUME_DIST
   Cumulative Distribution: Distribution of Data Point within a Window
   PositionNr/No.OfRows
   ============================================================ */
/* TASK 9:
   Find Products that Fall Within the Highest 40% of the Prices
*/
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