-- LAB-1 :

CREATE DATABASE CSE_4A_237

SELECT * FROM ARTISTS
SELECT * FROM ALBUMS
SELECT * FROM SONGS

-- PART_A :

--1. Retrieve a unique genre of songs.
SELECT DISTINCT GENRE 
FROM SONGS

--2. Find top 2 albums released before 2010.
SELECT TOP 2 ALBUM_TITLE , RELEASE_YEAR
FROM ALBUMS
WHERE RELEASE_YEAR < 2010

--3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005)
INSERT INTO SONGS VALUES (1245 , 'Zaroor' , 2.55 , 'Feel Good' , 1005)

--4. Change the Genre of the song ‘Zaroor’ to ‘Happy’
UPDATE SONGS
SET GENRE = 'Happy'
WHERE SONG_TITLE = 'Zaroor'

--5. Delete an Artist ‘Ed Sheeran’
DELETE FROM ARTISTS 
WHERE ARTIST_NAME = 'Ed Sheeran'

--6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]


--7. Retrieve songs whose title starts with 'S'.
SELECT SONG_TITLE 
FROM SONGS
WHERE SONG_TITLE LIKE 'S%'

--8. Retrieve all songs whose title contains 'Everybody'.
SELECT SONG_TITLE
FROM SONGS
WHERE SONG_TITLE LIKE '%Everybody%'

--9. Display Artist Name in Uppercase.
SELECT UPPER(Artist_name)
FROM ARTISTS

--10. Find the Square Root of the Duration of a Song ‘Good Luck’
SELECT SQRT(DURATION) , SONG_TITLE
FROM SONGS
WHERE SONG_TITLE = 'Good Luck'

--11. Find Current Date.
SELECT GETDATE()

--12. Find the number of albums for each artist.
SELECT COUNT(*), ARTISTS.ARTIST_NAME
FROM ARTISTS
JOIN ALBUMS 
ON ARTISTS.ARTIST_ID = ALBUMS.ARTIST_ID
GROUP BY ARTISTS.ARTIST_NAME

--13. Retrieve the Album_id which has more than 5 songs in it.
SELECT COUNT(*) , ALBUM_ID
FROM SONGS
GROUP BY ALBUM_ID
HAVING COUNT(*) > 5

--14. Retrieve all songs from the album 'Album1'. (using Subquery)
SELECT SONG_TITLE 
FROM SONGS 
WHERE ALBUM_ID = 
				( SELECT ALBUM_ID
				  FROM ALBUMS
				  WHERE ALBUM_TITLE = 'Album1')

--15. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)
SELECT ALBUM_TITLE 
FROM ALBUMS
WHERE ARTIST_ID = 
				( SELECT ARTIST_ID
				  FROM ARTISTS
				  WHERE ARTIST_NAME = 'Aparshakti Khurana' ) 

--16. Retrieve all the song titles with its album title.
SELECT SONGS.SONG_TITLE , ALBUMS.ALBUM_TITLE
FROM SONGS
JOIN ALBUMS
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID

--17. Find all the songs which are released in 2020.
SELECT SONGS.SONG_TITLE , ALBUMS.RELEASE_YEAR
FROM SONGS
JOIN ALBUMS
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
WHERE RELEASE_YEAR = 2020

--18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.
CREATE VIEW Fav_Songs AS
SELECT *
FROM SONGS
WHERE SONG_ID BETWEEN 101 AND 105

SELECT * FROM Fav_Songs

--19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.
UPDATE Fav_Songs
SET SONG_TITLE = 'Jannat'
WHERE SONG_ID = 101

--20. Find all artists who have released an album in 2020. 
SELECT ARTIST_NAME , RELEASE_YEAR
FROM ARTISTS
JOIN ALBUMS
ON ARTISTS.ARTIST_ID = ALBUMS.ARTIST_ID
WHERE RELEASE_YEAR = 2020

--21. Retrieve all songs by Shreya Ghoshal and order them by duration.
SELECT SONG_TITLE , DURATION
FROM SONGS
JOIN ALBUMS 
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
JOIN ARTISTS
ON ALBUMS.ARTIST_ID = ARTISTS.ARTIST_ID
WHERE ARTISTS.ARTIST_NAME = 'Shreya Ghoshal'
ORDER BY DURATION


-- PART_B :

--22. Retrieve all song titles by artists who have more than one album. 
SELECT SONGS.SONG_TITLE,ARTISTS.ARTIST_NAME
FROM SONGS
JOIN ALBUMS 
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
JOIN ARTISTS 
ON ALBUMS.ARTIST_ID = ARTISTS.ARTIST_ID
WHERE ARTISTS.ARTIST_ID IN 
						( SELECT ARTIST_ID
						  FROM ALBUMS
						  GROUP BY ARTIST_ID
						  HAVING COUNT(*) > 1 )
ORDER BY SONGS.SONG_TITLE

--23. Retrieve all albums along with the total number of songs. 
SELECT ALBUM_TITLE, COUNT(*) AS Total_Songs
FROM ALBUMS
JOIN SONGS 
ON ALBUMS.ALBUM_ID = SONGS.ALBUM_ID
GROUP BY ALBUM_TITLE

--24. Retrieve all songs and release year and sort them by release year. 
SELECT SONG_TITLE, RELEASE_YEAR
FROM SONGS
JOIN ALBUMS 
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
ORDER BY RELEASE_YEAR

--25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
SELECT GENRE, COUNT(*) AS Total_Songs
FROM SONGS
GROUP BY GENRE
HAVING COUNT(*) > 2--26. List all artists who have albums that contain more than 3 songs.SELECT ARTIST_NAME
FROM ARTISTS
JOIN ALBUMS 
ON ARTISTS.ARTIST_ID = ALBUMS.ARTIST_ID
GROUP BY ARTIST_NAME
HAVING COUNT(*) > 3


-- PART_C :

--27. Retrieve albums that have been released in the same year as 'Album4'.
SELECT ALBUM_TITLE
FROM ALBUMS
WHERE RELEASE_YEAR = 
				( SELECT RELEASE_YEAR
				  FROM ALBUMS
				  WHERE ALBUM_TITLE = 'Album4' )

--28. Find the longest song in each genre.
SELECT GENRE,SONG_TITLE,DURATION
FROM SONGS 
WHERE DURATION IN 
				( SELECT MAX(Duration) 
				  FROM SONGS 
				  GROUP BY GENRE )

--29. Retrieve the titles of songs released in albums that contain the word 'Album' in the title.
SELECT SONG_TITLE
FROM SONGS
JOIN ALBUMS 
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
WHERE ALBUMS.ALBUM_TITLE LIKE '%Album%'

--30. Retrieve the total duration of songs by each artist where total duration exceeds 15 minutes.
SELECT ARTIST_NAME, SUM(DURATION) AS Total_Duration
FROM SONGS
JOIN Albums 
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
JOIN Artists 
ON ALBUMS.ARTIST_ID = ARTISTS.ARTIST_ID
GROUP BY ARTIST_NAME
HAVING SUM(DURATION) > 15