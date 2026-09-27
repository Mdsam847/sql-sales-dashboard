-- analysis_queries.sql
-- Each query below answers one business question about the orders table
-- and maps directly to a section of dashboard.html.

-- 1. Headline numbers: total revenue, total profit, order count, average order value
SELECT
    ROUND(SUM(sales), 2)              AS total_revenue,
    ROUND(SUM(profit), 2)             AS total_profit,
    COUNT(*)                          AS total_orders,
    ROUND(SUM(sales) / COUNT(*), 2)   AS avg_order_value
FROM orders;

-- 2. Revenue and profit by region, ranked highest first
SELECT
    region,
    ROUND(SUM(sales), 2)  AS revenue,
    ROUND(SUM(profit), 2) AS profit,
    COUNT(*)              AS orders
FROM orders
GROUP BY region
ORDER BY revenue DESC;

-- 3. Monthly revenue trend
SELECT
    strftime('%Y-%m', order_date) AS month,
    ROUND(SUM(sales), 2)          AS revenue
FROM orders
GROUP BY month
ORDER BY month;

-- 4. Top 5 products by revenue
SELECT
    product,
    category,
    ROUND(SUM(sales), 2) AS revenue,
    SUM(quantity)         AS units_sold
FROM orders
GROUP BY product, category
ORDER BY revenue DESC
LIMIT 5;

-- 5. Revenue share by category
SELECT
    category,
    ROUND(SUM(sales), 2)                                           AS revenue,
    ROUND(100.0 * SUM(sales) / (SELECT SUM(sales) FROM orders), 1) AS pct_of_total
FROM orders
GROUP BY category
ORDER BY revenue DESC;

-- 6. Average order value by customer segment
SELECT
    customer_segment,
    COUNT(*)                        AS orders,
    ROUND(AVG(sales), 2)            AS avg_order_value
FROM orders
GROUP BY customer_segment
ORDER BY avg_order_value DESC;

-- 7. Month-over-month revenue growth (window function: LAG)
SELECT
    month,
    revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month),
        1
    ) AS mom_growth_pct
FROM (
    SELECT strftime('%Y-%m', order_date) AS month, SUM(sales) AS revenue
    FROM orders
    GROUP BY month
);

-- 8. Running (cumulative) revenue total by month (window function: SUM OVER)
SELECT
    month,
    revenue,
    ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS cumulative_revenue
FROM (
    SELECT strftime('%Y-%m', order_date) AS month, SUM(sales) AS revenue
    FROM orders
    GROUP BY month
);
