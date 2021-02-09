/* 1. Find the names of all reviewers who rated Gone with the Wind. */
SELECT name
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
GROUP BY name
HAVING title = "Gone with the Wind";

/* 2. For any rating where the reviewer is the same as the director of the movie, 
return the reviewer name, movie title, and number of stars. */
SELECT name, title, stars
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
WHERE name = director;

/* 3. Return all reviewer names and movie names together in a single list, alphabetized. 
(Sorting by the first name of the reviewer and first word in the title is fine; 
no need for special processing on last names or removing "The".) */
SELECT name
FROM Reviewer
UNION
SELECT title
FROM Movie
ORDER BY name, title;

/* 4. Find the titles of all movies not reviewed by Chris Jackson. */
SELECT title
FROM Movie
WHERE title NOT IN 
	(SELECT title 
	FROM Rating
	JOIN Movie USING(mID)
	JOIN Reviewer USING(rID)
	WHERE name = "Chris Jackson");

/* 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
For each pair, return the names in the pair in alphabetical order. */
SELECT DISTINCT re1.name, re2.name
FROM Reviewer re1
JOIN Reviewer re2
JOIN Rating r1
JOIN Rating r2
WHERE re1.rID = r1.rID AND re2.rID = r2.rID
AND re1.name < re2.name AND r1.mID = r2.mID
ORDER BY re1.name;

/* 6. For each rating that is the lowest (fewest stars) currently in the database, 
return the reviewer name, movie title, and number of stars. */
SELECT name, title, stars
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
WHERE stars = (SELECT MIN(stars) FROM Rating);

/* 7. List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */
SELECT title, AVG(stars) AS avg
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
GROUP BY title
ORDER BY avg DESC, title;

/* 8. Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
SELECT name
FROM Rating
JOIN Movie USING(mID)
JOIN Reviewer USING(rID)
GROUP BY name
HAVING COUNT(rID) >= 3;

/* 9. Some directors directed more than one movie. 
For all such directors, return the titles of all movies directed by them, along with the director name. 
Sort by director name, then movie title. 
(As an extra challenge, try writing the query both with and without COUNT.) */
SELECT title, director 
FROM Movie
WHERE director IN (
	SELECT director
	FROM Movie
	GROUP BY director
	HAVING COUNT(director) > 1)
ORDER BY director, title;

/* 10. Find the movie(s) with the highest average rating. 
Return the movie title(s) and average rating. 
(Hint: This query is more difficult to write in SQLite than other systems; 
you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, AVG(stars) AS average
FROM Movie
JOIN Rating USING(mID)
JOIN Reviewer USING(rID)
GROUP BY title, mID
HAVING AVG(stars) = (SELECT MAX(avg_stars) FROM (
SELECT title, AVG(stars) AS avg_stars
FROM Movie
INNER JOIN Rating USING (mID)
GROUP BY Movie.mID, title
)  I
);

/* 11. Find the movie(s) with the lowest average rating. 
Return the movie title(s) and average rating. 
(Hint: This query may be more difficult to write in SQLite than other systems; 
you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, AVG(stars) AS average
FROM Movie
JOIN Rating USING(mID)
JOIN Reviewer USING(rID)
GROUP BY title, mID
HAVING AVG(stars) = (SELECT MIN(avg_stars) FROM (
SELECT title, AVG(stars) AS avg_stars
FROM Movie
INNER JOIN Rating ON Rating.mID = Movie.mID
GROUP BY Movie.mID, title
)  I
);

/* 12. For each director, return the director's name 
together with the title(s) of the movie(s) they directed 
that received the highest rating among all of their movies, and the value of that rating. 
Ignore movies whose director is NULL. */
SELECT director, title, MAX(stars) as maximum
FROM Movie 
JOIN Rating USING (mID) 
JOIN Reviewer USING (rID)
GROUP BY director
HAVING director IS NOT NULL;