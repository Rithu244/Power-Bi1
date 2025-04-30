use Rithu;
select * from customer_orders;
select * from payments;
-- Q1
-- Analyze Order Fulfillment (Status)
SELECT 
    order_status,
    COUNT(*) AS number_of_orders,
    ROUND(SUM(order_amount), 2) AS total_sales
FROM 
    customer_orders
GROUP BY 
    order_status
ORDER BY 
    number_of_orders DESC;
-- Analyze Monthly Sales Trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_sales
FROM 
    customer_orders
GROUP BY 
    month
ORDER BY 
    month;
-- Calculate Key Performance Metrics
SELECT 
    COUNT(order_id) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM 
    customer_orders;
-- Measure Delivery Rate vs Pending
SELECT 
    ROUND(100.0 * SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) / COUNT(*), 2) AS delivery_rate_percent,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'pending' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pending_rate_percent
FROM 
    customer_orders;
-- Identify Top Orders
SELECT 
    order_id,
    customer_id,
    order_amount,
    order_status
FROM 
    customer_orders
ORDER BY 
    order_amount DESC
LIMIT 5;


-- Q2
-- Find Repeat Customers
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_spent
FROM 
    customer_orders
GROUP BY 
    customer_id
HAVING 
    COUNT(order_id) > 1
ORDER BY 
    total_orders DESC;
-- Segment Customers by Spend
SELECT 
    customer_id,
    SUM(order_amount) AS total_spent,
    CASE
        WHEN SUM(order_amount) >= 500 THEN 'High Value'
        WHEN SUM(order_amount) BETWEEN 200 AND 499 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM 
    customer_orders
GROUP BY 
    customer_id
ORDER BY 
    total_spent DESC;
-- Find First-Time Purchase Date (Cohort Month)
SELECT 
    customer_id,
    MIN(DATE_FORMAT(order_date, '%Y-%m')) AS first_purchase_month
FROM 
    customer_orders
GROUP BY 
    customer_id
ORDER BY 
    first_purchase_month;
-- Track Monthly Active Customers
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM 
    customer_orders
GROUP BY 
    month
ORDER BY 
    month;
-- Most Loyal Customers
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(order_amount), 2) AS avg_order_value
FROM 
    customer_orders
GROUP BY 
    customer_id
ORDER BY 
    total_orders DESC
LIMIT 10;

-- Q3
-- Count Payments by Status
SELECT 
    payment_status,
    COUNT(*) AS total_payments,
    ROUND(SUM(payment_amount), 2) AS total_amount
FROM 
    payments
GROUP BY 
    payment_status
ORDER BY 
    total_payments DESC;
-- Calculate Success and Failure Rates
SELECT 
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Success' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate_percentage,
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_percentage
FROM 
    payments;
 -- Monthly Trend of Payment Status
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    payment_status,
    COUNT(*) AS payment_count
FROM 
    payments
GROUP BY 
    month, payment_status
ORDER BY 
    month, payment_status;
-- Orders Without a Successful Payment
SELECT 
    order_id
FROM 
    payments
GROUP BY 
    order_id
HAVING 
    SUM(CASE WHEN payment_status = 'Success' THEN 1 ELSE 0 END) = 0;
-- Failed Payments with High Amounts
SELECT 
    order_id,
    ROUND(SUM(payment_amount), 2) AS total_failed_amount
FROM 
    payments
WHERE 
    payment_status = 'Failed'
GROUP BY 
    order_id
ORDER BY 
    total_failed_amount DESC
LIMIT 10;

-- Q4
-- Join Customer_orders and Payment table

SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    ROUND(o.order_amount, 2) AS order_amount,
    o.order_status,
    p.payment_id,
    p.payment_date,
    ROUND(p.payment_amount, 2) AS payment_amount,
    p.payment_status
FROM 
    customer_orders o
LEFT JOIN 
    payments p ON o.order_id = p.order_id
ORDER BY 
    o.order_date ASC;
    -- Total Orders and Revenue
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.order_amount), 2) AS total_revenue
FROM 
    customer_orders o;
	-- Total Successful Payments
SELECT 
    COUNT(DISTINCT p.payment_id) AS total_successful_payments,
    ROUND(SUM(p.payment_amount), 2) AS revenue_collected
FROM 
    payments p
WHERE 
    p.payment_status = 'Success';
-- Orders with No Successful Payment
SELECT 
    o.order_id,
    o.customer_id,
    o.order_amount,
    o.order_status
FROM 
    customer_orders o
LEFT JOIN 
    payments p ON o.order_id = p.order_id AND p.payment_status = 'Success'
WHERE 
    p.payment_id IS NULL;
 



