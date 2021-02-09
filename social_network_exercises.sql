/* 1. Find the names of all students who are friends with someone named Gabriel. */
SELECT name
FROM Highschooler
WHERE ID IN (SELECT ID1 
FROM Friend
WHERE ID2 IN (SELECT ID
FROM Highschooler
WHERE name = "Gabriel"));

/* 2. For every student who likes someone 2 or more grades younger than themselves, 
return that student's name and grade, and the name and grade of the student they like. */
SELECT HS1.name, HS1.grade, HS2.name, HS2.grade
FROM Highschooler HS1
JOIN Likes L1
ON HS1.ID = L1.ID1
JOIN Highschooler HS2
ON HS2.ID = L1.ID2
WHERE HS1.grade - HS2.grade >= 2;

/* 3. For every pair of students who both like each other, return the name and grade of both students. 
Include each pair only once, with the two names in alphabetical order. */
SELECT H1.name,H1.grade,H2.name,H2.grade 
FROM
	(SELECT ID1,ID2 FROM Likes 
	WHERE ID1 IN (SELECT ID2 FROM Likes) AND
	ID2 IN (SELECT ID1 FROM Likes)) AS G 
JOIN Highschooler H1 
JOIN Highschooler H2
WHERE H1.ID=G.ID1 AND H2.ID=G.ID2 AND H1.name < H2.name 
ORDER BY H1.name,H2.name

/* 4. Find all students who do not appear in the Likes table (as a student who likes or is liked) 
and return their names and grades. Sort by grade, then by name within each grade. */
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN (SELECT DISTINCT ID1
FROM Likes
UNION
SELECT DISTINCT ID2
FROM Likes)
ORDER BY grade, name;

/* 5. For every situation where student A likes student B, but we have no information about whom B likes 
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
SELECT HS1.name, HS1.grade, HS2.name, HS2.grade
FROM Highschooler HS1
JOIN Likes L1
ON HS1.ID = L1.ID1
JOIN Highschooler HS2
ON HS2.ID = L1.ID2
WHERE L1.ID2 NOT IN (SELECT ID1 FROM Likes);

/* 6. Find names and grades of students who only have friends in the same grade. 
Return the result sorted by grade, then by name within each grade. */

/* 7. For each student A who likes a student B where the two are not friends, 
find if they have a friend C in common (who can introduce them!). 
For all such trios, return the name and grade of A, B, and C. */


/* 8. Find the difference between the number of students in the school and the number of different first names. */
SELECT COUNT(ID) - COUNT(DISTINCT name)
FROM Highschooler;

/* 9. Find the name and grade of all students who are liked by more than one other student. */
SELECT name, grade
FROM Highschooler
JOIN Likes 
ON Highschooler.ID = LIKES.ID2
GROUP BY name
HAVING COUNT(name) > 1;