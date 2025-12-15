-- 1. COUNT
-- How many orders do we have of each product:

SELECT
    ProductID,
    COUNT(ProductID) OVER(PARTITION BY ProductID)
FROM sales.orders

-- Allows any datatype:
-- Find Total number of ord Counters
SELECT
    COUNT(ProductID) OVER(PARTITION BY ProductID)
FROM sales.orders