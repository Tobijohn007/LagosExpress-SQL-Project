
# 🧾 LagosExpress Sales Analysis (SQL Project)

## 📘 Project Overview
This project analyzes sales data for **LagosExpress Grocery**, a retail company dealing in fast-moving consumer goods (FMCG).
The goal is to extract actionable insights on **customer behavior, product performance, and regional sales trends** using **SQL**.

The dataset includes information on:
- Customers  
- Products and categories  
- Regions  
- Sales transactions  

All queries were executed in **PostgreSQL**.

---

## 🧰 Tools & Techniques Used
- **PostgreSQL** — database querying and analysis  
- **SQL Joins** — (INNER, LEFT, RIGHT) for relational data  
- **Aggregation Functions** — `SUM()`, `COUNT()`, `AVG()`  
- **Conditional Logic** — `CASE`, `WHERE`, `AND`, `>=`  
- **CTE (WITH)** — for modular and readable queries  
- **UNION** — combining data from different tables  
- **Date Functions** — `DATE_TRUNC()`, `EXTRACT()` for time-based trends  

---

## 🧩 SQL Case Study Questions and Solutions

### **Question 1 — Total Amount Each Customer Spent**
```sql
SELECT 
    c.customer_name,
    SUM(p.price * s.quantity) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;
```
**Insight:**  
Musa Ibrahim and Mary Johnson are the **highest spenders** (₦3,500 each), while Fatima Bello spent the least (₦1,200).  
This shows consistent engagement among high-value customers.

---

### **Question 2 — All Customers (Including Those Without Purchases)**
```sql
SELECT 
    c.customer_name,
    s.sale_id
FROM customers c
LEFT JOIN sales s
ON c.customer_id = s.customer_id
ORDER BY c.customer_name;
```
**Insight:**  
All customers in the dataset have made at least one purchase, indicating a **100% active customer base**.

---

### **Question 3 — All Products (Including Unsold Ones)**
```sql
SELECT 
    p.product_name,
    s.sale_id,
    s.quantity,
    s.sale_date
FROM sales s
RIGHT JOIN products p
ON s.product_id = p.product_id
ORDER BY p.product_name;
```
**Insight:**  
All products recorded sales, showing **no unsold inventory** — a positive indicator for demand management.

---

### **Question 4 — Total Sales Revenue per Category**
```sql
SELECT 
    p.category,
    SUM(p.price * s.quantity) AS total_revenue
FROM sales s
JOIN products p 
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
```
**Insight:**  
**Beverages** generated the highest revenue (₦7,500), followed by **Snacks (₦2,550)** and **Toiletries (₦2,000)** — making Beverages the most profitable product category.

---

### **Question 5 — Monthly Sales Totals for 2025**
```sql
SELECT 
    TO_CHAR(s.sale_date, 'Month YYYY') AS month,
    SUM(p.price * s.quantity) AS monthly_revenue
FROM sales s
JOIN products p 
ON s.product_id = p.product_id
WHERE EXTRACT(YEAR FROM s.sale_date) = 2025
GROUP BY TO_CHAR(s.sale_date, 'Month YYYY')
ORDER BY MIN(s.sale_date);
```
**Insight:**  
Sales peaked in **March 2025 (₦3,800)**, while **January (₦1,200)** had the lowest sales, indicating possible post-holiday slowdowns.

---

### **Question 6 — Customer Spending Classification**
```sql
SELECT 
    c.customer_name,
    SUM(p.price * s.quantity) AS total_spent,
    CASE
        WHEN SUM(p.price * s.quantity) >= 3000 THEN 'High Spender'
        WHEN SUM(p.price * s.quantity) BETWEEN 2000 AND 2999 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spending_category
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;
```
**Insight:**  
Mary Johnson and Musa Ibrahim are **High Spenders**, Chinedu Okafor is a **Medium Spender**, and Fatima Bello & Grace Udo are **Low Spenders**.  
This segmentation helps target promotions and loyalty rewards effectively.

---

### **Question 7 — Best-Performing Region (Using `WITH` / CTE)**
```sql
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
```
**Insight:**  
The **North region** leads with ₦4,700 in sales, followed by the **West (₦3,500)**.  
This suggests high product demand in the North and potential for growth initiatives in lower-performing regions.

---

### **Question 8 — Combine Product Categories and Region Names (Using `UNION`)**
```sql
SELECT category AS name_or_category FROM products
UNION
SELECT region_name AS name_or_category FROM regions
ORDER BY name_or_category;
```
**Insight:**  
Merges all **unique categories and region names** into one unified list, useful for creating combined filters, dashboards, or reference lists.  
Demonstrates SQL’s `UNION` capability for merging different data domains.

---

### **Question 9 — Beverage Sales ₦2,000 and Above (Using Logical Operators)**
```sql
SELECT 
    s.sale_id,
    c.customer_name,
    p.product_name,
    p.category,
    s.quantity,
    (p.price * s.quantity) AS total_value
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN customers c ON s.customer_id = c.customer_id
WHERE p.category = 'Beverages'
AND (p.price * s.quantity) >= 2000
ORDER BY total_value DESC;
```
**Insight:**  
Only one beverage transaction (**Sparkle Cola — ₦2,000**) met the threshold.  
This suggests beverage purchases are frequent but typically of **smaller transaction value**, highlighting opportunities to **promote bulk or premium sales**.

---

## 📊 Project Summary

| Area | Key Finding |
|------|--------------|
| Top Customers | Mary Johnson & Musa Ibrahim (₦3,500 each) |
| Best Category | Beverages (₦7,500) |
| Peak Month | March 2025 |
| Best Region | North (₦4,700) |
| High-Value Beverage Sale | Sparkle Cola (₦2,000) |

---

## 🧠 Conclusion
This SQL project demonstrates end-to-end data analysis on sales, customers, and product performance.  
Through joins, aggregations, logical filters, and CTEs, the analysis provides actionable insights into **customer behavior**, **regional performance**, and **sales trends**.  
It showcases the power of SQL in transforming raw transactional data into business intelligence.

---

### 👨🏽‍💻 Project Contribution
**Data Cleaning, Query Development, and Visualization by Oluwatobi Akinrotoye**
