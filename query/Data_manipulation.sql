-- MODIFY AND MANIPULATE DATA
USE MyDatabase;

-- MANUAL ENTRY
INSERT INTO customers (id, first_name, country, score)
VALUES
	(6, 'Ivan', 'USA', NULL),
	(7, 'Stephanie', 'UK', NULL)

SELECT *
FROM customers;

-- INSERT TABLE USING SELECT
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT
	id,
	first_name,
	NULL,
	'Unknown'
FROM customers;

SELECT *
FROM persons;

-- UPDATE
-- Change the scores of customer with ID 6 to 0

UPDATE customers
SET  score = 0
WHERE id = 6;

UPDATE customers
SET
	score = 0,
	country = 'UK'
WHERE
	id = 7;

UPDATE customers
SET
	score = 0
WHERE
	score IS NULL;

-- DELETE
DELETE FROM customers
WHERE
	id >5;


-- Delete all data from persons table
DELETE FROM persons;

-- Same as
TRUNCATE TABLE persons;