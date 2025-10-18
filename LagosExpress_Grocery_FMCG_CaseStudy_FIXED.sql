-- LagosExpress_Grocery FMCG Case Study SQL Script (Corrected)
-- LagosExpress_Grocery

-- 1. Create database (run separately if needed)
-- CREATE DATABASE LagosExpress_Grocery;

-- ==============================
-- TABLE CREATION
-- ==============================

CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    region_id INT REFERENCES regions(region_id),
    join_date DATE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    sale_date DATE
);

-- ==============================
-- DATA INSERTION
-- ==============================

INSERT INTO regions (region_name) VALUES
('North'), ('South'), ('East'), ('West');

INSERT INTO customers (customer_name, region_id, join_date) VALUES
('Mary Johnson', 1, '2022-03-15'),
('Chinedu Okafor', 2, '2023-02-10'),
('Fatima Bello', 1, '2023-05-21'),
('Grace Udo', 3, '2022-07-19'),
('Musa Ibrahim', 4, '2024-01-05');

INSERT INTO products (product_name, category, price) VALUES
('ChocoBite', 'Snacks', 150),
('AquaPure Water', 'Beverages', 100),
('Sparkle Cola', 'Beverages', 200),
('FreshSoap', 'Toiletries', 250),
('NutiMilk', 'Beverages', 300);

INSERT INTO sales (customer_id, product_id, quantity, sale_date) VALUES
(1, 1, 10, '2024-12-05'),
(2, 3, 5, '2024-12-06'),
(3, 2, 12, '2025-01-10'),
(1, 4, 8, '2025-02-05'),
(4, 5, 6, '2025-03-08'),
(5, 3, 10, '2025-03-12'),
(5, 2, 15, '2025-04-01'),
(2, 1, 7, '2025-04-05');

-- ==============================
-- ANALYTICAL QUERIES
-- ==============================

-- Q1. Total amount spent by each customer
SELECT 
    c.customer_name,
    SUM(p.price * s.quantity) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_name;

-- Q2. All customers including those without purchases
SELECT 
    c.customer_name,
    s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY c.customer_name;

-- Q3. All products and their sales (even if not sold)
SELECT 
    p.product_name,
    s.quantity
FROM sales s
RIGHT JOIN products p ON s.product_id = p.product_id
ORDER BY p.product_name;

-- Q4. Total sales revenue per category
SELECT 
    p.category,
    SUM(p.price * s.quantity) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Q5. Monthly sales totals for 2025
SELECT 
    DATE_TRUNC('month', sale_date) AS month,
    SUM(p.price * s.quantity) AS monthly_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE EXTRACT(YEAR FROM sale_date) = 2025
GROUP BY month
ORDER BY month;

-- Q6. Classify customers based on total spending
SELECT 
    c.customer_name,
    SUM(p.price * s.quantity) AS total_spent,
    CASE
        WHEN SUM(p.price * s.quantity) > 3000 THEN 'Premium'
        WHEN SUM(p.price * s.quantity) BETWEEN 1500 AND 3000 THEN 'Regular'
        ELSE 'Low Value'
    END AS customer_segment
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_name;

-- Q7. Best performing region using WITH
WITH region_sales AS (
    SELECT 
        r.region_name,
        SUM(p.price * s.quantity) AS total_sales
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    JOIN regions r ON c.region_id = r.region_id
    JOIN products p ON s.product_id = p.product_id
    GROUP BY r.region_name
)
SELECT * 
FROM region_sales
ORDER BY total_sales DESC;

-- Q8. Combine product categories and region names
SELECT category AS name FROM products
UNION
SELECT region_name AS name FROM regions
ORDER BY name;

-- Q9. Beverage sales above ₦2,000
SELECT 
    c.customer_name,
    p.product_name,
    p.category,
    s.quantity,
    p.price * s.quantity AS total_value
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE p.category = 'Beverages' AND (p.price * s.quantity) > 2000;
