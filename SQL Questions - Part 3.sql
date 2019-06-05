Use BaseBall_Summer_2018;
Go


--Q1--
select playerid, [Full Name], [Career Batting Average] as CareerBA, RANK() Over ( order by [Career Batting Average] ) as BA_Rank from dbo.rs949_Player_History
where [Career Batting Average] > 0.40

--Q2--
select playerid, [Full Name], [Career Batting Average] as CareerBA, DENSE_RANK() Over ( order by [Career Batting Average] ) as BA_Rank from dbo.rs949_Player_History
where [Career Batting Average] > 0.40

--Q3--
select playerid, [Full Name], [Career Batting Average] as CareerBA, [Last Played], Rank() over(order by [Last Played] desc) as BA_Rank from dbo.rs949_Player_History
where [Career Batting Average] > 0

--Q4--
select playerid, [Full Name],[Last Played], [Career Batting Average] as CareerBA, NTILE(4) over(order by [Last Played] desc) as Ntile from dbo.rs949_Player_History
where [Career Batting Average] > 0

--Q5--
Select sal.teamID, sal.yearID, FORMAT(sal.AvgSal,'C') as AverageSalary, 
FORMAT(AVG(sal.AvgSal) Over (Partition by teamID Order by yearID ROWS BETWEEN 3 preceding AND 1 following),'C') as Windowed_Salary
From (Select teamID, yearID, AVG(salary) as AvgSal 
From Salaries Group by teamID, yearID) sal

--Q6--
select  batting.teamid, Batting.playerID, dbp.[Full Name], Sum(Batting.h) as TotalHits, sum(Batting.AB) as TotalAtBats, sum(H)*1.0/sum(AB) as BattingAvg,
RANK() over (order by batting.teamid) as AllBattingRank, RANK() over (order by batting.playerid) as TeamBattingRank
from Batting left join rs949_Player_History dbp on Batting.playerID = dbp.PlayerID
where Batting.AB > 150
group by batting.playerID, Batting.teamID, dbp.[Full Name]