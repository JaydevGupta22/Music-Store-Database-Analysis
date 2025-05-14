USE music_store_analysis;

# Some Other Important Questions

# 1) Get the name of each track along with its media type.
SELECT 
      t.name AS track_name,
	  m.name AS media_type
FROM 
      track t 
JOIN media_type m ON t.media_type_id = m.media_type_id; 

# 2) List all the albums and their corresponding artist names.
SELECT 
     a.title AS title, 
     aa.name AS artist_name 
FROM album2 a 
JOIN artist aa USING (artist_id);

# 3) List all tracks along with the playlist(s) they belong to.
SELECT 
     t.name AS track_name, 
     p.name AS playlist_name
FROM 
     track t 
JOIN playlist_track pt USING (track_id) 
JOIN playlist p USING (playlist_id);

# 4) Get all invoice details including track name and quantity ordered.
SELECT 
    i.invoice_id,
    i.customer_id,
    i.invoice_date,
    i.billing_address,
    i.billing_city,
    i.billing_state,
    i.billing_country,
    i.total,
    t.name AS track_name,
    il.quantity
FROM invoice i 
JOIN invoice_line il
USING (invoice_id)
JOIN track t
USING (track_id);


# 5) Find the total number of invoices generated per country.
SELECT 
    billing_country,
    COUNT(*) AS total_count
FROM 
    invoice
GROUP BY 
    billing_country
ORDER BY 
    total_count DESC;
    
# 6) Get the total sales per customer, ordered by highest sales. 
SELECT 
     i.customer_id,
     CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
     SUM(i.total) AS total_sales
FROM 
     customer c
LEFT JOIN 
     invoice i USING (customer_id)
GROUP BY 
     c.customer_id, customer_name
ORDER BY total_sales DESC;

# 7) Find the top 5 most purchased tracks by quantity. 
SELECT 
     t.name AS track_name, 
     SUM(il.quantity) AS total_quantity
FROM track t 
LEFT JOIN  
     invoice_line il USING (track_id) 
GROUP BY 
	t.track_id, t.name
ORDER BY 
    total_quantity DESC 
LIMIT 5;  

# 8) Find artists with more than 10 albums.
SELECT 
    a.name AS artist_name,
    COUNT(aa.album_id) AS total_albums
FROM 
    artist a 
JOIN 
    album2 aa USING (artist_id) 
GROUP BY 
    a.artist_id, a.name
HAVING 
    COUNT(aa.album_id) > 10
ORDER BY 
    total_albums DESC;
    
# 9) List each genre and the total number of tracks and their total duration (in seconds).
SELECT 
     g.name AS genre,
     COUNT(t.track_id) AS total_track,
     ROUND(SUM(t.milliseconds) /1000, 2) AS total_duration
FROM track t
LEFT JOIN 
	genre g USING (genre_id) 
GROUP BY g.genre_id ,g.name
ORDER BY total_duration DESC;	