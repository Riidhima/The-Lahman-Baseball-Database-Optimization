   USE [BaseBall_Summer_2018]
   Go

-- 1. SET TEAMS TABLE COLUMNS AS NOT NULL

   ALTER TABLE [dbo].[Teams] ALTER COLUMN lgID VARCHAR(255) NOT NULL
   ALTER TABLE [dbo].[Teams] ALTER COLUMN yearID INT NOT NULL
   ALTER TABLE [dbo].[Teams] ALTER COLUMN teamID VARCHAR(255) NOT NULL

--2. SET TEAMS TABLE COLUMNS AS PRIMARY KEYS

   ALTER TABLE [dbo].[Teams]
   ADD PRIMARY KEY CLUSTERED ([lgID], [yearID], [teamID])

-- 3. MAKE AllstarFull COLUMNS AS NOT NULLS

	ALTER TABLE [dbo].[AllstarFull] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[AllstarFull] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[AllstarFull] ALTER COLUMN teamID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[AllstarFull] ALTER COLUMN playerID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[AllstarFull] ALTER COLUMN gameID VARCHAR(255) NOT NULL

-- 4. SETTING AllstarFull TABLE FOREIGN KEYS FROM TEAMS AND PEOPLE TABLE

	ALTER TABLE [dbo].[AllstarFull]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[AllstarFull]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

	-- NOTE : PEOPLE TABLE WAS ALREADY SET AS PRIMARY IN PREVIOUS ASSIGNMENT

-- 6. Schools - NOT NULL

	ALTER TABLE [dbo].[Schools] ALTER COLUMN schoolID VARCHAR(255) NOT NULL

-- 7. Schools set PRIMARY KEY

	ALTER TABLE [dbo].[Schools]
	ADD PRIMARY KEY CLUSTERED ([schoolID]);

--8. Make CollegePlaying COLUMNS AS NOT NULLS

	ALTER TABLE [dbo].[CollegePlaying] ALTER COLUMN schoolID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[CollegePlaying] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 9. Setting CollegePlaying TABLE FOREIGN KEYS FROM People and Schools

	ALTER TABLE [dbo].[CollegePlaying]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])

	-- Had to delete because of errors of duplicate primary key conflict
	DELETE FROM CollegePlaying WHERE schoolID not in(
	SELECT DISTINCT schoolID FROM Schools)
	
	ALTER TABLE [dbo].[CollegePlaying]  WITH CHECK ADD FOREIGN KEY([schoolID])
	REFERENCES [dbo].[Schools] ([schoolID])

-- 7. -- League Table creation
	IF OBJECT_ID (N'dbo.[League]', N'U') IS NOT NULL
DROP TABLE dbo.[League];
GO
CREATE TABLE League (
lgID varchar (255) NOT NULL,
lgName varchar (255) DEFAULT NULL,
);

ALTER TABLE League 
alter column lgID varchar(255) NOT NULL;

ALTER TABLE League
ADD PRIMARY KEY clustered (lgID)

-- ----------------------------
--  Records of league
-- ----------------------------
INSERT INTO League VALUES('AA', NULL)
INSERT INTO League VALUES('AL', NULL)
INSERT INTO League VALUES('ML', NULL)
INSERT INTO League VALUES('NL', NULL)
INSERT INTO League VALUES('UA', NULL)
INSERT INTO League VALUES('NA', NULL)
INSERT INTO League VALUES('FL', NULL)
INSERT INTO League VALUES('PL', NULL)

Go
Select Count(*) from HallOfFame

-- 8. TeamsFranchises set NOT NULLS

	ALTER TABLE [dbo].[TeamsFranchises] ALTER COLUMN franchID VARCHAR(255) NOT NULL

-- 9. TeamsFranchises make PRIMARY KEYS

	ALTER TABLE [dbo].[TeamsFranchises]
	ADD PRIMARY KEY CLUSTERED ([franchID]);

-- 10. Teams set NOT NULLS
	ALTER TABLE [dbo].[Teams] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Teams] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[Teams] ALTER COLUMN teamID VARCHAR(255) NOT NULL

-- 11. Teams make PRIMARY KEYS

	ALTER TABLE [dbo].[Teams]
	ADD PRIMARY KEY CLUSTERED ([lgID], [yearID], [teamID])

-- 12. Teams FOREIGN KEY from League and TeamFranchises tables

	ALTER TABLE [dbo].[Teams]  WITH CHECK ADD FOREIGN KEY([lgID])
	REFERENCES [dbo].[league] ([lgID])

	ALTER TABLE [dbo].[Teams]  WITH CHECK ADD FOREIGN KEY([franchID])
	REFERENCES [dbo].[TeamsFranchises] ([franchID])

-- 13. HomeGames make FOREIGN KEY from Parks and Teams tables

	ALTER TABLE [dbo].[HomeGames]  WITH CHECK ADD FOREIGN KEY([parkID])
	REFERENCES [dbo].[Parks] ([park_key])

	ALTER TABLE [dbo].[HomeGames]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

-- 14. Parks set columns as NOT NULLS

	ALTER TABLE [dbo].[Parks] ALTER COLUMN park_key VARCHAR(255) NOT NULL

