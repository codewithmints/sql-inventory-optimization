-- =============================================
-- Filename: discount_vs_sales_productwise.sql
-- Purpose: Analyze how different discount levels
--          affect average units sold for each product
-- =============================================

SELECT 
    product_id,                       -- Product identifier
    discount,                         -- Discount % applied
    ROUND(AVG(units_sold), 2) AS avg_units_sold  -- Average sales at this discount level
FROM sales
GROUP BY product_id, discount
ORDER BY product_id, discount;
