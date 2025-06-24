-- =============================================
-- Filename: recommend_stock_adjustments.sql
-- Purpose: Recommend inventory adjustments based on
--          inventory turnover, low inventory days,
--          and average inventory vs reorder point
-- =============================================

-- Step 1: Daily demand from full dataset
WITH daily_demand AS (
    SELECT 
        store_id,
        product_id,
        date,
        SUM(units_sold) AS daily_units_sold
    FROM sales
    GROUP BY store_id, product_id, date
),

-- Step 2: Average daily demand over full period
average_demand AS (
    SELECT 
        store_id,
        product_id,
        ROUND(AVG(daily_units_sold), 2) AS avg_daily_demand
    FROM daily_demand
    GROUP BY store_id, product_id
),

-- Step 3: Reorder point = avg_daily_demand × 3 (lead time), capped at 120
reorder_points AS (
    SELECT 
        store_id,
        product_id,
        ROUND(LEAST(avg_daily_demand * 3, 120), 2) AS reorder_point
    FROM average_demand
),

-- Step 4: Low inventory days where inventory < reorder_point
low_inventory_days AS (
    SELECT 
        s.store_id,
        s.product_id,
        COUNT(*) AS low_inventory_days
    FROM sales s
    JOIN reorder_points r
      ON s.store_id = r.store_id AND s.product_id = r.product_id
    WHERE s.inventory_level < r.reorder_point
    GROUP BY s.store_id, s.product_id
),

-- Step 5: Average inventory and turnover per product-store
inventory_metrics AS (
    SELECT 
        store_id,
        product_id,
        ROUND(AVG(inventory_level), 2) AS avg_inventory,
        ROUND(SUM(units_sold)::NUMERIC / NULLIF(AVG(inventory_level), 0), 2) AS turnover_ratio
    FROM sales
    GROUP BY store_id, product_id
)

-- Step 6: Final Recommendation Table
SELECT 
    i.store_id,
    i.product_id,
    i.avg_inventory,
    i.turnover_ratio,
    l.low_inventory_days,
    CASE
        WHEN l.low_inventory_days >= 200 THEN 'Increase'
        WHEN i.turnover_ratio < 1 THEN 'Reduce'
        ELSE 'Balanced'
    END AS stock_recommendation
FROM inventory_metrics i
JOIN low_inventory_days l
  ON i.store_id = l.store_id AND i.product_id = l.product_id
ORDER BY stock_recommendation DESC, l.low_inventory_days DESC;
