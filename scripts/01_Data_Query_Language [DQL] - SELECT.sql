/* ==============================================================================
SQL SELECT QUERY
-------------------------------------------------------------------------------
    This guide covers various SELECT query techniques used for retrieving, 
   filtering, sorting, and aggregating data efficiently.

   Table of Contents:
     1. SELECT ALL COLUMNS
     2. SELECT SPECIFIC COLUMNS
     3. WHERE CLAUSE
     4. ORDER BY
     5. GROUP BY
     6. HAVING
     7. DISTINCT
     8. TOP
     9. Combining Queries
	 10. COOL STUFF - Additional SQL Features
=================================================================================
*/

/* ==============================================================================
   COMMENTS
=============================================================================== */

-- This is a single-line comment.

/* This
   is
   a multiple-line
   comment
*/

/* ==============================================================================
   SELECT THE DATABASE TO USE
=============================================================================== */

-- Change/Select the appropriate database
USE MyDatabase;


/* ==============================================================================
   SELECT ALL COLUMNS
=============================================================================== */

-- Retrieve all Customer data
SELECT * --Retrieves all columns from the table
FROM customers; -- Tells SQL the table where to find your data

-- Retrieve all Orders data:
SELECT *
FROM orders;

/* ==============================================================================
   SELECT FEW COLUMNS; SPECIFIC TO A REQUESTED OUTPUT
=============================================================================== */

-- Retrieve each customer's name, country, and score.
SELECT
    first_name,
    country,
    score
FROM customers;

/* ==============================================================================
   WHERE: FILTERING DATA
   Before Aggregation
=============================================================================== */

-- Retrieve customers with a score not equal to 0
SELECT *
FROM customers
WHERE score != 0;

-- Retrieve customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';

-- Retrieve the name and country of customers from Germany
SELECT
    first_name,
    country
FROM customers
WHERE country = 'Germany';

/* ==============================================================================
   ORDER BY
=============================================================================== */

/* Retrieve all customers and 
   sort the results by the highest score first. */
SELECT *
FROM customers
ORDER BY score DESC;

/* Retrieve all customers and 
   sort the results by the lowest score first. */
SELECT *
FROM customers
ORDER BY score ASC;

/* Retrieve all customers and 
   sort the results by the country. */
SELECT *
FROM customers
ORDER BY country ASC;

/* Retrieve all customers and 
   sort the results by the country and then by the highest score. */
   -- NESTED ORDER
SELECT *
FROM customers
ORDER BY country ASC, score DESC;

/* Retrieve the name, country, and score of customers 
   whose score is not equal to 0
   and sort the results by the highest score first. */
SELECT
    first_name,
    country,
    score
FROM customers
WHERE score !=0
ORDER BY score DESC;

/* ==============================================================================
   GROUP BY
   Aggregates a Numeric/Integer column by another Categorical column
=============================================================================== */

-- Find the total score for each country
SELECT
    country    Country,
    SUM(score) TotalScore
FROM customers
GROUP BY country;

/* This will not work because 'first_name' is neither part of the GROUP BY 
   nor wrapped in an aggregate function. SQL doesn't know how to handle this column. */
SELECT 
    country,    Country,
    first_name  FirstName,
    SUM(score)  TotalScore
FROM customers
GROUP BY country;

-- Find the total score and total number of customers for each country
SELECT
    country,
    SUM(score) TotalScore,
    COUNT(id)  NoOfCustomers
FROM customers
GROUP BY country;

/* ==============================================================================
   HAVING: FILTER DATA
   After Aggregation
=============================================================================== */

/* Find the average score for each country
   and return only those countries with an average score greater than 430 */
SELECT
    country    Country,
    AVG(score) AvgScore
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

/* ==============================================================================
   DISTINCT
=============================================================================== */

-- Return Unique List of all countries
SELECT DISTINCT country
FROM customers;

/* ==============================================================================
   TOP
=============================================================================== */

-- Retrieve only 3 Customers
SELECT TOP 3 *
FROM customers;

-- Retrieve the Top 3 Customers with the Highest Scores
SELECT TOP 3 *
FROM customers
ORDER BY score DESC;

-- Retrieve the Lowest 2 Customers based on the score
SELECT TOP 2 *
FROM customers
ORDER BY score ASC;

-- Get the Two Most Recent Orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC;

/* ==============================================================================
   All Together
=================================================================================
SQL SELECT QUERY Execution Order:
-------------------------------------------------------------------------------

-- Coding & Execution Order:
--        5.      |   7.
-- SELECT DISTINCT TOP 2
--  col1,
--  SUM(col2)
-- 1. FROM Table
-- 2. WHERE Col = 10
-- 3. GROUP BY col1
-- 4. HAVING SUM(col2) > 30
-- 6. ORDER BY col 1 ASC;
=================================================================================
*/

/* Calculate the average score for each country 
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430
   and sort the results by the highest average score first. */
SELECT 
    country    Country,
    AVG(score) AvgScore
FROM customers
WHERE score !=0
GROUP BY country
HAVING AVG(score) > 430
ORDER BY AVG(score) DESC;


/* ============================================================================== 
   COOL STUFF - Additional SQL Features
=============================================================================== */

-- Execute multiple queries at once
SELECT * FROM customers;
SELECT * FROM orders;

/* Selecting Static Data */
-- Select a static or constant value without accessing any table
SELECT 123 AS StaticNumber;

SELECT 'Hello' AS StaticString;

-- Assign a constant value to a column in a query
SELECT
    id,
    first_name,
    'New Customer' AS CustomerType
FROM customers;