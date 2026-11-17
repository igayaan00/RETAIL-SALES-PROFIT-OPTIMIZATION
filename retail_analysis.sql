-- 2. Check karna ki kahin koi NULL (khali) value toh nahi hai
SELECT 
    COUNT(*) AS total_rows,
    COUNT(sales) AS valid_sales,
    COUNT(profit) AS valid_profit
FROM superstore;
-- Query 1: Overall Business KPIs
SELECT 
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct,
    SUM(quantity) AS total_units_sold
FROM superstore;

-- Query 2: Profit Killers (Kaunsi Sub-Category nuksan mein ja rahi hai?)
SELECT 
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
FROM superstore
GROUP BY category, sub_category
ORDER BY total_profit ASC;

-- Query 3: ABC Inventory / Product Classification (Top Revenue Products)
WITH product_sales AS (
    SELECT 
        product_name,
        SUM(sales) AS revenue,
        SUM(SUM(sales)) OVER (ORDER BY SUM(sales) DESC) / SUM(SUM(sales)) OVER () AS cumulative_pct
    FROM superstore
    GROUP BY product_name
)
SELECT 
    product_name,
    ROUND(revenue, 2) AS revenue,
    CASE 
        WHEN cumulative_pct <= 0.70 THEN 'Class A (High Value)'
        WHEN cumulative_pct <= 0.90 THEN 'Class B (Medium Value)'
        ELSE 'Class C (Low Value)'
    END AS inventory_class
FROM product_sales
LIMIT 20;