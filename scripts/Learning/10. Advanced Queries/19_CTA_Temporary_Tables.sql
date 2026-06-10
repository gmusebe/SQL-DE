/* ==============================================================================
   SQL Temporary Tables
-------------------------------------------------------------------------------
   This script provides a generic example of data migration using a temporary
   table. 

   -- TEMPORARY TABLES
    
    SELECT...
    INTO #New-Table
    FROM...
    WHERE...
=================================================================================
*/
USE SalesDB;

/* ==============================================================================
   Step 1: Create Temporary Table (#Orders)
============================================================================== */
SELECT
    *
INTO #Orders
FROM Sales.Orders;

SELECT *
FROM #Orders;

/* ==============================================================================
   Step 2: Clean Data in Temporary Table
============================================================================== */
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';

SELECT *
FROM #Orders;


/* ==============================================================================
   Step 3: Load Cleaned Data into Permanent Table (Sales.OrdersTest)
============================================================================== */
SELECT
    *
INTO Sales.OrdersTest
FROM #Orders;