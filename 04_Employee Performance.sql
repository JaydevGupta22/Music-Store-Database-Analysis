USE music_store_analsis;

# Employee Performance 
# 1) How many customers is each employee (support rep) managing, and what is the total revenue from their customers?
SELECT 
     CONCAT(e.first_name, ' ', e.last_name) as employee_name,
     COUNT(DISTINCT c.customer_id) AS total_count,
     SUM(il.quantity * il.unit_price) AS total_revenue
FROM employee e 
JOIN customer c 
ON e.employee_id = c.support_rep_id 
JOIN invoice i USING (customer_id)
JOIN invoice_line il USING(invoice_id)
GROUP BY employee_name
ORDER BY total_count DESC, total_revenue DESC;

# 2) Which employee has the highest average customer spend?
# step 1: calculate the total spend per customer 
# step 2: then average per employee 
WITH customer_spending AS (
	SELECT 
         c.customer_id,
         c.support_rep_id,
         SUM(i.total) AS total_spent
	FROM customer c 
    JOIN invoice i USING(customer_id) 
    GROUP BY c.customer_id, c.support_rep_id
) 
SELECT 
	CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(cs.customer_id) AS total_customer,
    AVG(cs.total_spent) AS avg_customer_spend
FROM employee e 
JOIN customer_spending cs ON e.employee_id = cs.support_rep_id
GROUP BY employee_name 
ORDER BY avg_customer_spend DESC, total_customer DESC;

# 3)List all employees who report to another employee (with names of their managers).
SELECT 
     CONCAT (e1.first_name, ' ',e1.last_name) AS employee_name,
     CONCAT (e2.first_name, ' ',e2.last_name) AS manager_name
FROM employee e1
JOIN 
employee e2 
ON e1.reports_to = e2.employee_id; 

# 4) Get a list of customers and their support representatives’ names.
SELECT 
     CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
     CONCAT(e.first_name, ' ', e.last_name) AS support_representative_name
FROM  
     customer c
LEFT JOIN 
     employee e 
ON support_rep_id = employee_id;