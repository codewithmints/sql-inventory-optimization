-- =============================================
-- Filename: kpi_avg_inventory_level.sql
-- Purpose: Calculate average inventory level per store-product
-- =============================================

SELECT     
    store_id,
    product_id,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level
FROM sales
GROUP BY store_id, product_id
ORDER BY avg_inventory_level ASC;
