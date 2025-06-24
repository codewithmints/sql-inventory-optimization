-- =============================================
-- Filename: kpi_low_inventory_days.sql
-- Purpose: Count number of days inventory fell below reorder point
-- =============================================

WITH daily_demand AS (
    SELECT 
        store_id,
        product_id,
        date,
        SUM(units_sold) AS daily_units_sold
    FROM sales
    GROUP BY store_id, product_id, date
),

average_demand AS (
    SELECT 
        store_id,
        product_id,
        ROUND(AVG(daily_units_sold)) AS avg_daily_demand
    FROM daily_demand
    GROUP BY store_id, product_id
),

reorder_points AS (
    SELECT 
        store_id,
        product_id,
        (avg_daily_demand * 3) AS reorder_point  -- 3-day lead time
    FROM average_demand
),

low_inventory_days AS (
    SELECT 
        s.store_id,
        s.product_id,
        s.date,
        s.inventory_level,
        r.reorder_point
    FROM sales s
    JOIN reorder_points r
      ON s.store_id = r.store_id AND s.product_id = r.product_id
    WHERE s.inventory_level < r.reorder_point
)

SELECT 
    store_id,
    product_id,
    COUNT(*) AS low_inventory_days
FROM low_inventory_days
GROUP BY store_id, product_id
ORDER BY low_inventory_days DESC;
