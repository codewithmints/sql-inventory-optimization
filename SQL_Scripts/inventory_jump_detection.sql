-- Detect large overnight inventory jumps (possible delivery/lag cases)

WITH inventory_change AS (
  SELECT 
      store_id,
      product_id,
      date,
      inventory_level,
      LAG(inventory_level) OVER (PARTITION BY store_id, product_id ORDER BY date) AS prev_inventory
  FROM sales
)

SELECT 
    store_id,
    product_id,
    date,
    prev_inventory,
    inventory_level,
    (inventory_level - prev_inventory) AS inventory_diff
FROM inventory_change
WHERE (inventory_level - prev_inventory) > 100
ORDER BY inventory_diff DESC;
