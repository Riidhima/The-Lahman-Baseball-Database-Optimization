Use BaseBall_Summer_2018
go


IF COL_LENGTH('People', 'rs949_Date_Last_Update') IS NULL
    alter table People
		add rs949_Date_Last_Update date default NULL,
	        rs949_Total_Games_Played int default 0;
go

/* Run Simple Update Query To Get Time Without Transaction Processing */

Declare		@today date
Set			@today = convert(date, getdate())
DECLARE     @updateCount bigint 
set			@updateCount = 0

-- Declare variables

DECLARE     @YearID varchar(50)
DECLARE     @TeamID VARCHAR(50)
DECLARE     @LGID varchar(50)
DECLARE     @PlayerID varchar(50)
	
--- Declare Cursor
PRINT 'Declaring Cursor At - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
	  ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

DECLARE updatecursor CURSOR STATIC FOR
        SELECT Appearances.yearID, Appearances.TeamID, Appearances.LGID, Appearances.PLayerid
            FROM People, Appearances
		 	WHERE People.playerID = appearances.playerid and 
				(rs949_Date_Last_Update <> @today or rs949_Date_Last_Update is Null);

--- change to do aggregation in the cursor

set nocount on
--- Open Cursor
 PRINT 'Opening Cursor At - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
       ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
    OPEN updatecursor
	Select @@CURSOR_ROWS as 'Number of Cursor Rows After Declare'
	PRINT 'Cursor Rows - ' + RTRIM(CAST(@@cursor_rows AS nvarchar(30))) + 
       ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

    FETCH NEXT FROM updatecursor INTO @yearID, @TeamID, @LGID, @PLayerid
    WHILE @@fetch_status = 0 

    BEGIN

	set @updatecount = @updatecount + 1
	IF @updateCount % 10000 = 0 
        BEGIN
            PRINT 'TRANSACTION Count - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
			      ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
		END
	Update People
		set rs949_Date_Last_Update = @today
			where @PLayerid = playerID;
	Update People 
		set rs949_Total_Games_Played = rs949_Total_Games_Played + 
			(select G_All 
				from Appearances
				where @yearID = yearID AND
					@TeamID = teamid AND
					@LGID = LGID AND
					@PLayerid = playerID)
			where People.playerid = @PlayerID;
	FETCH NEXT FROM updatecursor INTO @yearID, @TeamID, @LGID, @PLayerid
    END

            PRINT 'TRANSACTION Count - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
			      ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
CLOSE updatecursor
DEALLOCATE updatecursor