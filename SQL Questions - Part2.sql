Use BaseBall_Summer_2018;
Go

---1.	Write a query that lists the playerid, birthcity, birthstate, salary and batting average for all players born in New Jersey sorted by last name and year in ascending order. 
---The joins must be made using the WHERE clause. 
---Make sure values are properly formatted.
select People.playerID, birthCity, birthState, Salaries.yearID, format(salary,'C') as Salary, Convert(decimal(5,4),(H*1.0/AB)) as [Batting Average]
 from People, Salaries, Batting 
 where AB>0 and 
 People.playerID=Salaries.playerID and 
 Batting.yearid = Salaries.yearid and
 Batting.lgid = Salaries.lgid and 
 Batting.teamid = Salaries.teamid and 
 people.playerID=Batting.playerID and 
 birthState='NJ' 
 order by nameLast,Salaries.yearID


---2.	Write the same query as #1 but you need to use JOIN clauses in the FROM clause to join the tables.
--- Your answers and rows returned should be the same. 
select people.playerID, birthCity, birthState, Salaries.yearID, format(salary,'C') as Salary, Convert(decimal(5,4),(H*1.0/AB)) as [Batting Average] 
from People join Salaries on People.playerID=Salaries.playerID join Batting on batting.yearid = salaries.yearid and 
Batting.lgid = Salaries.lgid and 
Batting.teamid = Salaries.teamid and 
People.playerID=Batting.playerID 
where AB>0 and 
birthState='NJ' 
order by nameLast,Salaries.yearID


---3.	Write the same query as #2 but use a LEFT JOIN.   
---armstja01 will be the first player with a non-null salary. 
select People.playerID, birthCity, birthState, Batting.yearID, format(salary,'C') as Salary, Convert(decimal(5,4),(H*1.0/AB)) as [Batting Average] from People
left join Batting on  People.playerID=Batting.playerID 
left join Salaries on Batting.playerID=Salaries.playerID and 
Batting.yearid = Salaries.yearid and 
Batting.lgid = Salaries.lgid and 
Batting.teamid = Salaries.teamid 
where AB>0 and birthState='NJ' 
order by nameLast,Salaries.yearID


---4.	Using a BETWEEN clause, find all players with a Batting Average between .0.300 and 0.3249.
--- The query should return the Full Name (NameGiven (NameFirst) NameLast), YearID, Hits, At Bats and Batting Average sorted by descending batting average.
select People.playerid, NameGiven + ' ( ' + namefirst + ' ) ' + nameLast as [Full Name], yearID, H,AB, Convert(decimal(5,4), (H*1.0/AB)) as [Batting Average] from People, Batting 
where Convert(decimal(5,4), (H*1.0/AB)) between .3000 and .3249 and AB >0 and People.playerID=Batting.playerID 
order by Convert(decimal(5,4), (H*1.0/AB)) DESC


---5.	You get into a debate regarding the level of school that professional sports players attend.
--- Your stance is that there are plenty of baseball players who attended Ivy League schools and were good batters in addition to being scholars. 
---Write a query to support your argument using the People, CollegePlaying and Batting tables.
--- You must use an IN clause in the WHERE clause to identify the Ivy League schools.
--- You have also decided that a batting average less than .4 indicates a good batter. 
---Sort you answer by Batting Average in descending order. 
select distinct p.playerID,schoolID, b.yearID, Convert(decimal(5,4),(H*1.0/AB)) as [Batting Average] 
from People p, CollegePlaying c, Batting b
where ab>0 and Convert(decimal(5,4), (H*1.0/AB)) <.4 and 
schoolID in ('Brown','Dartmouth','Harvard','Columbia','Cornell','Princeton', 'Yale','UnivPenn' ) and 
p.playerID=c.playerid and 
b.playerID=c.playerID  and 
p.playerID=b.playerID 
order by [Batting Average] DESC


---6.	Using the Appearances table and the appropriate SET clause from slide 45 of the Chapter 3 PowerPoint presentation, find the players that played for the same teams in 2007 and 2010. 
---Your query only needs to return the playerid and teamids. 
---The query should return 297 rows.
(select playerid, teamid from Appearances where yearID=2007)
intersect
(select playerid, teamid from Appearances where yearID=2010)


---7.	Using the Appearances table and the appropriate SET clause from slide 45 of the Chapter 3 PowerPoint presentation, find the players that played for the different teams in 2007 and 2010.
--- Your query only needs to return the playerids and the 2007 teamids. 
---The query should return 649 rows.
(select playerid, teamid from Appearances where yearID=2007)
except
(select playerid, teamid from Appearances where yearID=2010)


---8.	Using the Salaries table, calculate the average and total salary for each player. 
---Make sure the amounts are properly formatted.
select playerid, format(avg(salary),'C') as AvgSalary, format(sum(salary),'C') as TotalSal
from Salaries
group by playerID


