-- ============================================================
--          AMAZON SALES PROJECT — PostgreSQL
-- ============================================================
-- Prepared By   : TWINKLE BISWAL
-- Database : amazon_project
-- Description: End-to-end sales analysis — data cleaning,
--              EDA, window functions, CTEs & subqueries
-- ============================================================


-- ============================================================
-- SECTION 1 : DATABASE & TABLE SETUP
-- ============================================================

CREATE DATABASE amazon_project;

CREATE TABLE amazon__sales (
    OrderID       VARCHAR(20),
    OrderDate     DATE,
    CustomerID    VARCHAR(20),
    CustomerName  VARCHAR(100),
    ProductID     VARCHAR(20),
    ProductName   VARCHAR(200),
    Category      VARCHAR(20),
    Brand         VARCHAR(20),
    Quantity      INT,
    UnitPrice     NUMERIC(10, 2),
    Discount      NUMERIC(10, 2),
    Tax           NUMERIC(10, 2),
    ShippingCost  NUMERIC(10, 2),
    TotalAmount   NUMERIC(10, 2),
    PaymentMethod VARCHAR(20),
    OrderStatus   VARCHAR(50),
    City          VARCHAR(20),
    State         VARCHAR(100),
    Country       VARCHAR(100),
    SellerID      VARCHAR(100)
);


-- ============================================================
-- SECTION 2 : DATA CLEANING
-- ============================================================

-- NULL CHECK
-- -------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_rows,
    COUNT(*) FILTER (WHERE OrderID IS NULL)         AS null_OrderID,
    COUNT(*) FILTER (WHERE OrderDate IS NULL)       AS null_OrderDate,
    COUNT(*) FILTER (WHERE CustomerID IS NULL)      AS null_CustomerID,
    COUNT(*) FILTER (WHERE CustomerName IS NULL)    AS null_CustomerName,
    COUNT(*) FILTER (WHERE ProductID IS NULL)       AS null_ProductID,
    COUNT(*) FILTER (WHERE ProductName IS NULL)     AS null_ProductName,
    COUNT(*) FILTER (WHERE Category IS NULL)        AS null_Category,
    COUNT(*) FILTER (WHERE Brand IS NULL)           AS null_Brand,
    COUNT(*) FILTER (WHERE Quantity IS NULL)        AS null_Quantity,
    COUNT(*) FILTER (WHERE UnitPrice IS NULL)       AS null_UnitPrice,
    COUNT(*) FILTER (WHERE Discount IS NULL)        AS null_Discount,
    COUNT(*) FILTER (WHERE TotalAmount IS NULL)     AS null_TotalAmount,
    COUNT(*) FILTER (WHERE City IS NULL)            AS null_City,
    COUNT(*) FILTER (WHERE Country IS NULL)         AS null_Country
FROM amazon__sales;


-- DUPLICATE CHECK
-- -------------------------------------------------------
SELECT
    OrderID,
    ProductID,
    COUNT(*) AS duplicate_count
FROM amazon__sales
GROUP BY OrderID, ProductID
HAVING COUNT(*) > 1;


-- ============================================================
-- SECTION 3 : CREATE CLEAN NORMALIZED TABLES
-- ============================================================

-- CUSTOMERS
-- -------------------------------------------------------
CREATE TABLE customers AS
SELECT DISTINCT
    CustomerID,
    CustomerName,
    City,
    Country
FROM amazon__sales;


-- PRODUCTS
-- -------------------------------------------------------
CREATE TABLE products AS
SELECT DISTINCT
    ProductID,
    ProductName,
    Category,
    Brand,
    UnitPrice
FROM amazon__sales;


-- ORDERS
-- -------------------------------------------------------
CREATE TABLE orders AS
SELECT DISTINCT
    OrderID,
    OrderDate,
    CustomerID,
    PaymentMethod,
    OrderStatus,
    SellerID
FROM amazon__sales;


-- ORDER DETAILS
-- -------------------------------------------------------
CREATE TABLE order_detail AS
SELECT DISTINCT
    OrderID,
    ProductID,
    OrderDate,
    Quantity,
    Discount,
    Tax,
    ShippingCost,
    TotalAmount
