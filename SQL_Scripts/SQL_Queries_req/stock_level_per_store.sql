-- =============================================
-- Filename: stock_level_per_store.sql
-- Purpose: Stock Level Calculations across all stores and warehouse
--          View current inventory levels for each product at each store.
-- Description:
--     - Retrieves the most recent inventory level
--       for each store and each product.
--     - Joins with the products table to include product category.
--     - Useful for low stock alerts, store-level dashboards,
--       and executive inventory reporting.
-- =============================================

-- Using PostgreSQL DISTINCT ON to get the latest entry
-- for each (store_id, product_id) pair

SELECT DISTINCT ON (s.store_id, s.product_id)
    s.store_id,                    -- Store or warehouse ID
    s.product_id,                  -- Product identifier
    p.category,                    -- Category (e.g., Electronics, Medicine)
    s.inventory_level,             -- Current stock level
    s.date                         -- Date of this inventory snapshot
FROM sales s
JOIN products p
    ON s.product_id = p.product_id -- Join to get category info
ORDER BY 
    s.store_id,                    -- Grouping level 1
    s.product_id,                  -- Grouping level 2
    s.date DESC;                   -- Pick the latest record per group
