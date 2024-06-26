SELECT * FROM album;

--- 1. Who is the senior most employee based on job title?
SELECT * FROM employee
ORDER BY levels desc 
limit 1;

---2. Which countries have the most Invoices? 
SELECT billing_country, count(invoice_id) as Most_invoices 
FROM invoice
GROUP BY billing_country
ORDER BY 2 DESC;

---3. What are top 3 values of total invoice?
SELECT distinct(total) as total_invoice
FROM invoice
ORDER BY 1 DESC
LIMIT 3;

--- 4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals
SELECT billing_city, SUM(total) as invoice_totals
FROM invoice 
GROUP BY billing_city
ORDER BY invoice_totals  DESC;

--- 5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money
SELECT c.customer_id, c.first_name, c.last_name,sum(i.total) as total
from customer as c
INNER JOIN invoice as i on c.customer_id = i.customer_id
GROUP BY 1
ORDER BY 4 DESC
LIMIT 1;

---6. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A
SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
       SELECT track_id FROM track
       JOIN genre on track.genre_id = genre.genre_id
       WHERE genre.name LIKE 'Rock'
)
order by email;

----7.Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands

select * from artist;
select * from track;
select * from album;

SELECT artist.artist_id, artist.name, count(artist.artist_id) as Number_of_songs
FROM track
join album on track.album_id = album.album_id
join artist on artist.artist_id = album.artist_id 
JOIN genre on track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY 1,2
order by 3 desc
limit 10;


--- 8.Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first
SELECT name,milliseconds
FROM track
where milliseconds > (
	SELECT avg(milliseconds) as avg_track_length
	from track
)
order by Milliseconds DESC;
 
---9.  We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

--- 10.   Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1



