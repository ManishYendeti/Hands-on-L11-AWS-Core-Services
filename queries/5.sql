WITH monthly_summary AS (
    SELECT 
        date_manish('month', date_parse("Date", '%m-%d-%y')) AS month,
        SUM(CAST(Amount AS double)) AS total_sales,
        SUM(CAST(Amount AS double)) AS total_profit
    FROM "handsonoutputdb"."raw"
    GROUP BY 1
)
SELECT 
    month,
    total_sales,
    total_profit,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month)) / 
        NULLIF(LAG(total_sales) OVER (ORDER BY month), 0) * 100, 2
    ) AS sales_growth_pct,
    ROUND(
        (total_profit - LAG(total_profit) OVER (ORDER BY month)) / 
        NULLIF(LAG(total_profit) OVER (ORDER BY month), 0) * 100, 2
    ) AS profit_growth_pct
FROM monthly_summary
ORDER BY month
LIMIT 10;