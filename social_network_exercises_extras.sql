/* 1. For every situation where student A likes student B, but student B likes a different student C, 
return the names and grades of A, B, and C. */
SELECT DISTINCT HS1.name, HS1.grade, HS2.name, HS2.grade, HS3.name, HS3.grade
FROM Highschooler HS1, Highschooler HS2, Highschooler HS3
JOIN Likes ON HS1.ID = Likes.ID1
WHERE HS1.ID = Likes.ID1 AND HS2.ID=Likes.ID2
AND HS2.ID IN (SELECT ID2 FROM Likes WHERE ID1 = HS1.ID)
AND HS1.ID NOT IN (SELECT ID2 FROM Likes WHERE ID1 = HS2.ID)
AND HS3.ID IN (SELECT ID2 FROM Likes WHERE ID1 = HS2.ID);

/* 2. Find those students for whom all of their friends are in different grades from themselves. 
Return the students' names and grades. */
SELECT HS1.name, HS1.grade 
FROM Highschooler HS1
WHERE ID NOT IN (
	SELECT ID1
	FROM Friend, Highschooler HS2
	WHERE HS1.ID = Friend.ID1 AND HS2.ID = Friend.ID2 
	AND HS1.grade =HS2.grade)
ORDER BY HS1.grade, HS1.name;

/* 3. What is the average number of friends per student? (Your result should be just one number.) */
SELECT AVG(G.friends) FROM
(SELECT name, COUNT(ID2) AS friends
FROM Highschooler
JOIN Friend ON ID = ID1
GROUP BY ID1) AS G;

/* 4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
Do not count Cassandra, even though technically she is a friend of a friend. */
SELECT COUNT(*)
FROM Friend
WHERE ID1 IN (
	SELECT ID2 
	FROM Friend
	WHERE ID1 IN (
		SELECT ID
		FROM Highschooler
		WHERE name = "Cassandra"
	)
);

/* 5. Find the name and grade of the student(s) with the greatest number of friends. */
SELECT name, grade
FROM Highschooler
JOIN Friend
ON ID1 = ID
GROUP BY ID1
HAVING COUNT(*) = 
(SELECT MAX(count) 
FROM (
	SELECT COUNT(*) AS count
	FROM Friend
	GROUP BY ID1));