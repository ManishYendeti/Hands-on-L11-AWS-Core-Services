SELECT 
    Category AS sub_category,
    ROUND(SUM(CAST(Amount AS double)) / NULLIF(SUM(CAST(Qty AS double)), 0), 2) AS avg_revenue_per_item,
    COUNT(DISTINCT "Order ID") AS total_orders
FROM "handsonoutputdb"."raw"
GROUP BY Category
ORDER BY avg_revenue_per_item DESC
LIMIT 10;