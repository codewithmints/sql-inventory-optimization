-- =============================================
-- Filename: low_inventory_detection.sql
-- Purpose: Identify products at risk of stockout
--          using data-driven reorder point (ROP)
-- =============================================

-- STEP 1: Calculate daily demand (units sold) over the last 7 days
WITH daily_demand AS (
    SELECT 
        store_id,
        product_id,
        date,
        SUM(units_sold) AS daily_units_sold
    FROM sales
    WHERE date >= (SELECT MAX(date) - INTERVAL '7 days' FROM sales)
    GROUP BY store_id, product_id, date
),

-- STEP 2: Calculate average daily demand per store-product
-- Using a 7-day rolling window to capture recent sales trends
-- This assumes a fixed 3-day lead time for restocking, based on standard regional supply timelines

average_demand AS (
    SELECT 
        store_id,
        product_id,
        ROUND(AVG(daily_units_sold)) AS avg_daily_demand
    FROM daily_demand
    GROUP BY store_id, product_id
),

-- STEP 3: Estimate reorder point using lead time = 3 days
reorder_points AS (
    SELECT 
        store_id,
        product_id,
        avg_daily_demand,
        (avg_daily_demand * 3) AS reorder_point
    FROM average_demand
),

-- STEP 4: Get most recent inventory level per product per store
latest_inventory AS (
    SELECT DISTINCT ON (store_id, product_id)
        store_id,
        product_id,
        inventory_level,
        date
    FROM sales
    ORDER BY store_id, product_id, date DESC
)

-- STEP 5: Compare inventory to reorder point and filter low-stock cases
SELECT 
    l.store_id,
    l.product_id,
    l.inventory_level,
    r.reorder_point,
    r.avg_daily_demand,
    l.date
FROM latest_inventory l
JOIN reorder_points r
  ON l.store_id = r.store_id AND l.product_id = r.product_id
WHERE l.inventory_level < r.reorder_point
ORDER BY l.inventory_level ASC;