FROM amazon__sales;


-- ============================================================
-- SECTION 4 : EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================================

-- TOTAL REVENUE
-- -------------------------------------------------------
SELECT
    ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM order_detail;


-- TOTAL ORDERS
-- -------------------------------------------------------
SELECT
    COUNT(OrderID) AS total_orders
FROM orders;


-- TOTAL CUSTOMERS
-- -------------------------------------------------------
SELECT
    COUNT(CustomerID) AS total_customers
FROM customers;


-- TOP 10 SELLING PRODUCTS (BY QUANTITY)
-- -------------------------------------------------------
SELECT
    p.ProductName,
    SUM(od.Quantity) AS total_quantity
FROM products p
JOIN order_detail od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY total_quantity DESC
LIMIT 10;


-- TOP 5 HIGHEST REVENUE PRODUCTS
-- -------------------------------------------------------
SELECT
    p.ProductName,
    ROUND(SUM(od.TotalAmount), 2) AS total_revenue
FROM products p
JOIN order_detail od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY total_revenue DESC
LIMIT 5;


-- REVENUE BY CATEGORY
-- -------------------------------------------------------
SELECT
    p.Category,
    ROUND(SUM(od.TotalAmount), 2) AS total_revenue
FROM products p
JOIN order_detail od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY total_revenue DESC;


-- MONTHLY SALES TREND
-- -------------------------------------------------------
SELECT
    EXTRACT(MONTH FROM o.OrderDate) AS month_no,
    ROUND(SUM(od.TotalAmount), 2)   AS monthly_sales
FROM orders o
JOIN order_detail od ON o.OrderID = od.OrderID
GROUP BY month_no
ORDER BY month_no;


-- TOP 10 CUSTOMERS BY SPENDING
-- -------------------------------------------------------
SELECT
    c.CustomerID,
    c.CustomerName,
    ROUND(SUM(od.TotalAmount), 2) AS total_spent
FROM customers c
JOIN orders o      ON c.CustomerID = o.CustomerID
JOIN order_detail od ON od.OrderID = o.OrderID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY total_spent DESC
LIMIT 10;


-- REPEAT CUSTOMERS (MORE THAN 1 ORDER)
-- -------------------------------------------------------
SELECT
    CustomerID,
    COUNT(OrderID) AS order_count
FROM orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1;


-- MOST USED PAYMENT METHOD
-- -------------------------------------------------------
SELECT
    PaymentMethod,
    COUNT(*) AS total_orders
FROM orders
GROUP BY PaymentMethod
ORDER BY total_orders DESC;


-- ORDER STATUS BREAKDOWN
-- -------------------------------------------------------
SELECT
    OrderStatus,
    COUNT(*) AS total_orders
FROM orders
GROUP BY OrderStatus
ORDER BY total_orders DESC;


-- PRODUCTS WITH HIGHEST DISCOUNT
-- -------------------------------------------------------
SELECT
    ProductID,
    MAX(Discount) AS highest_discount
FROM order_detail
GROUP BY ProductID
ORDER BY highest_discount DESC;


-- COUNTRY-WISE REVENUE
-- -------------------------------------------------------
SELECT
    c.Country,
    ROUND(SUM(od.TotalAmount), 2) AS total_revenue
FROM customers c
JOIN orders o        ON c.CustomerID = o.CustomerID
JOIN order_detail od ON od.OrderID   = o.OrderID
GROUP BY c.Country
ORDER BY total_revenue DESC;


-- AVERAGE ORDER VALUE
-- -------------------------------------------------------
SELECT
    ROUND(AVG(TotalAmount), 2) AS avg_order_value
FROM order_detail;


-- SALES BY BRAND
-- -------------------------------------------------------
SELECT
    p.Brand,
    ROUND(SUM(od.TotalAmount), 2) AS total_sales
FROM products p
JOIN order_detail od ON p.ProductID = od.ProductID
GROUP BY p.Brand
ORDER BY total_sales DESC;


-- TOP 5 MOST EXPENSIVE PRODUCTS
-- -------------------------------------------------------
SELECT
    ProductID,
    ProductName,
    UnitPrice
