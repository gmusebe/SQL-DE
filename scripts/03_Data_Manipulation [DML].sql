/* ==============================================================================
   SQL Data Manipulation Language (DML)
-------------------------------------------------------------------------------
   This guide covers the essential DML commands used for inserting, updating, 
   and deleting data in database tables. (Modify and manipulate data)

   Table of Contents:
     1. INSERT - Adding Data to Tables
     2. UPDATE - Modifying Existing Data
     3. DELETE - Removing Data from Tables
=================================================================================
*/

-- SELECT Database
USE MyDatabase;


/* ============================================================================== 
   INSERT
=============================================================================== */
/* #1 Method: Manual INSERT using VALUES */
-- Insert new records into the customers table

INSERT INTO customers (id, first_name, country, score)
VALUES
	(9, 'Ivan', 'USA', NULL),
	(10, 'Stephanie', 'UK', NULL)

-- Incorrect column order 
INSERT INTO customers (id, country, score, first_name)
VALUES 
    (11, 'Max', 'USA', NULL)
    
-- Incorrect data type in values
INSERT INTO customers (id, first_name, country, score)
VALUES 
	('Max', 9, 'Max', NULL)

-- Insert a new record with full column values
INSERT INTO customers (id, first_name, country, score)
VALUES (8, 'Max', 'USA', 368)

-- Insert a new record without specifying column names (not recommended)
INSERT INTO customers 
VALUES 
    (9, 'Andreas', 'Germany', NULL)

-- Insert a record with only id and first_name (other columns will be NULL or default values)
INSERT INTO customers (id, first_name)
VALUES 
    (20, 'Sahra')

SELECT *
FROM customers;

/* #2 Method: INSERT DATA USING SELECT - Moving Data From One Table to Another */
-- Copy data from the 'customers' table into 'persons'

-- Confirm the table exists before creating it, if it exists drop it first
DROP TABLE IF EXISTS persons;

CREATE TABLE persons (
	id INT PRIMARY KEY,
	person_name VARCHAR(255),
	birth_date DATE,
	phone VARCHAR(20)
);	

INSERT INTO persons (id, person_name, birth_date, phone)
SELECT
	id,
	first_name,
	NULL,
	'Unknown'
FROM customers;

SELECT *
FROM persons;

/* ============================================================================== 
   UPDATE
=============================================================================== */

-- Change the score of customer with ID 6 to 0
UPDATE customers
SET  score = 0
WHERE id = 6;

-- Change the score of customer with ID 10 to 0 and update the country to 'UK'
UPDATE customers
SET score = 0,
	country = 'UK'
WHERE id = 10;

-- Update all customers with a NULL score by setting their score to 0
UPDATE customers
SET
	score = 0
WHERE
	score IS NULL;

-- Verify the update
SELECT *
FROM customers
WHERE score IS NULL;

/* ============================================================================== 
   DELETE
=============================================================================== */

-- Delete all customers with an ID greater than 5
DELETE FROM customers
WHERE
	id >5;

-- Delete all data from the persons table
DELETE FROM persons; 

-- Faster method to delete all rows, especially useful for large tables
TRUNCATE TABLE persons;