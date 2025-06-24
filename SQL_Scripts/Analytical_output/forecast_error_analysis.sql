-- =============================================
-- Filename: forecast_error_analysis.sql
-- Purpose: Measure forecast accuracy by calculating
--          average absolute error per product-store pair
-- =============================================

SELECT 
    store_id,
    product_id,
    ROUND(AVG(ABS(units_sold - demand_forecast)), 2) AS avg_forecast_error
FROM sales
WHERE demand_forecast IS NOT NULL
GROUP BY store_id, product_id
ORDER BY avg_forecast_error DESC;
