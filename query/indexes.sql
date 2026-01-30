-- STRUCTURED INDEX
-- 1. CLUSTERED
-- 2. NON-CLUSTERED
USE SalesDB;

-- SYNTAX
-- CREATE THE INDEX
-- CREATE [CLUSTERED | NONCLUSTERED] INDEX index_name ON table_name (col1, col2) ...

SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;

SELECT *
FROM Sales.Customers
WHERE CustomerID = 1;


CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers(CustomerID);

CREATE CLUSTERED INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers(FirstName);

--DROP INDEX
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;

-- EXAMPLE 2
SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown';

-- CREATE NON-CLUSTERED INDEX
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers(LastName);

-- COMPOSITE INDEX
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500; --Order very crucial

CREATE CLUSTERED INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers(Country, Score);


-- STORAGE INDEX
-- 1. ROWSTORE INDEX
-- 2. COLUMNSTORE INDEX
-- CREATE [CLUSTERED | NONCLUSTERED | CLUSTERED] [COLUMNSTORE] Index_name ON table_name(col1, col2)
DROP INDEX index_DBCustomers_CS ON Sales.DBCustomers;


CREATE CLUSTERED COLUMNSTORE INDEX index_DBCustomers_CS
ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX index_DBCustomers_CS_FirstName
ON Sales.DBCustomers(FirstName)



-- Comparing Table Structures
-- 1. HEAP Structure
USE AdventureWorksDW2022;

SELECT *
INTO FactInternetSales_HP
FROM FactInternetSales;

-- ROWSTORE INDEX
SELECT *
INTO FactInternetSales_RS
FROM FactInternetSales;

-- INDEX
CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber)


-- COLUMNSTORE INDEX
SELECT *
INTO FactInternetSales_CS
FROM FactInternetSales;

-- INDEX
CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS


-- Check Storages