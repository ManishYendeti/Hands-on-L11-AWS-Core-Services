# Hands-on L11: AWS Core Services

This project shows how different AWS services work together to store data, organize it, and perform analysis. Using an E-Commerce sales dataset, the data is uploaded to S3, cataloged through AWS Glue, and queried in Athena to find useful business insights.

---

## 📌 Dataset Information
Dataset: E-Commerce Sales Data  
Source: Kaggle  
Link: https://www.kaggle.com/datasets/thedevastator/unlock-profits-with-e-commerce-sales-data  

The dataset was uploaded to an Amazon S3 bucket. A Glue crawler was then used to detect its schema and create a table in the AWS Data Catalog.

---

## 🚀 AWS Workflow

| Step | Service | Task |
|------|---------|------|
| 1 | Amazon S3 | Created buckets and uploaded the input dataset |
| 2 | IAM | Created a role with permissions for Glue and S3 access |
| 3 | AWS Glue Crawler | Generated table metadata from the raw data |
| 4 | CloudWatch | Checked logs to validate crawler execution |
| 5 | Amazon Athena | Executed SQL queries to analyze the structured data |

---
### 1.Cloudwatch
![Capture -2 1](https://github.com/user-attachments/assets/7294f62d-d97e-4a9e-8d22-980f7ba9fc89)


### 2. IAM Role
![Capture-2 2](https://github.com/user-attachments/assets/47271a29-c6f0-492b-a456-41f8e994f7be)


### 3. Creating S3 Buckets
![Capture-2 3](https://github.com/user-attachments/assets/b07f27c8-e57b-446e-9535-b42409f56c22)




## SQL Queries Executed in Athena

### Query - 1
<pre> ```SELECT 
    date_parse("Date", '%m-%d-%y') AS order_date,
    SUM(CAST(Amount AS double)) OVER (
        ORDER BY date_parse("Date", '%m-%d-%y')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM "handsonoutputdb"."raw"
WHERE year(date_parse("Date", '%m-%d-%y')) = 2022
ORDER BY order_date
LIMIT 10; ``` </pre>
### Output
<img width="600" height="487" alt="image" src="https://github.com/user-attachments/assets/b529c072-36a9-445d-a8b1-1b4b0cf19936" />

### Query - 2
<pre> ```SELECT 
    "ship-state" AS state,
    SUM(CAST(Amount AS double) * -1) AS total_negative_profit
FROM "handsonoutputdb"."raw"
WHERE Status = 'Cancelled'
GROUP BY "ship-state"
ORDER BY total_negative_profit ASC
LIMIT 10; ``` </pre>
### Output
<img width="600" height="491" alt="image" src="https://github.com/user-attachments/assets/3e486e6a-3324-4082-b357-5d909306f6cb" />

### Query - 3
<pre> ```SELECT 
    Category AS sub_category,
    ROUND(SUM(CAST(Amount AS double)) / NULLIF(SUM(CAST(Qty AS double)), 0), 2) AS avg_revenue_per_item,
    COUNT(DISTINCT "Order ID") AS total_orders
FROM "handsonoutputdb"."raw"
GROUP BY Category
ORDER BY avg_revenue_per_item DESC
LIMIT 10; ``` </pre>
### Output
<img width="600" height="486" alt="image" src="https://github.com/user-attachments/assets/c324229f-e975-4a86-9a5e-f00a28b7cccf" />

### Query - 4
<pre> ```SELECT Category,
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
LIMIT 10; ``` </pre>
### Output
<img width="600" height="485" alt="image" src="https://github.com/user-attachments/assets/6c17bda0-83bd-4947-8f46-596c0cedef41" />

### Query - 5
<pre> ```WITH monthly_summary AS (
    SELECT 
        date_trunc('month', date_parse("Date", '%m-%d-%y')) AS month,
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
LIMIT 10; ``` </pre>
### Output
<img width="600" height="490" alt="image" src="https://github.com/user-attachments/assets/f468f8f2-d472-4f8b-ba14-82613431e571" />
