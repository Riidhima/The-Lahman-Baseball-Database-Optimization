Use BaseBall_Summer_2018;
Go

--- create new columns
--- Step 1 Check to see if total column exists and create if it doesn't
IF not exists (Select *
			   From INFORMATION_SCHEMA.COLUMNS
			   Where TABLE_NAME = 'People' and COLUMN_NAME = 'rs949_Total_Salary')
BEGIN
    ALTER TABLE People
    ADD rs949_Total_Salary money;
END;
GO
--- Check to see if Average column exists, create if it doesn't
IF not exists (Select *
			   From INFORMATION_SCHEMA.COLUMNS
			   Where TABLE_NAME = 'People' and COLUMN_NAME = 'rs949_Average_Salary')
BEGIN
    ALTER TABLE People
    ADD rs949_Average_Salary money;
END;
GO
---Populate Average Salary column 
UPDATE People
	   SET rs949_Average_Salary = Total.A_Salary from (select playerID, Avg(salary) as A_Salary
													 from Salaries
													 group by playerID) as Total,People
	  where Total.playerID=People.playerID		
GO
--- Populate Total Salary Column
UPDATE People
	   SET rs949_Total_Salary = Total.T_Salary from (select playerID, Sum(salary) as T_Salary
													 from Salaries
													 group by playerID) as Total,People
	  where Total.playerID=People.playerID		
GO

--- Check to see if trigger exists, delete if it does
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'rs949_TSalary'
    )
    DROP TRIGGER rs949_TSalary;
GO
--- Create trigger
create trigger rs949_TSalary
	on Salaries after INSERT, UPDATE, delete
	as
Begin
	if exists(SELECT * from inserted) and exists (SELECT * from deleted) 
	begin
   		Update People 
		set rs949_Total_Salary = (rs949_Total_Salary - d.salary + i.salary)
			from deleted d, inserted i
			Where People.playerid = d.playerid and People.playerid = i.playerID;
		Update People 
		set rs949_Average_Salary = (a.Avg_Salary)
			from (select s.playerid, avg(s.salary) as Avg_Salary
						from salaries s, inserted i
						where s.playerid = i.playerID
						group by s.playerid) A
			where people.playerid = a.playerid
	end

	If exists (Select * from inserted) and not exists(Select * from deleted) 
	begin
		Update People 
		set rs949_Total_Salary = (rs949_Total_Salary + i.salary)
			From inserted i
			Where People.playerid = i.playerID;
		Update People 
		set rs949_Average_Salary = (a.Avg_Salary)
			from (select s.playerid, avg(s.salary) as Avg_Salary
						from salaries s, inserted i
						Where s.playerid = i.playerID
						group by s.playerid) A
			where people.playerid = a.playerid
	end
	if not exists(SELECT * from inserted) and exists (SELECT * from deleted) 
	begin
		Update People 
		set rs949_Total_Salary = (rs949_Total_Salary - d.salary)
			From deleted d
			Where People.playerid = d.playerID
		Update People 
		set rs949_Average_Salary = (a.Avg_Salary)
			from (select s.playerid, avg(s.salary) as Avg_Salary
						from salaries s, deleted d
						where s.playerid = d.playerID
						group by s.playerid) A
			where people.playerid = a.playerid
	end
end

go



-- tests delete
select playerid, rs949_Total_Salary from People where playerid ='clarkja01'
select * from salaries where playerid ='clarkja01' and yearid = 1986
delete from salaries where playerid ='clarkja01' and yearid = 1986
select playerid, rs949_Total_Salary from People where playerid ='clarkja01'

--- tests update
select playerid, rs949_Total_Salary, rs949_Average_Salary from People where playerid ='clarkja01'
select * from salaries where playerid ='clarkja01' and yearid = 1987
update salaries 
	set salary = 1000000 where playerid ='clarkja01' and yearid = 1987
select playerid, rs949_Total_Salary, rs949_Average_Salary from People where playerid ='clarkja01'

---tests insert
select playerid, rs949_Total_Salary from People where playerid ='clarkja01'
INSERT INTO  Salaries (yearID, teamID, lgID,playerID, salary)  VALUES ('1986', 'ATL', 'NL', 'clarkja01', '500')
select playerid, rs949_Total_Salary from People where playerid ='clarkja01'

