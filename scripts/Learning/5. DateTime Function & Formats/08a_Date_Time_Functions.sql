/* ==============================================================================
SQL Date & Time Functions
-------------------------------------------------------------------------------
This script demonstrated various SQL date and time functions. It covers the 
following:
	Table of Contents:
	1. GETDATE | Date Values
	2. Date Part Extractions (DATETRUNC, DATENAME, DATEPART, YEAR, MONTH, DAY)
	3. EOMONTH
	4. Date Part
	5. FORMAT
	6. CONVERT
	7. CAST
	8. DATEADD/DATEDIFF
	9. ISDATE

===============================================================================
*/

USE SalesDB;

/* ==============================================================================
   GETDATE() | DATE VALUES
===============================================================================*/

/* TASK 1:
   Display OrderID, CreationTime, a hard-coded date, and the current system date.
*/

SELECT
	OrderID,
	CreationTime,
	'2026-04-03',
	GETDATE() 
 FROM Sales.Orders;

/* ==============================================================================
   DATE PART EXTRACTIONS
   (DATETRUNC, DATENAME, DATEPART, YEAR, MONTH, DAY)
===============================================================================*/
/* TASK 2:
   Extract various parts of CreationTime using DATETRUNC, DATENAME, DATEPART,
   YEAR, MONTH, and DAY.
*/

SELECT
	OrderID,
	CreationTime,

	-- DARETRUNC
	DATETRUNC(YEAR, CreationTime)   AS Year_dt,
	DATETRUNC(MONTH, CreationTime)  AS Month_dt,
	DATETRUNC(DAY, CreationTime)    AS Day_dt,
	DATETRUNC(HOUR, CreationTime)   AS Hour_dt,

	-- MINUTE
	DATETRUNC(MINUTE, CreationTime) AS Minute_dt,
	DATETRUNC(SECOND, CreationTime) AS Second_dt,

	-- DATENAME
	DATENAME(YEAR, CreationTime)    AS Year_dn,
	DATENAME(MONTH, CreationTime)   AS Month_dn,
	DATENAME(WEEKDAY, CreationTime) AS Weekday_dn,
	DATENAME(DAY, CreationTime)     AS Day_dn,

	-- DATEPART
	DATEPART(YEAR, CreationTime)    AS Year_dp,

	--QUARTER
	DATEPART(QUARTER, CreationTime) AS Quarter_dp,
	DATEPART(MONTH, CreationTime)   AS Month_dp,
	DATEPART(WEEK, CreationTime)    AS Week_dp,
	DATEPART(DAY, CreationTime)     AS Day_dp,

	-- HOUR
	DATEPART(HOUR, CreationTime)    AS Hour_dp,

	-- PART EXTRACTION:
	-- YEAR
	YEAR(CreationTime) AS Year,

	-- MONTH
	MONTH(CreationTime) AS Month,

	-- DAY
	DAY(CreationTime) AS Day
FROM Sales.Orders;

/* ==============================================================================
   DATETRUNC() DATA AGGREGATION
===============================================================================*/
/* TASK 3:
   Aggregate orders by year using DATETRUNC on CreationTime.
*/
SELECT
	-- DARETRUNC
	DATETRUNC(YEAR, CreationTime)   AS Year_dt,
	COUNT(*) AS Total_Orders
FROM Sales.Orders
GROUP BY DATETRUNC(YEAR, CreationTime);

/* ==============================================================================
   EOMONTH()
===============================================================================*/
/* TASK 4:
   Display OrderID, CreationTime, and the end-of-month date for CreationTime.
*/
SELECT 
	OrderID,
	CreationTime,
	-- end-of-month date for CreationTime
	EOMONTH(CreationTime) AS EndOfMonth
FROM Sales.Orders;

/* ==============================================================================
   DATE PARTS | USE CASES
===============================================================================*/
/* TASK 5:
   How many orders were placed each year?
*/
SELECT
	YEAR(OrderDate) AS Order_Year,
	COUNT(*) AS Total_Orders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

/* TASK 6:
   How many orders were placed each month?
*/
SELECT
	MONTH(OrderDate) AS Order_Month,
	COUNT(*) AS Total_Orders
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

/* TASK 7:
   How many orders were placed each month (using friendly month names)?
*/
SELECT
	DATENAME(MONTH, OrderDate) AS Order_Month,
	COUNT(*) AS Total_Orders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);

