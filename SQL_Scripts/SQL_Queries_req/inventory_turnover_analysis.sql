-- =============================================
-- Filename: inventory_turnover_analysis.sql
-- Purpose: Measure inventory efficiency using
--          Inventory Turnover Ratio per product per store
-- =============================================

-- Formula:
-- Inventory Turnover Ratio = (Total Units Sold ÷ Average Inventory) ÷ 730

SELECT 
    store_id,
    product_id,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(inventory_level), 2) AS avg_inventory,
    ROUND((SUM(units_sold) / NULLIF(AVG(inventory_level), 0)) / 730.0, 2) AS turnover_ratio
FROM sales
GROUP BY store_id, product_id;

