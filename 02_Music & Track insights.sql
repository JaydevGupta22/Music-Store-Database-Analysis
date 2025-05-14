USE music_store_analysis;

# Music & Track insights 

# 1)  Which genres are most popular based on total purchases?
SELECT 
     g.name AS genre_name,
     COUNT(il.quantity) AS total_quantity
FROM genre g 
JOIN track t
USING (genre_id) 
JOIN invoice_line il 
USING (track_id) 
GROUP BY genre_name
ORDER BY  total_quantity 
DESC;

# 2) Which tracks are frequently added to playlists and also purchased?
# STEP 1 : CALCULATE HOW MANY TIMES EACH TRACK APPEARS IN THE PLAYLIST 
SELECT 
     track_id, 
     COUNT(*) AS playlist_count 
FROM 
     playlist_track 
GROUP BY 
     track_id 
ORDER BY 
     playlist_count DESC;  
     
# STEP 2: COUNT HOW MANY TIMES A TRACK HAS BEEN PURCHASED 
SELECT 
     track_id , 
     COUNT(*) as track_count 
FROM 
     invoice_line 
GROUP BY 
     track_id 
ORDER BY track_count DESC;

# STEP 3: MERGE BOTH THE QUERIES AND ALSO WE CAN ADD TRACK NAME FOR BETTER READABILITY 
SELECT 
     t.name AS track_name, 
     pt.playlist_count ,
     ip.purchase_count 
FROM 
    (SELECT track_id, COUNT(*) AS playlist_count
    FROM playlist_track 
    GROUP BY track_id) pt 
JOIN 
    (SELECT track_id, COUNT(*) as purchase_count
    FROM invoice_line 
    GROUP BY track_id) ip 
ON pt.track_id = ip.track_id 
JOIN track t  ON t.track_id = pt.track_id 
ORDER BY pt.playlist_count DESC, ip.purchase_count DESC;


# 3) What is the average duration of tracks per genre? (in minutes)  
SELECT 
    g.name AS genre_name,
    CONCAT(
        FLOOR(AVG(t.milliseconds) / 60000), ' min ',
        LPAD(FLOOR((AVG(t.milliseconds) % 60000) / 1000), 2, '0'), ' sec'
    ) AS avg_duration
FROM 
    genre g 
JOIN 
    track t USING (genre_id)
GROUP BY 
    genre_name
ORDER BY 
    AVG(t.milliseconds) DESC;

