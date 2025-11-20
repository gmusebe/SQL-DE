USE SalesDB;


SELECT 
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime
FROM Sales.Orders;


-- PART EXTRACTION:
-- YEAR
SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) AS Year
FROM
	Sales.Orders;

-- MONTH
SELECT 
	--DATEPART
	OrderID,
	CreationTime,
	YEAR(CreationTime) AS Year,
	MONTH(CreationTime) AS Month,
	-- DATENAME
	DATENAME(MONTH,CreationTime) AS Month_Name
FROM
	Sales.Orders;

-- DAY
SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) AS Year,
	MONTH(CreationTime) AS Month,
	DAY(CreationTime) AS Day,
	-- DATENAME
	DATENAME(WEEKDAY,CreationTime) AS Day_Name
FROM
	Sales.Orders;

-- DATEPART:
-- WEEK
SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) AS Year,
	MONTH(CreationTime) AS Month,
	DATEPART(WEEK, CreationTime) AS Week,
	DAY(CreationTime) AS Day
FROM
	Sales.Orders;

--QUARTER
SELECT 
	OrderID,
	CreationTime,
	-- ALL INT (Integer Value)
	YEAR(CreationTime) AS Year,
	DATEPART(QUARTER, CreationTime) AS Quarter,
	MONTH(CreationTime) AS Month,
	DATEPART(WEEK, CreationTime) AS Week,
	DAY(CreationTime) AS Day
FROM
	Sales.Orders;

-- The DATEPART() function can also be used to extract day, month & Year

-- HOUR
SELECT 
	OrderID,
	CreationTime,
	-- ALL INT (Integer Value)
	YEAR(CreationTime) AS Year,
	DATEPART(QUARTER, CreationTime) AS Quarter,
	MONTH(CreationTime) AS Month,
	DATEPART(WEEK, CreationTime) AS Week,
	DAY(CreationTime) AS Day,
	DATEPART(HOUR, CreationTime) AS Hour
FROM
	Sales.Orders;

-- MINUTE
SELECT 
	OrderID,
	CreationTime,
	-- ALL INT (Integer Value)
	YEAR(CreationTime) AS Year,
	DATEPART(QUARTER, CreationTime) AS Quarter,
	MONTH(CreationTime) AS Month,
	DATEPART(WEEK, CreationTime) AS Week,
	DAY(CreationTime) AS Day,
	DATEPART(HOUR, CreationTime) AS Hour,
	DATEPART(MINUTE, CreationTime) AS Minute
FROM
	Sales.Orders;


-- SECONDS
SELECT 
	OrderID,
	CreationTime,
	-- ALL INT (Integer Value)
	YEAR(CreationTime) AS Year,
	DATEPART(QUARTER, CreationTime) AS Quarter,
	MONTH(CreationTime) AS Month,
	DATEPART(WEEK, CreationTime) AS Week,
	DAY(CreationTime) AS Day,
	DATEPART(HOUR, CreationTime) AS Hour,
	DATEPART(MINUTE, CreationTime) AS Minute,
	DATEPART(SECOND, CreationTime) AS Seconds
FROM
	Sales.Orders;


-- DATETRUNC
SELECT
	OrderID,
	CreationTime,
	DATETRUNC(MINUTE, CreationTime) AS Min_trunc
FROM
	sales.Orders;


SELECT
	OrderID,
	CreationTime,
	DATETRUNC(MINUTE, CreationTime) AS Min_trunc,
	DATETRUNC(YEAR, CreationTime) AS Year_trunc
FROM
	sales.Orders;

-- USE CASE DATETRUNC
SELECT
	DATETRUNC(MONTH, CreationTime) AS Month_Trunc,
	COUNT(*) AS Count
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH, CreationTime)

-- EOMONTH: END OF MONTH
SELECT
	CreationTime,
	EOMONTH(CreationTime)
FROM Sales.Orders

-- BEGINNING OF MONTH
SELECT
	CreationTime,
	EOMONTH(CreationTime) AS EndOfMonth,
	CAST(DATETRUNC(MONTH, CreationTime) AS DATE) StartOfMonth
FROM Sales.Orders

-- EXERCISE:
-- Order placed each year
SELECT 
 DATEPART(YEAR ,OrderDate) AS Year,
 COUNT(*) AS Total_Orders
