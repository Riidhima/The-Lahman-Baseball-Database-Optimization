---SQL Questions- Part 1 : RIDHIMA SHINDE        UCID: rs949      

use BaseBall_Summer_2018

---1.	Select yearid, lgid, teamid, playerid and the number of home runs (HR) from the BATTING table.

select yearid,lgid, teamid, playerid, HR 
from Batting


---2.	Modify the query in #1 so it also shows the number of hits that were for “extra bases” and the batting average (H/AB). 
---The Extra Bases column must be calculated by adding the following columns together (2B, 3B and HR).
---  Rename the derived column Extra Base Hits.

select yearid,lgid, teamid, playerid, HR, convert(decimal(5,4),(H*1.0/AB)) as [Batting Average], (B2+B3+HR) as [Extra Base Hits] 
from Batting
where AB >0


---3.	Using the Batting table, create a list of all the players who played for more than 1 team in any season.
--- This would be indicated there being rows where stint >1.
--- Make sure all playerids are listed only one.
 
 select distinct playerid 
 from Batting 
 where stint>1


---4.	Select the yearid, lgid, Teamid, PlayerID and HR from the Batting table for all players who hit 20 or more home runs (HR) in 2015 or 2016 and played on the New York Yankees.
-- Hint: Use teamid NYA in your where statement

select yearid,lgid, teamid, playerid, HR
from Batting
where HR >= 20 and yearid IN (2015,2016) and teamid='NYA'


---5.	Using the SALARIES table, write a query that selects the yearid, teamid, playerid and salary (formatted with $ and . ) for everyone who played for the Boston Red Sox (teamid = BOS) in 2016

select yearid, teamid, playerid, format (salary,'c') as salary
from salaries
where teamid= 'BOS' and yearid=2016 


---6.	Modify the query in #5 to include the players first and last name (namefirst and namelast) from the PEOPLE table.

select yearid, teamid, people.playerid, namefirst, namelast, format (salary,'C') as salary 
from salaries, people 
where teamid = 'BOS' and yearid = 2016 and people.playerid = salaries.playerid


---7.	Modify the query in #6 to also include the # of home runs (HR) from the batting table and the positions each player played (POS column from the FIELDING table) for the first team the player played for in 2016  (stint = 1). 
---Note the correct answer returns 33 rows (see message tab in SSMS). 
---In this problem, you must use the WHERE clause to perform the joins between the tables

 select salaries.yearid, salaries.teamid, salaries.playerid, namefirst, namelast, HR, fielding.pos, batting.stint, format (salary,'C') as salary 
  from salaries, people, batting, fielding 
  where people.playerid = salaries.playerid and 
        salaries.playerid = batting.playerid and 
		salaries.teamid = batting.teamid and
		salaries.yearid = batting.yearid and 
        salaries.playerid = fielding.playerid and
		salaries.teamid = fielding.teamid and 
		salaries.yearid = fielding.yearid and 
        salaries.teamid = 'BOS' and 
		salaries.yearid = 2016 and 
		batting.stint = 1


---8.	Rewrite #7 using join clause to perform the joins instead of the where clause. The result set and number of rows returned will be the same.

select salaries.yearid, salaries.teamid, salaries.playerid, namefirst, namelast, HR, fielding.pos, batting.stint, format (salary,'C') as salary 
from salaries join people on people.playerid = salaries.playerid
join batting on salaries.playerid = batting.playerid and
     salaries.teamid = batting.teamid and 
     salaries.yearid = batting.yearid
join fielding on salaries.playerid = fielding.playerid and 
     salaries.teamid = fielding.teamid and
     salaries.yearid = fielding.yearid
where salaries.teamid = 'BOS' and 
      salaries.yearid = 2016 and
      batting.stint = 1


---9.	Concatenate the 3 name columns in the people table in the following format: namegiven (namefirst) namelast and rename the result column to Full Name. 
---Only include players who use their initials as their namefirst. 
---This would be indicated by namefirst containing a period (.). 

 select (namegiven + ' (' + namefirst + ') ' + namelast) as [Full Name] 
  from people 
  where namefirst like '%.%'


---10.	Repeat the query in #9, by sort in reverse order by namefirst

select playerid, (namegiven + ' (' + namefirst + ') ' + namelast) as [Full Name] 
from people 
where namefirst like '%.%' 
order by namefirst desc


---11.	Modify the query in #9 by showing the players who played a position in the infield (POS = 1B, 2B, 3B or SS) for the National League ( lgid = NL) from the Fielding table.

select distinct (namegiven + ' (' + namefirst + ') ' + namelast) as [Full Name], fielding.yearid, fielding.teamid, fielding.POS 
from people join fielding on people.playerid = fielding.playerid 
where namefirst like '%.%' and POS in ('1B','2B','3B','SS') and lgid = 'NL'


---12.	Modify the query in #11 to only include the years where the player’s team had a win percent greater than .500 using the information on the games in the teams table. 
---Format the Percent Win to have 4 decimal places using a CONVERT clause. 

select distinct (namegiven + ' (' + namefirst + ') ' + namelast) as [Full Name], fielding.yearid, fielding.teamid, fielding.POS, W, L, 
convert(decimal(5,4),(W*.1)/(W+L)*10) as [Percent Won]
from people join fielding on people.playerid = fielding.playerid 
join teams on fielding.yearid = teams.yearid and
     fielding.lgid = teams.lgid and
     fielding.teamid = teams.teamid
where namefirst like '%.%' and POS in ('1B','2B','3B','SS') and fielding.lgid = 'NL' and 
convert(decimal(5,4),(W*1.0)/(W+L)) > 0.500


---13.	Add the Name, City and State of the teams Park (from the park table) to the query for #12. 

select distinct (namegiven + ' (' + namefirst + ') ' + namelast) as [Full Name], fielding.yearid, fielding.teamid, fielding.POS, W, L,
convert(decimal(5,4),(W*.1)/(W+L)*10) as [Percent tWon], parks.park_name, parks.city, parks.state
from people join fielding on people.playerid = fielding.playerid 
join teams on fielding.yearid = teams.yearid and 
     fielding.lgid = teams.lgid and 
     fielding.teamid = teams.teamid
join parks on teams.park = parks.park_name
where namefirst like '%.%' and POS in ('1B','2B','3B','SS') and fielding.lgid = 'NL' and 
convert(decimal(5,4),(W*1.0)/(W+L)) > 0.500



