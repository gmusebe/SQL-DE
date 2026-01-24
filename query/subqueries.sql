--METADATA:
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS

-- RESULT TYPE SUBQUERY
-- 1. SCALAR - Single Value
-- 2. ROW - Multiple Rows of a Single Column
-- 3. TABLE - Multiple Rows of Multiple Columns

-- Subquery in the FROM Clause [TABLE SUBQUERY]
-- Find the products that have a higher price  than the average price of all products

SELECT
	*
FROM (
	--SubQuery
	SELECT
		*,
		AVG(Price) OVER() AvgPrice
	FROM Sales.Products
)t
WHERE Price > AvgPrice;

-- RANK customers based on their total amount of sale:

SELECT 
	*,
	RANK() OVER(ORDER BY TotalSales DESC) CustomerRankSales
FROM (
	SELECT
	 CustomerID,
	 SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)t


-- Subquery in the FROM SELECT [SCALAR]
-- The subquery MUST be a scalar query [Result to a single value]
-- Show the product IDs, names, prices and total number of orders

SELECT
	ProductID,
	Product,
	Price,
	(
		SELECT
			COUNT(*) 
		FROM Sales.Orders
	) TotalOrders
FROM Sales.Products

-- Subquery in the JOIN
--Show all customer delatails and Find the total number of orders for each customer
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
ON Main.CustomerID = t.CustomerID 

-- Subquery in the WHERE
-- Comparison Operators [Subquery Must be Scalar]

-- Find the products that have  a higher price than the average price of all products

SELECT *
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

-- Subquery in the WHERE (Logical IN) [ ROW]
-- Show the deatails of orders made by customers in Germany

SELECT
	*
FROM Sales.Orders
WHERE CustomerID IN
					(
						SELECT
							CustomerID
						FROM Sales.Customers
						WHERE Country = 'Germany'
					)

SELECT
	*
FROM Sales.Orders
WHERE CustomerID NOT IN
					(
						SELECT
							CustomerID
						FROM Sales.Customers
						WHERE Country = 'Germany'
					)


-- Subquery in the WHERE (Logical ANY | ALL) [ ROW]
-- Find female Employees  whose Salaries are greater than the salaries of any  male Employee

SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY (
									SELECT
									Salary
									FROM Sales.Employees
									WHERE Gender = 'M')


SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > All (
									SELECT
									Salary
									FROM Sales.Employees
									WHERE Gender = 'M')

-- NON-CORRELATED A subquery that can run independent of the Main query (ALL THE ABOVE)
-- Subquery in the CORRELATED

-- Show all customer deatails and find the total orders of each customer
SELECT
	*,
	(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID =c.CustomerID) TotalSales
FROM Sales.Customers c

-- Subquery using EXIST

-- Show the Details of orders made by Customers in Germay
SELECT
	*
FROM Sales.Orders O
WHERE EXISTS (
			SELECT 1
			FROM Sales.Customers c
			WHERE Country = 'Germany'
			AND o.CustomerID = c.CustomerID
			)