FROM Sales.Orders
GROUP BY DATEPART(YEAR,OrderDate);

-- Order placed each month
SELECT 
 DATEPART(MONTH ,OrderDate) AS Month,
 COUNT(*) AS Total_Orders
FROM Sales.Orders
GROUP BY DATEPART(MONTH,OrderDate);

-- Order placed in the month of February
SELECT 
*
FROM Sales.Orders
WHERE DATENAME(MONTH ,OrderDate) = 'February';

SELECT 
*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2;

-- SUMMARY


-- FORMAT & CASTING:
-- CHANGE DATE FORMAT

-- FORMAT 
-- Format Date or Time Value
SELECT 
	CreationTime,
	FORMAT(CreationTime, 'MM/dd/yyyy') USA_Format,
	FORMAT(CreationTime, 'dd') dd,
	FORMAT(CreationTime, 'ddd') ddd,
	FORMAT(CreationTime, 'dddd') dddd,
	FORMAT(CreationTime, 'MM') MM,
	FORMAT(CreationTime, 'MMM') MMM,
	FORMAT(CreationTime, 'MMMMM') MMMM
FROM Sales.Orders

-- Exercise
-- Custom Formatting
SELECT 
	CreationTime,
	'Day ' + FORMAT(CreationTime, 'ddd MMM') +
	' Q' + DATENAME(QUARTER, CreationTime) + ' ' +
	FORMAT(CreationTime, 'yyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders

-- Use Case
SELECT
	FORMAT(OrderDate, 'MMM yy'),
	COUNT(*)
FROM 
	Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')

-- CONVERT
SELECT
CONVERT(INT, '123') AS [String to Int CONVERT],
CONVERT(DATE, '2025-08-20') AS  [String to Date CONVERT],
CreationTime,
CONVERT(DATE,CreationTime) AS  [Datetime to Date CONVERT]
FROM 
	Sales.Orders

-- We can do Casting and Formating in CONVERT
SELECT
CreationTime,
CONVERT(DATE,CreationTime) AS  [Datetime to Date CONVERT],
CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM 
	Sales.Orders;

-- CAST
-- CAST(value AS data_type)

SELECT
CAST('123' AS INT) [String to Int],
CAST(123 AS VARCHAR) [Int TO String],
CAST('2025-08-20' AS DATETIME2) [String to Datetime],
CAST(CreationTime AS DATE) [Datetime TO Date]
FROM 
	Sales.Orders


-- CALCULATION:
-- DATE CALCULATION
-- DATE Diffrence
-- DIfferences between two Dates
-- ADD Years
SELECT
OrderID,
OrderDate,
DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM 
	Sales.Orders

-- Add Months
SELECT
OrderID,
OrderDate,
DATEADD(year, 2, OrderDate) AS TwoYearsLater,
DATEADD(month, 3, OrderDate) AS ThreeMonthsLater
FROM 
	Sales.Orders

-- Add Days
SELECT
OrderID,
OrderDate,
DATEADD(year, 2, OrderDate) AS TwoYearsLater,
DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
DATEADD(day, -10, OrderDate) AS TenDaysBefore
FROM 
	Sales.Orders

SELECT
BirthDate,
DATEDIFF(year, BirthDate, GETDATE()) Age
FROM 
	Sales.Employees

-- Average shipping duration in days for each month
SELECT
	MONTH(OrderDate) [Order Month],
	AVG(DATEDIFF(day, OrderDate, ShipDate))  [AVG Ship Duration]
FROM 
	Sales.Orders
GROUP BY MONTH(OrderDate)

-- Time Gap Analysis
-- Find the number of days between each order and the previous order
SELECT 
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER  (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER  (ORDER BY OrderDate), OrderDate) NrOfDays
FROM 
	Sales.Orders


SELECT 
    OrderID,
    OrderDate AS CurrentOrderDate,
    ISNULL(LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) AS PreviousOrderDate,
    ISNULL(
        DATEDIFF(
            day, 
            LAG(OrderDate) OVER (ORDER BY OrderDate), 
            OrderDate
        ), 
        0
    ) AS NrOfDays
FROM Sales.Orders;


-- VALIDATION
-- VALIDATE DATE [TRUE OR FALSE
SELECT
	OrderDate,
	ISDATE(OrderDate) DateCheck
FROM Sales.Orders;