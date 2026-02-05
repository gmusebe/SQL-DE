-- Write a query
-- For US Customers Find the total number of customers and the average score
USE SalesDB;

SELECT
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA';

-- Turn Query into a stored procedure:
GO
CREATE PROCEDURE GetCustomerSummary AS
BEGIN

    SELECT
        COUNT(*) TotalCustomers,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA'
END;


-- Execute the Stored Procedure
EXEC GetCustomerSummary;


GO
CREATE PROCEDURE GetCustomerSummaryGermany AS
BEGIN

    SELECT
        COUNT(*) TotalCustomers,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = 'Germany'
END;


-- Execute the Stored Procedure
EXEC GetCustomerSummaryGermany;


-- PARAMETERS
-- For German Customers  Find the total number of customers and the average score:
GO
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) AS
BEGIN
SELECT
    COUNT(*) TotalCustomeXrs,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country
END


-- Execute the Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';

EXEC GetCustomerSummary @Country = 'USA';


-- DROP
GO
DROP PROCEDURE GetCustomerSummaryGermany;

-- Setting Default value
GO
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS 
BEGIN
SELECT
    COUNT(*) TotalCustomeXrs,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country
END

EXEC GetCustomerSummary @Country  = 'USA';


-- Multi Queries in Stored Procedures
--  Find the total Nr. of Orders  and Total Sales
SELECT
    COUNT(OrderID) TotalOrders,
    SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE C.Country = 'USA'


-- Variables
GO
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS 
BEGIN
DECLARE @TotalCustomers INT, @AvgScore FLOAT;

    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
    PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR) ;

    --  Find the total Nr. of Orders  and Total Sales
    SELECT
        COUNT(OrderID) TotalOrders,
        SUM(Sales) TotalSales
    FROM Sales.Orders o
    JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    WHERE C.Country = @Country;

END

EXEC GetCustomerSummary @Country = 'Germany'



-- CONTROL FLOW: IF ELSE
GO
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS 
BEGIN

    BEGIN TRY
        DECLARE @TotalCustomers INT, @AvgScore FLOAT;
            --Prepare & Clean Up Data [nulls in scores]
            
            IF EXISTS(SELECT 1 FROM Sales.Customers WHERE SCORE IS NULL AND Country = @Country)
            BEGIN
                PRINT('Updating NULL scores to 0');
                UPDATE Sales.Customers
                SET Score = 0
                WHERE Score IS NULL AND Country = @Country;
            END

            ELSE
            BEGIN
                PRINT('No NULL scores found');
            END;

            -- Generating Reports 
            SELECT
                @TotalCustomers = COUNT(*),
                @AvgScore = AVG(Score)
            FROM Sales.Customers
            WHERE Country = @Country;

            PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
            PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR) ;

            --  Find the total Nr. of Orders  and Total Sales
            SELECT
                COUNT(OrderID) TotalOrders,
                SUM(Sales) TotalSales,
                1/0
            FROM Sales.Orders o
            JOIN Sales.Customers c
            ON c.CustomerID = o.CustomerID
            WHERE C.Country = @Country;

    END TRY
    -- Error Handling & TRY CATCH
    BEGIN CATCH
        PRINT('An error occured');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS VARCHAR));
        PRINT('Error procedure: ' + ERROR_PROCEDURE());
    END CATCH
END


EXEC GetCustomerSummary @Country = 'Germany';



-- Triggers
CREATE TABLE Sales.EmployeeLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate DATETIME
);

GO
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
    SELECT 
        EmployeeID,
        'New Employee Added = ' + CAST(EmployeeID AS VARCHAR),
        GETDATE()
    FROM INSERTED
END;


SELECT * FROM Sales.EmployeeLogs;

INSERT INTO Sales.Employees
VALUES
    (7, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3)