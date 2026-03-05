/* ============================================================================== 
   SQL String Functions
-------------------------------------------------------------------------------
   This document provides an overview of SQL string functions, which allow 
   manipulation, transformation, and extraction of text data efficiently.

   Table of Contents:
     1. Manipulations
        - CONCAT
        - LOWER
        - UPPER
	- TRIM
	- REPLACE
     2. Calculation
        - LEN
     3. Substring Extraction
        - LEFT
        - RIGHT
        - SUBSTRING
=================================================================================
*/

/* ============================================================================== 
Functions are used to:
1. Clean
2. Manipulate
3. Analyze
4. Transform

A function is an in-bulit SQL code block that:
a. Accepts and input value
b. Processes it
c. Returns an output value

Type of Functions
- Single-Row functions
- Multi-Row functions
=============================================================================== */

/* ============================================================================== 
   CONCAT() - String Concatenation
=============================================================================== */
-- Concatenate first name and country into one column
SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ', country) AS name_country
FROM customers;

/* ============================================================================== 
   LOWER() & UPPER() - Case Transformation
=============================================================================== */
-- UPPER
SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ', country) AS name_country,
	LOWER(first_name) AS low_name,
    UPPER(first_name) AS upp_name
FROM customers;

-- LOWER
SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ', country) AS name_country,
	LOWER(first_name) AS low_name
FROM customers;

/* ============================================================================== 
   TRIM() - Remove White Spaces
=============================================================================== */

-- Find customers whose first name contains leading or trailing spaces
SELECT 
    first_name,
	LEN(first_name) len_name,
	LEN(TRIM(first_name)) len_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) flag
FROM customers
WHERE LEN(first_name)  != LEN(TRIM(first_name))
-- WHERE first_name != TRIM(first_name)

-- Find names with leading or trailing spaces; Detect white spaces
SELECT 
	first_name
FROM customers
WHERE first_name != TRIM(first_name)

/* ============================================================================== 
   REPLACE() - Replace or Remove old value with new one
=============================================================================== */
-- Remove dashes (-) from a phone number
-- REPLACE
SELECT
'123-456-7890' AS phone,
REPLACE('123-456-7890', '-', '') AS clean_phone;

SELECT
'report.txt' AS type,
REPLACE('report.txt', '.txt', '.csv') AS new_type;

/* ============================================================================== 
   LEN() - String Length & Trimming
=============================================================================== */

-- Calculate the length of each customer's first name
SELECT 
	first_name,
    LEN(first_name) AS length
FROM customers;

/* ============================================================================== 
   LEFT() & RIGHT() - Substring Extraction
=============================================================================== */

-- Retrieve the first two characters of each first name
SELECT 
	first_name,
    LEFT(TRIM(first_name), 2) AS first_two
FROM customers;

-- Retrieve the last two characters of each first name
SELECT 
	first_name,
    RIGHT(TRIM(first_name), 2) AS last_two
FROM customers;

/* ============================================================================== 
   SUBSTRING() - Extracting Substrings
=============================================================================== */
-- SUBSTRING(Value, Start, Length)

-- Retrieve a list of customers' first names after removing the first character
SELECT 
	first_name,
    SUBSTRING(TRIM(first_name), 2, LEN(TRIM(first_name)))
FROM customers;

-- ROUND
SELECT 3.512,
ROUND(3.512, 2) AS round_2;

-- ABSOLUTE (ABS)
SELECT -3.512,
ABS(-3.512) AS absolute;

/* ==============================================================================
   NESTING FUNCTIONS
===============================================================================*/

-- Nesting
SELECT
first_name, 
UPPER(LOWER(first_name)) AS nesting
FROM customers