/* TASK 8:
   Show all orders that were placed during the month of February.
*/
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2;

/* ==============================================================================
   FORMAT()
===============================================================================*/
-- CHANGE DATE FORMAT

SELECT 
	CreationTime,
	FORMAT(CreationTime, 'MM/dd/yyyy') USA_Format,
	FORMAT(CreationTime, 'dd-MM-yyyy') AS EURO_Format,
	FORMAT(CreationTime, 'dd') dd,
	FORMAT(CreationTime, 'ddd') ddd,
	FORMAT(CreationTime, 'dddd') dddd,
	FORMAT(CreationTime, 'MM') MM,
	FORMAT(CreationTime, 'MMM') MMM,
	FORMAT(CreationTime, 'MMMMM') MMMM
FROM Sales.Orders;

/* TASK 10:
   Display CreationTime using a custom format:
   Example: Day Wed Jan Q1 2025 12:34:56 PM
*/
SELECT 
	CreationTime,
	'Day ' + FORMAT(CreationTime, 'ddd MMM') +
	' Q' + DATENAME(QUARTER, CreationTime) + ' ' +
	FORMAT(CreationTime, 'yyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders;

/* TASK 11:
   How many orders were placed each year, formatted by month and year (e.g., "Jan 25")?
*/
SELECT
	FORMAT(OrderDate, 'MMM yy'),
	COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy');

/* ==============================================================================
   CONVERT()
===============================================================================*/
/* TASK 12:
   Demonstrate conversion using CONVERT.
*/
SELECT
	CONVERT(INT, '123') AS [String to Int CONVERT],
	CONVERT(DATE, '2025-08-20') AS  [String to Date CONVERT],
	CreationTime,
	CONVERT(DATE,CreationTime) AS  [Datetime to Date CONVERT],
	CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
	CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM Sales.Orders;

/* ==============================================================================
   CAST()
===============================================================================*/
/* TASK 13:
   Convert data types using CAST.
*/

SELECT
	CAST('123' AS INT) [String to Int],
	CAST(123 AS VARCHAR) [Int to String],
	CAST('2025-08-20' AS DATETIME2) [String to Datetime],
	CAST(CreationTime AS DATE) [Datetime TO Date]
FROM Sales.Orders;

/* ==============================================================================
DATEADD() / DATEDIFF()
===============================================================================*/
/* TASK 14:
   Perform date arithmetic on OrderDate.
*/
SELECT
	OrderID,
	OrderDate,
	DATEADD(MINUTE, 45, CAST(OrderDate AS DATETIME2)) AS FortyFiveMinutesLater,
	DATEADD(DAY, -13, OrderDate) AS ThirteenDaysBefore,
	DATEADD(MONTH, 2, OrderDate) AS TwoMonthsLater,
	DATEADD(YEAR, 2, OrderDate) AS TwoYearsLater
FROM Sales.Orders;

/* TASK 15:
   Calculate the age of employees.
   -- Use it with Victims and Perpetrators in Crime DB! 
*/
SELECT
	EmployeeID,
	BirthDate,
	DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM Sales.Employees;

/* TASK 16:
   Find the average shipping duration in days for each month.
*/

SELECT
	DATENAME(MONTH, OrderDate) [Order Month],
	AVG(DATEDIFF(DAY, OrderDate, ShipDate))  [AVG Ship Duration]
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);

/* TASK 17:
   Time Gap Analysis: Find the number of days between each order and the previous order.
*/
SELECT 
	OrderID,
	OrderDate CurrentOrderDate,
	LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
	DATEDIFF(DAY, LAG(OrderDate) OVER  (ORDER BY OrderDate), OrderDate) NrOfDays
FROM Sales.Orders;


SELECT 
    OrderID,
    OrderDate AS CurrentOrderDate,
    ISNULL(LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) AS PreviousOrderDate,
    ISNULL(DATEDIFF(DAY, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate), 0) AS NrOfDays
FROM Sales.Orders;

/* ==============================================================================
   ISDATE(): Validation by boolean output   
===============================================================================*/
/* TASK 18:
   Validate OrderDate using ISDATE and convert valid dates.
*/
SELECT
	OrderDate,
	ISDATE(OrderDate) AS IsValidDate,
	CASE
		WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		ELSE '9999-01-01'
	END AS NewOrderDate
FROM
(
	SELECT '2025-08-20' AS OrderDate UNION
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08'
) AS t
