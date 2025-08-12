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