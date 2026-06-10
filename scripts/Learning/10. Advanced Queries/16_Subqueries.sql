/* ==============================================================================
   SQL Subquery Functions
-------------------------------------------------------------------------------
   This script demonstrates various subquery techniques in SQL.
   It covers result types, subqueries in the FROM clause, in SELECT, in JOIN clauses,
   with comparison operators, IN, ANY, correlated subqueries, and EXISTS.
   
   Table of Contents:
     1. SUBQUERY - RESULT TYPES
     2. SUBQUERY - FROM CLAUSE
     3. SUBQUERY - SELECT
     4. SUBQUERY - JOIN CLAUSE
     5. SUBQUERY - COMPARISON OPERATORS 
     6. SUBQUERY - IN OPERATOR
     7. SUBQUERY - ANY OPERATOR
     8. SUBQUERY - CORRELATED 
     9. SUBQUERY - EXISTS OPERATOR
===============================================================================
*/

USE SalesDB;

/* ==============================================================================
   SUBQUERY | RESULT TYPES
===============================================================================*/

/* Scalar Query 
	Returns a value
*/

SELECT
	AVG(Sales)
FROM Sales.Orders;

/* Row Query
	Returns a single column
*/
SELECT
	CustomerID
FROM Sales.Orders;

/* Table Query 
	Returns an entire table (a combination of more than one column)
*/
SELECT
	OrderID,
	OrderDate
FROM Sales.Orders;

/* ==============================================================================
   SUBQUERY | FROM CLAUSE
   Must be a table
===============================================================================*/

/* TASK 1:
   Find the products that have a price higher than the average price of all products.
*/
SELECT
	*
FROM(
	-- Subquery
	SELECT
		ProductID,
		Price,
		AVG(Price) OVER() AS AvgPrice
	FROM Sales.Products
)t
WHERE Price > AvgPrice;

/* TASK 2:
   Rank Customers based on their total amount of sales.
*/
SELECT
	*,
	RANK() OVER(ORDER BY TotalSales DESC) AS Ranking
FROM(
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)t;

/* ==============================================================================
   SUBQUERY | SELECT
   Scalar Subquery: A single value
===============================================================================*/
/* TASK 3:
   Show the product IDs, product names, prices, and the total number of orders.
*/
SELECT
	ProductID,
	Product,
	Price,
	(
		SELECT
			COUNT(*) 
		FROM Sales.Orders
	) TotalOrders
FROM Sales.Products;

/* ==============================================================================
   SUBQUERY | JOIN CLAUSE
===============================================================================*/
/* TASK 4:
   Show customer details along with their total orders.
*/
SELECT 
	Main.*,
	t.TotalOrders
FROM Sales.Customers as Main
LEFT JOIN (
	SELECT
		CustomerID,
		COUNT(CustomerID) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID
)t
ON Main.CustomerID = t.CustomerID;

/* ==============================================================================
   SUBQUERY  | COMPARISON OPERATORS | WHERE CLAUSE
   Scalar Value
===============================================================================*/
/* TASK 5:
   Find the products that have  a higher price than the average price of all products
*/
SELECT
	*
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);

/* ==============================================================================
   SUBQUERY | IN OPERATOR
===============================================================================*/
/* TASK 6:
   Show the details of orders made by customers in Germany.
*/
SELECT
	*
FROM Sales.Orders
WHERE CustomerID IN (
	SELECT
		CustomerID
	FROM Sales.Customers
	WHERE Country = 'Germany'
);

/* TASK 7:
   Show the details of orders made by customers not in Germany.
*/
SELECT
	*
FROM Sales.Orders
WHERE CustomerID NOT IN(
	SELECT
		CustomerID
	FROM Sales.Customers
	WHERE Country = 'Germany'
);

/* ==============================================================================
   SUBQUERY | ANY OPERATOR
   Subquery in the WHERE (Logical ANY | ALL) [ ROW]
===============================================================================*/
/* TASK 9:
   Find female employees whose salaries are greater than the salaries of any male employees.
*/
SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY (
	SELECT
		Salary
	FROM Sales.Employees
	WHERE Gender = 'M'
);

/* TASK 9:
   Find female employees whose salaries are greater than the salaries of all male employees.
*/
SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > All (
	SELECT
		Salary
	FROM Sales.Employees
	WHERE Gender = 'M');

/* ==============================================================================
   CORRELATED SUBQUERY
===============================================================================*/
/* TASK 10:
   Show all customer details and the total orders for each customer using a correlated subquery.
*/
SELECT
	*,
	(
		SELECT
			COUNT(*)
		FROM Sales.Orders o
		WHERE o.CustomerID =c.CustomerID
	) TotalSales
FROM Sales.Customers c;

/* ==============================================================================
   SUBQUERY | EXISTS OPERATOR
===============================================================================*/

/* TASK 11:
   Show the details of orders made by customers in Germany.
*/
SELECT
	*
FROM Sales.Orders o
WHERE EXISTS (
	SELECT 1
	FROM Sales.Customers c
	WHERE Country = 'Germany'
	AND o.CustomerID = c.CustomerID
);