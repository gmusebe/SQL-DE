USE SalesDB;
GO
 -- Start Typing your SQL query below this line
SELECT *
FROM Sales.Orders; -- GHOST TEXT


-- Write Comment
-- Select Top 3 Customers based on Score
SELECT TOP 3 *
FROM Sales.Customers
ORDER BY Score DESC;

-- Rank Customers based on their Total Order Sales
SELECT 
    *,
    RANK() OVER (ORDER BY TotalOrders DESC) AS SalesRank
FROM Sales.Customers;

-- Inline Shafts (To Trigger press Ctrl + I) 
-- Example:
SELECT 
    c.*,
    RANK() OVER (ORDER BY COUNT(o.OrderID) DESC) AS SalesRank
FROM Sales.Customers c
LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Score, c.TotalOrders
ORDER BY SalesRank;



-- The Redline below to fix the syntax error
SELECT
    COUNT(*) Score,
    CustomerID
FROM Sales.Customers
GROUP BY CustomerID
ORDER BY Score DESC -- Copilot suggested fix: Move 'GROUP BY' before 'ORDER BY'


-- 6 Components of ChatGPT Prompts for SQL Developers
-- 1. Tasks - Mandatory**
-- 2. Context* 
-- 3. Specifications*
-- 4. Role
-- 5. Tone

-- Examples
/*
[PROMPT...] - TO GENERATE A QUERY
In my SQL Server database, we have two tables: 

The first table is `orders` with the following columns: order_id, sales, customer_id, product_id. The second table is `customers` with the following columns: customer_id, first_name, last_name, country. 
Do the following: 
    Write a query to rank customers based on their sales.
    The result should include the customer's customer_id, full_name, country, total_sales, and their rank.
    Include comments but avoid commenting on obvious parts. 
    Write three different versions of the query to achieve this task.
    Evaluate and explain which version is best in terms of readability and performance
*/

-- Version 1: CTE with aggregation + window function
WITH customer_sales AS (
    -- Aggregate once per customer to avoid repeated calculations
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        c.country,
        SUM(o.sales) AS total_sales
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country
)
SELECT
    customer_id,
    full_name,
    country,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM customer_sales;


-- Version 2: Derived table (subquery instead of CTE)
SELECT
    cs.customer_id,
    cs.full_name,
    cs.country,
    cs.total_sales,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_rank
FROM (
    -- Inline aggregation without persisting a CTE
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        c.country,
        SUM(o.sales) AS total_sales
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country
) cs;

-- Version 3: Windowed SUM + DISTINCT
SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.country,
    SUM(o.sales) OVER (PARTITION BY c.customer_id) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(o.sales) OVER (PARTITION BY c.customer_id) DESC
    ) AS sales_rank
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id;


/*
[PROMPT...]  - To Improve READABILITY
The following SQL Server query is long and hard to understand. 
Do the following:
    Improve its readability.
    Remove any redundancy in the query and consolidate it.
    Include comments but avoid commenting on obvious parts.
    Explain each improvement to understand the reasoning behind it.

[ SQL Query GOES HERE ]
*/
