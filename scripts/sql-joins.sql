USE MyDatabase;
-- SQL Joins
-- No Join

SELECT *
FROM customers;

SELECT *
FROM orders;

-- Inner Join
SELECT
	id,
	first_name,
	country,
	score,
	sales
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id

-- Left Join
SELECT
	id,
	first_name,
	o.order_id,
	sales
FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id

--Right join
SELECT
	id,
	first_name,
	o.order_id,
	sales
FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id

SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
LEFT JOIN customers as c
ON c.id = o.customer_id


-- Full Join
SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
FULL JOIN customers as c
ON c.id = o.customer_id

-- Return rows from the left that has no match in Right Table?
-- Filter [Combine the data to check.

-- Customers who have not placed any order
SELECT *
FROM customers as c
LEFT JOIN orders as b
ON c.id = b.customer_id
WHERE b.customer_id is NULL;

SELECT * 
FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id
WHERE c.id is NULL;



-- Full Anti join [Opposite of Inner Join]
SELECT *
FROM customers as c
FULL JOIN orders as b
ON c.id = b.customer_id
WHERE b.customer_id is NULL OR c.id is NULL



-- All customers along with their orders
SELECT *
FROM customers as c
FULL JOIN orders as b
ON c.id = b.customer_id
WHERE b.customer_id is NOT NULL AND c.id is NOT NULL

-- Multiple Table Join
USE SalesDB;


SELECT
	O.OrderID,
	C.FirstName,
	P.Product,
	O.Sales,
	P.Price,
	E.FirstName
FROM Sales.Orders AS O
LEFT JOIN Sales.Customers AS C
ON C.CustomerID = O.CustomerID
LEFT JOIN Sales.Products AS P
ON O.ProductID = P.ProductID
LEFT JOIN Sales.Employees AS E
ON E.EmployeeID = O.SalesPersonID;