-- 15. Parks make PRIMARY KEY

	ALTER TABLE [dbo].[Parks]
	ADD PRIMARY KEY CLUSTERED (park_key)

-- 16. Appearances set columns as NOT NULLS

	ALTER TABLE [dbo].[Appearances] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Appearances] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[Appearances] ALTER COLUMN teamID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Appearances] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 17. Appearances FOREIGN KEY from People and Teams tables

	ALTER TABLE [dbo].[Appearances]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[Appearances]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

--18. Batting set columns as NOT NULLS

	ALTER TABLE [dbo].[Batting] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Batting] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[Batting] ALTER COLUMN teamID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Batting] ALTER COLUMN playerID VARCHAR(255) NOT NULL
	
-- 19. Batting make FOREIGN KEY from People and Teams tables.

	ALTER TABLE [dbo].[Batting]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[Batting]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

-- 20. Salaries set columns as NOT NULLS

	ALTER TABLE [dbo].[Salaries] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Salaries] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[Salaries] ALTER COLUMN teamID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Salaries] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 21. Salaries make FOREIGN KEY from People and Teams table
-- Had to delete playerID values because of duplicate key error
	DELETE FROM Salaries WHERE playerID NOT IN(
	SELECT DISTINCT playerID FROM People)

	ALTER TABLE [dbo].[Salaries]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[Salaries]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

-- 22. Managers set columns as NOT NULLS

	ALTER TABLE [dbo].[Managers] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Managers] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[Managers] ALTER COLUMN teamID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Managers] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 23. Managers make FOREIGN KEY from People and Teams tables

	ALTER TABLE [dbo].[Managers]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[Managers]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

-- 24. AwardsManagers set columns as NOT NULLS

	ALTER TABLE [dbo].[AwardsManagers] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[AwardsManagers] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 25. AwardsManagers (FOREIGN KEY)

	ALTER TABLE [dbo].[AwardsManagers]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[AwardsManagers]  WITH CHECK ADD FOREIGN KEY([lgID])
	REFERENCES [dbo].[league] ([lgID])

-- 26. AwardsPlayers set columns as NOT NULLS

	ALTER TABLE [dbo].[AwardsPlayers] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[AwardsPlayers] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 27. AwardsPlayers (FOREIGN KEY)

	ALTER TABLE [dbo].[AwardsPlayers]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[AwardsPlayers]  WITH CHECK ADD FOREIGN KEY([lgID])
	REFERENCES [dbo].[league] ([lgID])

-- 28. AwardsSharePlayers set columns as NOT NULLS

	ALTER TABLE [dbo].[AwardsSharePlayers] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[AwardsSharePlayers] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 29. AwardsSharePlayers (FOREIGN KEY)

	ALTER TABLE [dbo].[AwardsSharePlayers]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[AwardsSharePlayers]  WITH CHECK ADD FOREIGN KEY([lgID])
	REFERENCES [dbo].[league] ([lgID])

-- 30. AwardsShareManagers set columns as NOT NULLS

	ALTER TABLE [dbo].[AwardsShareManagers] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[AwardsShareManagers] ALTER COLUMN playerID VARCHAR(255) NOT NULL

-- 31. AwardsShareManagers (FOREIGN KEY)

	ALTER TABLE [dbo].[AwardsShareManagers]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[AwardsShareManagers]  WITH CHECK ADD FOREIGN KEY([lgID])
	REFERENCES [dbo].[league] ([lgID])

-- 32. Pitching set columns as NOT NULLS

	ALTER TABLE [dbo].[Pitching] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Pitching] ALTER COLUMN playerID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Pitching] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[Pitching] ALTER COLUMN teamID VARCHAR(255) NOT NULL

-- 33. Pitching (FOREIGN KEY)

	ALTER TABLE [dbo].[Pitching]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[Pitching]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

-- 34. Fielding set columns as NOT NULLS

	ALTER TABLE [dbo].[Fielding] ALTER COLUMN lgID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Fielding] ALTER COLUMN playerID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Fielding] ALTER COLUMN yearID INT NOT NULL
	ALTER TABLE [dbo].[Fielding] ALTER COLUMN teamID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[Fielding] ALTER COLUMN stint INT NOT NULL
	ALTER TABLE [dbo].[Fielding] ALTER COLUMN POS VARCHAR(255) NOT NULL

-- 35. Fielding (FOREIGN KEY)

	ALTER TABLE [dbo].[Fielding]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])
	
	ALTER TABLE [dbo].[Fielding]  WITH CHECK ADD FOREIGN KEY([lgID], [yearID], [teamID])
	REFERENCES [dbo].[Teams] ([lgID], [yearID], [teamID])

-- 36. FieldingOF set columns as NOT NULLS

	ALTER TABLE [dbo].[FieldingOF] ALTER COLUMN playerID VARCHAR(255) NOT NULL
	ALTER TABLE [dbo].[FieldingOF] ALTER COLUMN yearID INT NOT NULL

-- 37. FieldingOF (FOREIGN KEY)

	ALTER TABLE [dbo].[FieldingOF]  WITH CHECK ADD FOREIGN KEY([playerID])
	REFERENCES [dbo].[People] ([playerID])

