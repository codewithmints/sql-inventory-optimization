-- =============================================
-- Filename: kpi_stockouts.sql
-- Purpose: Count number of days inventory level was zero
-- =============================================

SELECT     
    store_id,
    product_id,
    COUNT(*) AS stockout_days
FROM sales
WHERE inventory_level = 0
GROUP BY store_id, product_id
ORDER BY stockout_days DESC;
