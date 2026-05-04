CREATE DATABASE sales_project;
USE sales_project;

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

INSERT INTO customers VALUES
(1, 'Amit', 'Delhi', 'India'),
(2, 'Rahul', 'Mumbai', 'India'),
(3, 'Sneha', 'Bangalore', 'India'),
(4, 'John', 'New York', 'USA'),
(5, 'Sara', 'London', 'UK');

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 800),
(102, 'Phone', 'Electronics', 500),
(103, 'Tablet', 'Electronics', 300),
(104, 'Chair', 'Furniture', 150),
(105, 'Desk', 'Furniture', 250);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(1001, 1, '2024-01-10'),
(1002, 2, '2024-02-15'),
(1003, 3, '2024-03-12'),
(1004, 4, '2024-03-20'),
(1005, 5, '2024-04-05');

-- Order Details Table
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_details VALUES
(1001, 101, 1),
(1001, 102, 2),
(1002, 103, 1),
(1003, 104, 4),
(1004, 105, 2),
(1005, 101, 1),
(1005, 104, 2);


-- Total revenue generated
SELECT 
    SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id;
    

-- Revenue by Product
SELECT
    p.product_name,
    p.category,
    SUM(p.price * od.quantity) AS revenue
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
GROUP BY
    p.product_name,
    p.category
ORDER BY
    revenue DESC;
    
    
-- Top 3 Customers by Revenue
SELECT
	c.customer_name,
    c.city,
    c.country,
    SUM(od.quantity*p.price) AS total_spent
FROM customers c 
JOIN orders o
	ON c.customer_id = o.customer_id
JOIN order_details od
	ON o.order_id = od.order_id
JOIN products p
	ON od.product_id = p.product_id
GROUP BY 
	c.customer_name,
    c.city,
    c.country
ORDER BY 
	total_spent DESC
LIMIT 3;


-- Revenue by Country
SELECT
	c.country,
    SUM(od.quantity*p.price) AS revenue
FROM customers c 
JOIN orders o
	ON c.customer_id = o.customer_id
JOIN order_details od
	ON o.order_id = od.order_id
JOIN products p
	ON od.product_id = p.product_id
GROUP BY 
    c.country
ORDER BY 
	revenue DESC;
    

-- Monthly Sales Trend
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(p.price * od.quantity) AS monthly_revenue
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
GROUP BY
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY
    sales_month;
    

-- Final Dataset Query
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.city,
    c.country,
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    od.quantity,
    (p.price * od.quantity) AS revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
ORDER BY
    o.order_date;