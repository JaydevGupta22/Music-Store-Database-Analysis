USE music_store_analysis;

# SALES & REVENUE 
# 1) How has revenue changed over time (monthly/quarterly/yearly)?

# MONTHLY REVENUE 
SELECT 
      YEAR(i.invoice_date) AS year,
      MONTH(i.invoice_date) AS month,
      SUM(il.unit_price * il.quantity) AS monthly_revenue 
FROM invoice i 
JOIN 
     invoice_line il USING(invoice_id) 
GROUP BY 
     YEAR(i.invoice_date),
     MONTH(i.invoice_date) 
ORDER BY YEAR(i.invoice_date) DESC, MONTH(i.invoice_date) DESC;

# QUARTERLY REVENUE 
SELECT 
    YEAR(i.invoice_date) AS year,
    CASE
        WHEN MONTH(i.invoice_date) IN (1, 2, 3) THEN 'Q1'
        WHEN MONTH(i.invoice_date) IN (4, 5, 6) THEN 'Q2'
        WHEN MONTH(i.invoice_date) IN (7, 8, 9) THEN 'Q3'
        WHEN MONTH(i.invoice_date) IN (10, 11, 12) THEN 'Q4'
    END AS quarter,
    SUM(il.unit_price * il.quantity) AS quarterly_revenue
FROM invoice i
JOIN invoice_line il USING(invoice_id)
GROUP BY
    YEAR(i.invoice_date),
    quarter
ORDER BY
    YEAR(i.invoice_date) DESC, quarter DESC;


# yearly revenue 
SELECT 
     YEAR(i.invoice_date) AS year,
     SUM(il.unit_price * il.quantity) AS yearly_revenue 
FROM 
     invoice i 
JOIN invoice_line il  USING(invoice_id)
GROUP BY
	 YEAR(i.invoice_date)
ORDER BY YEAR(i.invoice_date) DESC;


# 2)  Which albums or artists generate the most revenue?	

# in terms of artist 
SELECT a.name AS artist_name,
      SUM(il.quantity * il.unit_price) AS revenue_generated
FROM artist a 
JOIN album2 aa USING(artist_id) 
JOIN track t USING(album_id)
JOIN invoice_line il USING(track_id) 
GROUP BY artist_name
ORDER BY revenue_generated DESC ;

# in terms of album 
SELECT 
     a.title AS album_title,
     SUM(il.unit_price * il.quantity) AS revenue_generated
FROM album2 a 
JOIN track t USING(album_id) 
JOIN invoice_line il USING(track_id) 
GROUP BY album_title
ORDER BY revenue_generated DESC;


# 3) Which billing countries generate the most revenue and have the most customers?
# STEP 1: FIND THE BILLING COUNTRIES WHO GENERATES MOST REVENUE 
SELECT
     i.billing_country AS country,
     SUM(il.quantity * il.unit_price) AS revenue 
FROM invoice i 
JOIN invoice_line il USING(invoice_id) 
GROUP BY country 
ORDER BY revenue DESC LIMIT 1; 

# step 2 : find the country with most customers 
SELECT country AS country,
      COUNT(*) AS total_customer
FROM customer 
GROUP BY country 
ORDER BY total_customer DESC LIMIT 1;


# step 3: merge both the queries 
SELECT 
	c.country AS country,
    COUNT(DISTINCT c.customer_id) AS total_customer,
    SUM(il.quantity * il.unit_price) AS revenue 
FROM customer c
JOIN invoice i USING(customer_id) 
JOIN invoice_line il USING(invoice_id) 
GROUP BY country 
ORDER BY total_customer DESC, revenue DESC LIMIT 1;

