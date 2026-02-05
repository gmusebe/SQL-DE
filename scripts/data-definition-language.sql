-- DATA DEFINITION LANGUAGE (DDL)
USE MyDataBase;

-- Return all data from the customers table
SELECT *
FROM customers;

-- CREATE TABLE
CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

/* Return all the data from the persons table */
SELECT *
FROM persons;


-- ADD & DROP COLUMNS
-- Add email details to the persons table
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

-- Remove column phone from persons table
ALTER TABLE persons
DROP COLUMN phone;

-- DROP TABLE
DROP TABLE persons;