-- Filtering Data
USE MyDatabase;


-- COMPARISON OPERATOR
-- Retrieve all customers from Germany
-- = Equal
SELECT *
FROM customers
WHERE country = 'Germany';

-- Not From Germany
-- Same as <>
SELECT *
FROM customers
WHERE country != 'Germany';


-- Customers with a score greater than 500
SELECT *
FROM customers
WHERE score > 500;


-- Greater than or equal to
SELECT *
FROM customers
WHERE score >= 500;


-- Less than
SELECT *
FROM customers
WHERE score < 500;

-- Less than or equal to
SELECT *
FROM customers
WHERE score <= 500;


-- LOGICAL OPERATORS
-- AND; All conditions must be true.
SELECT *
FROM customers
WHERE country = 'USA' AND score > 500;

-- OR; Atleast one condition must be true.
SELECT *
FROM customers
WHERE country = 'USA' OR score > 500;

-- NOT; Excludes the matching values
-- One condition; Reverses of the = 
SELECT *
FROM customers
WHERE NOT score < 500;


-- RANGE OPERATOR: BETWEEN
-- Check if value is between a given range
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500;

-- [Better] Same as 
SELECT *
FROM customers
WHERE score >= 100 AND score <= 500;

-- MEMBERSHIP: IN & NOT IN
-- Works with lists.
SELECT *
FROM customers
WHERE country IN ('Germany', 'USA');

--Same as
SELECT *
FROM customers
WHERE country = 'Germany' OR country = 'USA';


-- SEARCH OPERATOR: LIKE
-- Search for pattern in text
-- All customers whose name start with an M
SELECT *
FROM customers
WHERE first_name LIKE 'M%';

-- All customers whose name end with an N
SELECT *
FROM customers
WHERE first_name LIKE '%n';


-- First name contains and R
SELECT *
FROM customers
WHERE first_name LIKE '%r%';

-- First name contains and R in the third position
SELECT *
FROM customers
WHERE first_name LIKE '__r%';