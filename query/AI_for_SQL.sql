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