-- Change/Select the appropriate database
USE MyDatabase;

-- Select eveything from customer table:
SELECT * --Retrieves all columns from the table
FROM customers; -- Tells SQL where to find yout data

-- Select eveything from oders table:
SELECT *
FROM orders;

-- Select few columns
SELECT
    first_name,
    country,
    score
FROM customers;

-- Retrieve customers with a score not equal to 0
-- Filter using where
SELECT *
FROM customers
WHERE score != 0;

-- Retrieve customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';

-- Retrieve customers names from Germany
SELECT
    first_name
FROM customers
WHERE country = 'Germany';

-- Retrieve all customers and sort the results by highest score first
SELECT *
FROM customers
ORDER BY score DESC;

-- Sort by lowest score
SELECT *
FROM customers
ORDER BY score ASC;

-- NESTED ORDER
-- Retrieve all customers and sort the results by the country and then by highest score
SELECT *
FROM customers
ORDER BY
    country ASC,
    score DESC;

-- GROUP BY - Aggregates column by another column
-- Total score by country
-- Find the total score for each country
SELECT 
    country,
    SUM(score) AS total_score
FROM
    customers
GROUP BY
    country;

-- Find the total score and total number of customers for each country
SELECT
    country,
    SUM(score) AS total_score,
    COUNT(id) AS no_of_customers
FROM
    customers
GROUP BY
    country

-- HAVING
-- Filter data after the aggregation***

SELECT
    country,
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

-- DISTINCT
-- Remove duplicates
-- Return Unique List of all countries;
SELECT DISTINCT
    country
FROM
    customers;


-- TOP
-- Restrict the number of rows in your result
SELECT TOP 3 *
FROM customers;

-- Top 3 customers with the highest scrore
SELECT TOP 3 *
FROM customers
ORDER BY score DESC;

