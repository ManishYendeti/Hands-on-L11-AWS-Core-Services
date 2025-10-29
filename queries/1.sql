SELECT 	
    date_parse("Date"	 '%m-%d-%y') AS order_date
    SUM(CAST(Amount AS double)) OVER (	
        ORDER BY date_parse("Date"	 '%m-%d-%y')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW	
    ) AS cumulative_sales	
FROM "handsonoutputdb"."raw"	
WHERE year(date_parse("Date"	 '%m-%d-%y')) = 2022
ORDER BY order_date	
LIMIT 10;	