FROM products
ORDER BY UnitPrice DESC
LIMIT 5;


-- TAX CONTRIBUTION BY CATEGORY
-- -------------------------------------------------------
SELECT
    p.Category,
    SUM(od.Tax) AS total_tax
FROM products p
JOIN order_detail od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY total_tax DESC;


-- SHIPPING COST BY COUNTRY
-- -------------------------------------------------------
SELECT
    c.Country,
    SUM(od.ShippingCost) AS total_shipping_cost
FROM customers c
JOIN orders o        ON c.CustomerID = o.CustomerID
JOIN order_detail od ON od.OrderID   = o.OrderID
GROUP BY c.Country
ORDER BY total_shipping_cost DESC;


-- REVENUE AFTER DISCOUNT (NET REVENUE)
-- -------------------------------------------------------
SELECT
    ROUND(SUM(TotalAmount), 2)            AS gross_revenue,
    ROUND(SUM(TotalAmount - Discount), 2) AS net_revenue,
    CASE
        WHEN SUM(TotalAmount) > SUM(TotalAmount - Discount) THEN '✅ Profit'
        ELSE '❌ Loss'
    END AS status
FROM order_detail;


-- ============================================================
-- SECTION 5 : WINDOW FUNCTIONS
-- ============================================================

-- RUNNING CUMULATIVE REVENUE (BY DATE)
-- -------------------------------------------------------
SELECT
    o.OrderDate,
    SUM(od.TotalAmount)                                          AS daily_revenue,
    SUM(SUM(od.TotalAmount)) OVER (ORDER BY o.OrderDate)         AS cumulative_revenue
FROM orders o
JOIN order_detail od ON o.OrderID = od.OrderID
GROUP BY o.OrderDate
ORDER BY o.OrderDate;


-- RANK PRODUCTS BY TOTAL REVENUE
-- -------------------------------------------------------
SELECT
    p.ProductName,
    SUM(od.TotalAmount)                                          AS total_revenue,
    RANK() OVER (ORDER BY SUM(od.TotalAmount) DESC)              AS revenue_rank
FROM products p
JOIN order_detail od ON p.ProductID = od.ProductID
GROUP BY p.ProductName;


-- ============================================================
-- SECTION 6 : SUBQUERIES
-- ============================================================

-- PRODUCTS PRICED ABOVE AVERAGE (OVERALL)
-- -------------------------------------------------------
SELECT
    ProductName,
    UnitPrice
FROM products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM products
);


-- CUSTOMERS SPENDING ABOVE AVERAGE ORDER VALUE
-- -------------------------------------------------------
SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(od.TotalAmount) AS total_spending
FROM customers c
JOIN orders o        ON c.CustomerID = o.CustomerID
JOIN order_detail od ON od.OrderID   = o.OrderID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.TotalAmount) > (
    SELECT AVG(TotalAmount)
    FROM order_detail
);


-- PRODUCTS NEVER SOLD
-- -------------------------------------------------------
SELECT *
FROM products
WHERE ProductID NOT IN (
    SELECT ProductID
    FROM order_detail
);


-- PRODUCTS PRICED ABOVE THEIR CATEGORY AVERAGE
-- -------------------------------------------------------
SELECT
    p1.ProductID,
    p1.ProductName,
    p1.Category,
    p1.UnitPrice
FROM products p1
WHERE p1.UnitPrice > (
    SELECT AVG(p2.UnitPrice)
    FROM products p2
    WHERE p1.Category = p2.Category
);


-- ============================================================
-- SECTION 7 : CTEs (COMMON TABLE EXPRESSIONS)
-- ============================================================

-- CATEGORY REVENUE BREAKDOWN
-- -------------------------------------------------------
WITH category_revenue AS (
    SELECT
        p.Category,
        ROUND(SUM(od.TotalAmount), 2) AS revenue
    FROM products p
    JOIN order_detail od ON p.ProductID = od.ProductID
    GROUP BY p.Category
)
SELECT *
FROM category_revenue
ORDER BY revenue DESC;


-- ============================================================
-- END OF SCRIPT
-- ============================================================