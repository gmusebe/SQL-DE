-- Functions are used for:
-- 1. Clean
-- 2. Manipulate
-- 3. Analyze
-- 4. Transform


-- A function is an in-bulit SQL code block that:
-- Accepts and input value
-- Processes it
-- Returns an output value

-- Type of Functions
-- Single-Row functions
-- Multi-Row functions

-- CONCAT
SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ', country) AS name_country
FROM customers;

-- UPPER
SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ', country) AS name_country,
	LOWER(first_name) AS low_name
    UPPER(first_name) AAS upp_name
FROM customers;

-- LOWER
SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ', country) AS name_country,
	LOWER(first_name) AS low_name
FROM customers;

-- TRIM
-- Find names with leading or trailing spaces; Detect white spaces
SELECT 
	first_name
FROM customers
WHERE first_name != TRIM(first_name)


-- REPLACE
SELECT
'123-456-7890' AS phone,
REPLACE('123-456-7890', '-', '') AS clean_phone;

SELECT
'report.txt' AS type,
REPLACE('report.txt', '.txt', '.csv') AS new_type;


-- LENGTH
SELECT 
	first_name,
    LEN(first_name) AS length
FROM customers;


-- LEFT
SELECT 
	first_name,
    LEFT(TRIM(first_name), 2) AS first_two
FROM customers;

-- RIGHT
SELECT 
	first_name,
    RIGHT(TRIM(first_name), 2) AS last_two
FROM customers;

-- SUBSTRING
-- SUBSTRING(Value, Start, Length)
SELECT 
	first_name,
    SUBSTRING(first_name, 2, LEN(first_name))
FROM customers;
