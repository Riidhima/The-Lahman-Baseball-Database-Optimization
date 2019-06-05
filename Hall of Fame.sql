Use BaseBall_Summer_2018;

IF OBJECT_ID (N'dbo.[HallOfFame]', N'U') IS NOT NULL
ALTER TABLE dbo.people
ALTER COLUMN playerid varchar(255) Not Null
Go 

ALTER TABLE dbo.people
ADD constraint pk_people primary key clustered (playerid);
GO
Drop table HallOfFame

CREATE TABLE HallOfFame (
playerid varchar(255) NOT NULL,
yearid int NOT NULL,
votedby varchar(255) NOT NULL,
ballots int NOT NULL,
needed int NOT NULL,
votes int NOT NULL,
inducted char(1) NOT NULL check (inducted in ('Y', 'N')),
category varchar(255) NOT NULL,
needed_note varchar(255) default NULL,
primary key (playerid,yearid,votedby),
constraint fk_HallOfFame Foreign Key (playerid)
REFERENCES dbo.people (playerid)

) on [primary];
go
