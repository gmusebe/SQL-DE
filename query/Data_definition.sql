-- DATA DEFINITION LANGUAGE (DDL)
USE MyDataBase;

-- CREATE TABLE
CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

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