/* 1. Find the titles of all movies directed by Steven Spielberg. */
SELECT title 
FROM Movie 
WHERE director = "Steven Spielberg";

/* 2. Find all years that have a movie that received a rating of 4 or 5, 
and sort them in increasing order. */
SELECT year 
FROM Movie, Rating 
WHERE Movie.mID = Rating.mID and Rating.stars >= 4
GROUP BY year;

/* 3. Find the titles of all movies that have no ratings. */
SELECT DISTINCT title 
FROM Movie, Rating 
WHERE Movie.mID NOT IN (SELECT mID FROM Rating);

/* 4. Some reviewers didn't provide a date with their rating. 
Find the names of all reviewers who have ratings with a NULL value for the date. */
SELECT DISTINCT name 
FROM Rating, Reviewer
WHERE Reviewer.rID = Rating.rID 
AND Rating.ratingDate IS NULL;

/* 5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
SELECT Reviewer.name as name, Movie.title as title, Rating.stars as stars, Rating.ratingDate
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
ORDER BY name, title, stars;

/* 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
return the reviewer's name and the title of the movie. */
SELECT name, title
FROM Movie
JOIN Rating R1 USING(mID)
JOIN Rating R2 USING(rID, mID)
JOIN Reviewer USING(rID)
WHERE R1.ratingDate < R2.ratingDate AND R1.stars < R2.stars;

/* 7. For each movie that has at least one rating, find the highest number of stars that movie received. 
Return the movie title and number of stars. Sort by movie title. */
SELECT title, max(stars)
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
GROUP BY title
having COUNT(*) > 0;

/* 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
Sort by rating spread from highest to lowest, then by movie title. */
SELECT title, MAX(stars) - MIN(stars) as spread
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
GROUP BY title
ORDER BY spread DESC, title;

/* 9. Find the difference between the average rating of movies released before 1980 
and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, 
then the average of those averages for movies before 1980 and movies after. 
Don't just calculate the overall average rating before and after 1980.) */
SELECT AVG(Before1980.avg) - AVG(After1980.avg)
FROM (
  SELECT AVG(stars) AS avg
  FROM Movie
  INNER JOIN Rating USING(mID)
  WHERE year < 1980
  GROUP BY mID
) AS Before1980, (
  SELECT AVG(stars) AS avg
  FROM Movie
  INNER JOIN Rating USING(mID)
  WHERE year > 1980
  GROUP BY mID
) AS After1980;