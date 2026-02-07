/* ==============================================================================
   SQL Data Definition Language (DDL)
-------------------------------------------------------------------------------
   This guide covers the essential DDL commands used for defining and managing
   database structures, including creating, modifying, and deleting tables.

   Table of Contents:
     1. CREATE - Creating Tables
     2. ALTER - Modifying Table Structure
     3. DROP - Removing Tables
=================================================================================
*/

/* ==============================================================================
   SELECT THE DATABASE TO USE
=============================================================================== */

-- Change/Select the appropriate database
USE MyDatabase;

/* ============================================================================== 
   CREATE
=============================================================================== */

/* Create a new table called persons 
   with columns: id, person_name, birth_date, and phone */
CREATE TABLE persons(
	id INT NOT NULL,
	person_name VARCHAR(25) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY(id)
);

/* Return all the data from the persons table */
SELECT *
FROM persons;

/* ============================================================================== 
   ALTER
=============================================================================== */

-- Add a new column called email to the persons table
ALTER TABLE persons
ADD email VARCHAR(30) NOT NULL;

-- Remove column phone from persons table
ALTER TABLE persons
DROP COLUMN phone;

/* ============================================================================== 
   DROP
=============================================================================== */

-- DROP TABLE
DROP TABLE persons;