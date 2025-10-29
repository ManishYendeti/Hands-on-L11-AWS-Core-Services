SELECT 
    "ship-state" AS state,
    SUM(CAST(Amount AS double) * -1) AS total_negative_profit
FROM "handsonoutputdb"."raw"
WHERE Status = 'Cancelled'
GROUP BY "ship-state"
ORDER BY total_negative_profit ASC
LIMIT 10;