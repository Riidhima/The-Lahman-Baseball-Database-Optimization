Use BaseBall_Summer_2018;
Go

--- FUNCTION

    CREATE FUNCTION FName (@playerID VARCHAR(255))
	RETURNS VARCHAR (255)
	AS
	BEGIN 
	DECLARE @fname VARCHAR (255)
	SET @fname = (SELECT (nameGiven + ' (' + nameFirst + ') ' + nameLast) AS Full_Name
				FROM People
				WHERE People.playerID = @playerID)
	RETURN @fname
	END


	SELECT A.teamID, People.playerid, [dbo].[FName](People.playerID) AS Full_Name, Hits, At_Bats, Batting_Avg,
	RANK() OVER (PARTITION BY A.teamID ORDER BY Batting_Avg DESC) AS Team_Batting_rank,
	RANK() OVER (ORDER BY Batting_Avg DESC) AS All_Batting_rank  
	FROM People,
	(SELECT playerID, teamID, SUM(H) AS Hits, SUM(AB) AS At_Bats, (CONVERT(DECIMAL(5,4),SUM(H)*1.0/SUM(AB))) AS Batting_Avg
	 FROM Batting
	 GROUP BY teamID, playerID
	 HAVING SUM(AB)>0 and SUM(H)>=150) A
	WHERE People.playerID = A.playerID
	ORDER BY A.teamID, Team_Batting_rank