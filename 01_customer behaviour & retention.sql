USE music_store_analysis;

-- 1) Who are the top 5 highest-spending customers, and what are their countries?
SELECT
    c.customer_id AS customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.country AS country,
    SUM(i.total) AS total_money_spend
FROM customer c 
LEFT JOIN 
     invoice i USING (customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name, c.country
ORDER BY total_money_spend DESC LIMIT 5;

# 2) What is the average revenue per customer by country?
SELECT 
    c.country,
    ROUND(AVG(customer_total), 2) AS avg_revenue_per_customer
FROM (
    SELECT 
        customer_id,
        SUM(total) AS customer_total
    FROM invoice
    GROUP BY customer_id
) AS customer_invoice_totals
JOIN customer c ON c.customer_id = customer_invoice_totals.customer_id
GROUP BY c.country
ORDER BY avg_revenue_per_customer DESC;

# 3) Which customers made purchases in multiple invoices?
SELECT 
    c.customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(i.invoice_id) AS invoice_count
FROM customer c
JOIN invoice i 
USING(customer_id) 
GROUP BY c.customer_id, customer_name
HAVING COUNT(i.invoice_id) > 1
ORDER BY invoice_count DESC;

# 4) What is the total revenue generated by new vs old customers?
SELECT 
    customer_type,
    ROUND(SUM(i.total), 2) AS total_revenue
FROM (
    SELECT 
        c.customer_id,
        CASE 
            WHEN MIN(i.invoice_date) >= '2018-01-01' THEN 'New'
            ELSE 'Old'
        END AS customer_type
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
) AS categorized_customers
JOIN invoice i ON categorized_customers.customer_id = i.customer_id
GROUP BY customer_type;


