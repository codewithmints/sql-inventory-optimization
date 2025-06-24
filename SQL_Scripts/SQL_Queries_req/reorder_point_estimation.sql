-- =============================================
-- Filename: reorder_point_estimation.sql
-- Purpose: Calculate reorder point (ROP) using
--          full-period average demand × 3-day lead time
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
        ROUND(AVG(daily_units_sold), 2) AS avg_daily_demand
    FROM daily_demand
    GROUP BY store_id, product_id
)

SELECT 
    store_id,
    product_id,
    avg_daily_demand,
    ROUND(LEAST(avg_daily_demand * 3, 120), 2) AS reorder_point  -- Cap ROP at 120 units
FROM average_demand
ORDER BY store_id, product_id;
