CREATE DATABASE customer_project;
USE customer_project;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO customers VALUES
(1, 'Amit', 'Delhi'),
(2, 'Rahul', 'Mumbai'),
(3, 'Sneha', 'Bangalore'),
(4, 'John', 'New York'),
(5, 'Sara', 'London'),
(6, 'Riya', 'Delhi'),
(7, 'Karan', 'Mumbai');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(101, 1, '2024-01-10', 500),
(102, 1, '2024-02-15', 700),
(103, 2, '2024-02-20', 200),
(104, 3, '2024-03-12', 900),
(105, 4, '2024-03-25', 300),
(106, 5, '2024-04-05', 800),
(107, 5, '2024-04-10', 400),
(108, 6, '2024-04-12', 150),
(109, 7, '2024-04-15', 250);


-- Total spending per customer
SELECT 
	   c.customer_id,
       c.customer_name,
	   c.city,
	   SUM(o.amount) AS Total_spent
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
GROUP BY 
	c.customer_id,
	c.customer_name,
    c.city
ORDER BY 
	Total_spent DESC;
    

-- Customer Segmentation High Value → > 1000 Medium → 500–1000 Low → < 500
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(o.amount) AS total_spent,
    
    CASE 
        WHEN SUM(o.amount) > 1000 THEN 'High Value'
        WHEN SUM(o.amount) BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY 
    c.customer_id,
    c.customer_name,
    c.city

ORDER BY 
    total_spent DESC;
    
    
-- Number of customers in each segments
SELECT 
    segment,
    COUNT(*) AS customer_count
FROM (
    
    SELECT 
        c.customer_id,
        SUM(o.amount) AS total_spent,

        CASE 
            WHEN SUM(o.amount) > 1000 THEN 'High'
            WHEN SUM(o.amount) >= 500 THEN 'Medium'
            ELSE 'Low'
        END AS segment

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id

) AS customer_segments

GROUP BY segment;


-- Average order value per customer
SELECT
	c.customer_id,
    c.customer_name,
    c.city,
    AVG(o.amount) AS Average_Order_Value
FROM customers c
JOIN orders o
	ON 	c.customer_id =  o.customer_id
GROUP BY 
	c.customer_id,
    c.customer_name
ORDER BY 
	Average_Order_Value DESC;
    
    
-- Repeat Customers
SELECT
	c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS count_of_order
FROM customers c
JOIN orders o
	ON 	c.customer_id =  o.customer_id
GROUP BY 
	c.customer_id,
    c.customer_name,
    c.city
HAVING COUNT(o.order_id) > 1;


-- Final Table
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.amount
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY 
    c.customer_id;
	
    


    
    



