/* ==============================================================================
   SQL Stored Procedures
-------------------------------------------------------------------------------
   This script shows how to work with stored procedures in SQL Server,
   starting from basic implementations and advancing to more sophisticated
   techniques.

   Table of Contents:
     1. Basics (Creation and Execution)
     2. Parameters
     3. Multiple Queries
     4. Variables
     5. Control Flow with IF/ELSE
     6. Error Handling with TRY/CATCH
=================================================================================
*/

USE SalesDB;
GO

/* ==============================================================================
   Basic Stored Procedure
============================================================================== */

-- Define the Stored procedure;
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
    SELECT
        COUNT(*) TotalCustomers,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA'
END;
GO

-- Execute the Stored Procedure
EXEC GetCustomerSummary;
GO

/* ==============================================================================
   Parameters in Stored Procedure
============================================================================== */

-- For German Customers  Find the total number of customers and the average score:
-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) AS
BEGIN
    SELECT
        COUNT(*) TotalCustomeXrs,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = @Country
END;

-- Execute the Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';

/* Setting Default value */
GO
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS 
BEGIN
    SELECT
        COUNT(*) TotalCustomeXrs,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = @Country
END

EXEC GetCustomerSummary @Country  = 'USA';
GO

/* ==============================================================================
   Multiple Queries in Stored Procedure
============================================================================== */

-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END
GO

/* ==============================================================================
   Variables in Stored Procedure
============================================================================== */


-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS 
BEGIN
    -- Declare Variables
    DECLARE @TotalCustomers INT, @AvgScore FLOAT;

    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
    PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR) ;

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) TotalOrders,
        SUM(Sales) TotalSales
    FROM Sales.Orders o
    JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    WHERE C.Country = @Country;
END
GO

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary @Country = 'USA'
GO

/* ==============================================================================
   Control Flow IFELSE in Stored Procedure
============================================================================== */

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS 
BEGIN
    -- Declare Variables
    DECLARE @TotalCustomers INT, @AVGScore FLOAT;

    /* --------------------------------------------------------------------------
	   Prepare & Cleanup Data
	-------------------------------------------------------------------------- */

    IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
    BEGIN
        PRINT('Updating NULL Scores to 0');
        UPDATE Sales.Customers
        SET Score = 0
        WHERE Score IS NULL AND  Country = @Country
    END
    ELSE
    BEGIN
        PRINT('No NULL Scores found');
    END;

    /* --------------------------------------------------------------------------
	   Generating Reports
	-------------------------------------------------------------------------- */
    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
    PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales,
        1/0 AS FaultyCalculation  -- Intentional error for demonstration
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END
GO

/* ==============================================================================
   Error Handling TRY CATCH in Stored Procedure
============================================================================== */
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
    
BEGIN
    BEGIN TRY
        -- Declare Variables
        DECLARE @TotalCustomers INT, @AvgScore FLOAT;     

        /* --------------------------------------------------------------------------
           Prepare & Cleanup Data
        -------------------------------------------------------------------------- */

        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('Updating NULL Scores to 0');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT('No NULL Scores found');
        END;

        /* --------------------------------------------------------------------------
           Generating Reports
        -------------------------------------------------------------------------- */
        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
        PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

        SELECT
            COUNT(OrderID) AS TotalOrders,
            SUM(Sales) AS TotalSales,
            1/0 AS FaultyCalculation  -- Intentional error for demonstration
        FROM Sales.Orders AS o
        JOIN Sales.Customers AS c
            ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;
    END TRY
    BEGIN CATCH
        /* --------------------------------------------------------------------------
           Error Handling
        -------------------------------------------------------------------------- */
        PRINT('An error occurred.');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR));
        PRINT('Error State: ' + CAST(ERROR_STATE() AS NVARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
    END CATCH;
END
GO

EXEC GetCustomerSummary;
GO