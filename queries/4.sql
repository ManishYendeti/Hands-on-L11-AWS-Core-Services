SELECT Category,
	product_name,
	total_profit,
	rank_within_category
FROM (
		SELECT Category,
			SKU AS product_name,
			SUM(CAST(Amount AS double)) AS total_profit,
			RANK() OVER (
				PARTITION BY Category
				ORDER BY SUM(CAST(Amount AS double)) DESC
			) AS rank_within_category
		FROM "handsonoutputdb"."raw"
		GROUP BY Category,
			SKU
	) AS ranked_data
WHERE rank_within_category <= 3
ORDER BY Category,
	total_profit DESC
LIMIT 10;