---9.	Using the Batting table and a HAVING clause, write a query that lists the playerid and number of home runs (HR) for all players having more than 500 home runs.
SELECT playerID, sum(HR) AS [Total Home Runs]
FROM Batting
GROUP BY playerID
HAVING SUM(HR)>500


---10.	Using a subquery along with an IN clause in the WHERE statement, write a query that identifies all the playerids, the players full name and the team names who in 2010 that were playing on teams that existed in 1910.
--- You should use the appearances table to identify the players years and the TEAMS table to identify the team name. 
---Sort your results by players last name. 
---Your query should return 446 rows.
select a.playerid, NameGiven + ' ( ' + namefirst + ' ) ' + nameLast as [Full Name], t.name
from People p, Appearances a, Teams t
where a.teamid in (select distinct a.teamid from Appearances a where a.yearid = 1910) and 
t.yearid = 2010 and 
a.yearID=t.yearID and 
a.teamID=t.teamID and 
a.lgID= t.lgID and 
p.playerID=a.playerID
order by nameLast


 ---11.	Using the Salaries table, find the players full name, average salary and the last year they played for each team they played for during their career. 
 ---Also find the difference between the players salary and the average team salary. 
 ---You must use subqueries in the FROM statement to get the team and player average salaries and calculate the difference in the SELECT statement. 
 ---Sort your answer by the playerid in ascending and last year in descending order
select  distinct Salaries.playerid, nameGiven + ' ( ' + nameFirst + ' ) ' + namelast as [Full Name], p.teamid, [Last Year],
format(pavg,'C') as [Player Average], format(tavg,'C') as [Team Avg], format(pavg-tavg,'C') as [Difference]
from People, Salaries,
 (select playerid, teamid, avg(salary) as pAvg, max(yearID) as [Last Year]
 from SALARIES
 group by playerid, teamid) P,
 (select teamid, avg(salary) as tavg
 from SALARIES
 group by teamid) T
 where p.teamID=t.teamID and 
 Salaries.playerID=p.playerID and 
 Salaries.teamID=p.teamID and 
 People.playerID=Salaries.playerID
order by playerid, [Last Year] DESC


 ---12.	Rewrite the query in #11 using a WITH statement for the subqueries instead of having the subqueries in the from statement.
 --- The answer will be the same.
 With T as
(select teamid, avg(salary) as Tsal
 from Salaries
 group by teamid),
	  P as
(select playerid, teamid, avg(salary) as Psal, max(yearID) as [Last Year]
 from Salaries
 group by playerid, teamid)

select  distinct Salaries.playerid, nameGiven + ' ( ' + nameFirst + ' ) ' + namelast as [Full Name], p.teamid,[Last Year],
format(Psal,'C') as [Player Average], format(Tsal,'C') as [Team Avg], format(Psal-Tsal,'C') as [Difference]
from People, Salaries, P, T
where p.teamID=t.teamID and 
Salaries.playerID=p.playerID and 
Salaries.teamID=p.teamID and 
People.playerID=Salaries.playerID
order by playerid, [Last Year] DESC


 ---13.	Using a scalar queries in the SELECT statement and the salaries and people tables , write a query that shows the full Name, the average salary and the number of teams the player played.
 select nameGiven + ' ( ' + nameFirst + ' ) ' + namelast as [PLayer Full Name], format(avg(salary),'C') as [Average Salary],
(select distinct count(teamid)
 from Salaries
 where Salaries.playerid = People.playerid) as [NumTeams]
from People, Salaries
where People.playerid = Salaries.playerID
group by nameFirst, nameGiven, nameLast, People.playerID
order by nameLast


-- nameLast+', '+nameFirst as [Player Full Name]   ,avg(salary) 

 ---14.	The player’s union has negotiated that players will start to have a 401K retirement plan. 
 ---You have been asked to add a column to the SALARIES table called P401K Contribution and populate this column for each row by updating it to contain 6% of the salary in the row.
 --- You must use an ALTER TABLE statement to create the column and then an UPDATE query to fill in the amount. 
---Your query should also properly handle the circumstance where you are running this multiple times and handle if the column already exists. 
ALTER TABLE Salaries
DROP COLUMN [P401K_Contribution];

IF NOT EXISTS(
    SELECT *
    FROM sys.columns 
    WHERE Name= 'P401K_Contribution'
      AND Object_ID = Object_ID('Salaries'))
BEGIN
  ALTER TABLE Salaries
  ADD [P401K_Contribution] money
END
update Salaries
SET P401K_Contribution= 0.06*salary
select * from Salaries order by playerID, yearID


