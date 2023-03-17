
QUERY 1
SELECT a.ArtistId, a.name, COUNT(g.name) As Songs
FROM Genre g
JOIN Track t
ON g.GenreId = t.GenreId
JOIN Album b
ON t.AlbumId = b.AlbumId
JOIN Artist a
ON b.ArtistId = a.ArtistId
WHERE g.name = 'Blues'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 3;

QUERY 2


SELECT a.ArtistId, a.name, COUNT(g.name) As Latin_Songs
FROM Genre g
JOIN Track t
ON g.GenreId = t.GenreId
JOIN Album b
ON t.AlbumId = b.AlbumId
JOIN Artist a
ON b.ArtistId = a.ArtistId
WHERE g.name = 'Latin'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 3


QUERY 3


SELECT a.name, COUNT(*) AS Total_Album
FROM Album b
JOIN Artist a
ON a.ArtistId = b.ArtistId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;


QUERY 4
SELECT i.BillingCountry, g.name, COUNT(*) Total_songs
FROM Genre g
JOIN Track t
ON g.GenreId = t.GenreId
JOIN Invoiceline l
ON t.TrackId = l.TrackId
JOIN Invoice i
ON l.InvoiceId = i.InvoiceId
GROUP BY 2
ORDER BY 3 DESC
LIMIT 5;