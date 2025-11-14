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
	DATETRUNC(MONTH, CreationTime) AS StartOfMonth
FROM Sales.Orders



-- FORMAT & CASTING:
-- CHANGE DATE FORMAT

-- CALCULATION:
-- DATE CALCULATION


-- VALIDATION
-- VALIDATE DATE [TRUE OR FALSE]