---15.	Contract negotiations have proceeded and now the team owner will make a matching contribution to each players 401K each year.
--- If the player’s salary is under $1 million, the team will contribute another 5%.
--- If the salary is over $1 million, the team will contribute 2.5%.
--- You now need to add a T401K Contribution column to the salary table and then write an UPDATE query to populate the team contribution with the correct amount.
--- You must use a CASE clause in the UPDATE query to handle the different amounts contributed.
ALTER TABLE Salaries
DROP COLUMN [T401K_Contribution];

IF NOT EXISTS(
    SELECT *
    FROM sys.columns 
    WHERE Name= 'T401K_Contribution'
      AND Object_ID = Object_ID('Salaries'))
BEGIN
  ALTER TABLE Salaries
  ADD [T401K_Contribution] money
END

update Salaries
set T401K_Contribution= case when salary <= 1000000 then salary * 0.05
else  0.025* salary
end
select * from Salaries order by playerID, yearID


---16.	Write a query that shows the Playerid, yearid, Salary, Player contribution, Team Contribution and total 401K contribution each year for each player.
--- Do not include players with no contributions. 
---Sort your results by playerid.
SELECT playerID, yearID, salary, format(P401k_Contribution,'C') as [Player_401k], format(T401k_Contribution,'C') as [Team_401k], format(P401k_Contribution+T401k_Contribution,'C') as [401k_Total]
FROM Salaries
where salary is not null
order by playerID


---17.	You have now been asked to add columns to the PEOPLE table that contain the total number of HRs hit by the player and the highest Batting Average the player had during their career (Career BA). 
---Write the SQL that creates the column using an ALTER TABLE statement and correctly populates the new column.
ALTER TABLE People
DROP COLUMN BATTOTAL;

ALTER TABLE People
DROP COLUMN BATAVG;

IF NOT EXISTS(
    SELECT *
    FROM sys.columns 
    WHERE Name= 'BATTOTAL'
      AND Object_ID = Object_ID('People'))
BEGIN
    ALTER TABLE People
    ADD [BATTOTAL] INT
END

IF NOT EXISTS(
    SELECT *
    FROM sys.columns 
    WHERE Name= 'BATAVG'
      AND Object_ID = Object_ID('People'))
BEGIN
    ALTER TABLE People
    ADD [BATAVG] FLOAT
END
update People
	set BATTOTAL = BTOT 
		from (select playerid, SUM(HR) as BTOT
				 from Batting
				 group by playerid) A
		where people.playerid = A.playerID
update People
	set BATAVG = t.BAVG 
		from (select PLAYERID, max(Convert(decimal(5,4),(H*1.0/AB))) as BAVG
				 from Batting
				  WHERE AB > 0 GROUP BY PLAYERID) T
				  		where people.playerid = T.playerid
select BATTOTAL,BATAVG from People


---18.	Write a query that shows the playerid, Total HRs and Highest Batting Average for each player. 
---Sort the results by playerid.
SELECT PLAYERID, BATTOTAL as [Total HR], BATAVG as [Batting Average] FROM People
order by playerID


---19.	You have also been asked to create a column in the PEOPLE table that contains the total value of the 401 for each player.  
---Write the SQL that creates the column using an ALTER TABLE statement and correctly populates the new column.
ALTER TABLE People
DROP COLUMN Tot401k;

IF NOT EXISTS(
    SELECT *
    FROM sys.columns 
    WHERE Name      = 'Tot401k'
      AND Object_ID = Object_ID('PEOPLE'))
BEGIN
    ALTER TABLE PEOPLE
    ADD [Tot401k] MONEY
END

update People
SET Tot401K = totalsal
		from (select playerid, sum(P401K_Contribution + T401K_Contribution) as totalsal
				 from salaries
				 group by playerid) A, people 
		where people.playerid = a.playerid

select playerID, format(TOT401K,'C') as [TOTAL 401K CONTRIBUTION] from people where TOT401K is not null
SELECT * FROM People 


---20.	Write a query that shows the playerid, the player full name and their 401K total from the people table. 
---Only show players that have contributed to their 401Ks. 
---Sort the results by playerid.
select PLAYERID, NameGiven + ' ( ' + namefirst + ' ) ' + nameLast as [Full Name], FORMAT(Tot401K,'C') AS [TOTAL 401K]
	from People 
	where TOT401K is not null
	ORDER BY playerID


---21.	As with any job, players are given raises each year, write a query that calculates the increase each player received and calculate the % increase that raise makes.
--- You will only need to use the SALARIES table. 
---You answer should include the columns below. 
---Include the players full name and sort your results by playerid and year.
select s2.playerid, s1.salary, s2.salary, s1.salary-s2.salary as saldiff,
format((s1.salary-s2.salary)/(s2.salary),'P') as perdiff
from salaries as s1, salaries s2
where s1.yearid-1=s2.yearid and
      s1.lgid=s2.lgid and
      s1.teamid=s2.teamid and 
      s1.playerid=s2.playerid
	  order by playerID