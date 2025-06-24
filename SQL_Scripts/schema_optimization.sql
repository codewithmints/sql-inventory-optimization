-- =============================================
-- Filename: schema_optimization.sql
-- Purpose: Add indexes to improve performance
-- =============================================

-- Index for faster filtering and grouping by store/product
CREATE INDEX IF NOT EXISTS idx_sales_store_product
ON sales(store_id, product_id);

-- Index for date filtering and window functions
CREATE INDEX IF NOT EXISTS idx_sales_date
ON sales(date);

-- Index for inventory joins and filtering
CREATE INDEX IF NOT EXISTS idx_inventory_product_store
ON inventory(product_id, store_id);

-- Index to speed up joins with products
CREATE INDEX IF NOT EXISTS idx_sales_product
ON sales(product_id);

-- Index to speed up external factors join
CREATE INDEX IF NOT EXISTS idx_external_store
ON external_factors(store_id);
