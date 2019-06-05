Use BaseBall_Summer_2018;
Go

-- Question 1 (Creating a View)

CREATE VIEW rs949_Player_History AS 

WITH Team_Data AS
	 (SELECT DISTINCT playerID, COUNT(DISTINCT teamID) AS Num_Teams, MAX(yearID) - MIN(yearID) AS Years_Played
	  FROM Appearances
	  GROUP BY playerID),
	  	
	 Salary_Info AS
	 (SELECT DISTINCT playerID, SUM(salary) AS [Total Salary], AVG(salary) AS [Average Salary]
	  FROM Salaries
	  GROUP BY playerID),
	  
	 College_Info AS
	 (SELECT DISTINCT CollegePlaying.playerID, College_Last_Year, Num_CollegeYears, Num_Colleges, max(schoolID) as Last_College
	  FROM (SELECT playerID, MAX(yearID) AS College_Last_Year, MAX(yearID) - MIN(yearID) AS Num_CollegeYears, COUNT(schoolID) as Num_Colleges
	       FROM CollegePlaying 
	       GROUP BY playerID) A, CollegePlaying
	  WHERE	yearID = College_Last_Year and CollegePlaying.playerID = A.playerID
	  GROUP BY CollegePlaying.playerID, College_Last_Year, Num_CollegeYears, Num_Colleges),

	 Batting_Info AS
	 (SELECT DISTINCT playerID, SUM (HR) AS [Career Home Runs], AVG(CONVERT(DECIMAL(5,4),H*1.0/AB*1.0)) AS [Career Batting Average], 
	  MAX(CONVERT(DECIMAL(5,4),H*1.0/AB*1.0)) AS [Highest Batting Average]
	  FROM Batting
	  WHERE AB > 0 
	  GROUP BY playerID),

	 Pitching_Info AS 
	 (SELECT DISTINCT playerID, SUM(W) AS [Career Wins], SUM(L) AS [Career Loss],
	  SUM(HR) AS [Career PHR], AVG(ERA) AS [Average ERA], 
	  MAX(ERA) AS [Max ERA],
	  SUM(SO) AS [Career SO], MAX(SO) AS [Highest SO]
	  FROM Pitching
	  GROUP BY playerID),

	 AwardsPlayersInfo AS
	 (SELECT playerID, COUNT(awardID) AS [Player Awards]
	  FROM AwardsPlayers 
	  GROUP BY playerID),

	 AwardsSharePlayersInfo AS
	 (SELECT playerID, COUNT(awardID) AS [Players Shared]
	  FROM AwardsSharePlayers
	  GROUP BY playerID),

	 Appeareances_Info as
	 (SELECT A.playerID, [Last Played], MAX(teamID) AS [Last TeamID]
	  FROM Appearances, 
	 (SELECT playerID, MAX(yearID) AS [Last Played]
	  FROM Appearances 
	  GROUP BY playerID) A 
	  WHERE Appearances.playerID = A.playerID and A.[Last Played] = Appearances.yearID
	  GROUP BY A.playerID, [Last Played]),

	 Inducted_Info AS
	 (SELECT DISTINCT People.playerID,
	  CASE 
	  WHEN People.playerid IN (SELECT playerid from HallOfFame) THEN 'Hall Famer'
	  ELSE 'Not Inducted'
	  END AS [Hall Of Famer]
	  FROM People left join HallOfFame
	  ON HallOfFame.playerID = People.playerID)

	 SELECT People.playerID, (nameGiven + ' (' + nameFirst + ') ' + nameLast) AS [Full Name], [Hall Of Famer], 
	 [Average Salary], [Total Salary], 
	 Num_Teams, Years_Played,
	 Last_College, College_Last_Year, Num_Colleges, Num_CollegeYears,
	 [Career Home Runs], [Career Batting Average], [Highest Batting Average], 
	 [Career Wins], [Career Loss], [Career PHR], [Average ERA], [Max ERA], [Career SO], [Highest SO],
	 [Player Awards], [Players Shared], [Last Played], [Last TeamID]
	 FROM People
		left join Team_Data on People.playerID = Team_Data.playerID
		left join Salary_Info on People.playerID = Salary_Info.playerID
		left join College_Info on People.playerID = College_Info.playerID
		left join Batting_Info on People.playerID = Batting_Info.playerID 
		left join Pitching_Info on People.playerID = Pitching_Info.playerID 
		left join AwardsPlayersInfo on People.playerID = AwardsPlayersInfo.playerID 
		left join AwardsSharePlayersInfo on People.playerID = AwardsSharePlayersInfo.playerID 
		left join Appeareances_Info on People.playerID = Appeareances_Info.playerID 
		left join Inducted_Info on People.playerID = Inducted_Info.playerID 
		
-- Question 2

	SELECT * From rs949_Player_History
	ORDER BY playerID

-- Question 3

	CREATE ROLE READER
	GRANT SELECT ON rs949_Player_History TO READER
	REVOKE INSERT, UPDATE, DELETE, SELECT ON Salaries TO READER