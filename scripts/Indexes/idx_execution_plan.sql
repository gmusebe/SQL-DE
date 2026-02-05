USE AdventureWorksDW2022;

SELECT *
INTO FactResellerSales_HP
FROM dbo.FactResellerSales;

-- EXECUTION PLAN FOR QUERY:
SELECT *
FROM FactResellerSales_HP
ORDER BY SalesOrderNumber;

-- With INDEX uses less CPU Cost
SELECT *
FROM FactResellerSales
ORDER BY SalesOrderNumber;

--EXAMPLE 2
SELECT *
FROM FactResellerSales
WHERE CarrierTrackingNumber = '4E0A-4F89-AE';

CREATE NONCLUSTERED INDEX idx_FactReseller_CTA
ON FactResellerSales(CarrierTrackingNumber)

SELECT *
FROM FactResellerSales_HP
WHERE CarrierTrackingNumber = '4E0A-4F89-AE';

--EXAMPLE 3
SELECT
 p.EnglishProductName ProductName,
 SUM(s.SalesAmount) TotalSales
FROM FactResellerSales s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName


SELECT
 p.EnglishProductName ProductName,
 SUM(s.SalesAmount) TotalSales
FROM FactResellerSales_HP s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactResellerSalesHP
ON FactResellerSales_HP



-- SQL Hints
USE SalesDB;

SELECT
	o.Sales,
	c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH (FORCESEEK)
ON o.CustomerID = c.CustomerID
-- OPTION (HASH JOIN)

SELECT
	o.Sales,
	c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH(INDEX([PK_Customer_A4AE64B87FC20A48]))
ON o.CustomerID = c.CustomerID
-- OPTION (HASH JOIN)