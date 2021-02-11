/* 1. It's time for the seniors to graduate. 
Remove all 12th graders from Highschooler. */
DELETE FROM Highschooler
WHERE grade = 12;

/* 2. If two students A and B are friends, and A likes B 
but not vice-versa, remove the Likes tuple. */
DELETE FROM Likes
WHERE ID1 IN (SELECT DISTINCT HS1.ID 
FROM Highschooler HS1, Highschooler HS2 
JOIN Friend ON HS1.ID = Friend.ID1
JOIN Likes ON HS1.ID = LIkes.ID1
WHERE HS2.ID IN (
	SELECT ID2 
	FROM Friend 
	WHERE Friend.ID1 = HS1.ID
	INTERSECT
	SELECT ID2 
	FROM Likes 
	WHERE Likes.ID1 = HS1.ID)
AND 
HS1.ID NOT IN (
	SELECT ID2
	FROM Likes
	WHERE Likes.ID1 = HS2.ID));

/* 3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. 
Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 
(This one is a bit challenging; congratulations if you get it right.) */
INSERT INTO Friend
SELECT DISTINCT F1.ID1, F2.ID2
FROM Friend F1, Friend F2
WHERE F1.ID2 = F2.ID1 AND F1.ID1 <> F2.ID2 AND F1.ID1 NOT IN (
  SELECT F3.ID1
  FROM Friend F3
  WHERE F3.ID2 = F2.ID2
);
