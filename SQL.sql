/*Analysis of UEFA Competitions Using SQL*/

/*Create required Tables*/
CREATE TABLE goal(
GOAL_ID VARCHAR(10) PRIMARY KEY,	
MATCH_ID VARCHAR(10) NOT NULL,	
PID	VARCHAR(15) NOT NULL,
DURATION INTEGER,	
ASSIST VARCHAR(15),	
GOAL_DESC VARCHAR(25));
SELECT*FROM GOAL;


CREATE TABLE matches (
    match_id VARCHAR(20) PRIMARY KEY,
    season VARCHAR(20),
    date DATE,
    home_team VARCHAR(50),
    away_team VARCHAR(50),
    stadium VARCHAR(50),
    home_team_score INTEGER,
    away_team_score INTEGER,
    penalty_shoot_out INTEGER,
    attendance INTEGER);
SELECT *FROM matches; 

CREATE TABLE players (
    player_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    nationality VARCHAR(50),
    dob DATE,
    team VARCHAR(50),
    jersey_number INTEGER,
    position VARCHAR(20),
    height INTEGER,
    weight INTEGER,
    foot CHAR(1));
SELECT*FROM players


CREATE TABLE stadium(
    name VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50),
    capacity INTEGER);
SELECT*FROM stadium


CREATE TABLE teams(
    team_name VARCHAR(50) PRIMARY KEY,
    country VARCHAR(50),
    home_stadium VARCHAR(50));
SELECT*FROM teams


/*1)Count the Total Number of Teams*/
SELECT COUNT(DISTINCT team_name) AS total_teams 
FROM teams;

/*2)Find the Number of Teams per Country*/
SELECT country, COUNT(distinct(team_name)) AS team_count_per_country 
FROM teams 
GROUP BY country 
ORDER BY team_count_per_country DESC ;

/*3)Calculate the Average Team Name Length*/
SELECT AVG(LENGTH(team_name)) AS avg_team_name_length 
FROM teams;

/*4)Calculate the Average Stadium Capacity in Each Country round it off and sort by the total stadiums in the country*/
SELECT country, ROUND(AVG(capacity)) AS avg_capacity, 
COUNT(*) AS total_stadiums 
FROM stadium 
GROUP BY country 
ORDER BY total_stadiums DESC;

/*5)Calculate the Total Goals Scored*/
SELECT COUNT(*) AS total_goals 
FROM goal;

/*6)Find the total teams that have city in their names*/
SELECT COUNT(*) as total_teams_with_city
FROM teams 
WHERE team_name ILIKE '%city%';

/*7)Use Text Functions to Concatenate the Team's Name and Country*/
SELECT CONCAT(team_name, ' - ', country) AS teamName_country 
FROM teams;

/*8) What is the highest attendance recorded in the dataset, and which match (including home and away teams, and date) does it correspond to?*/
SELECT home_team, away_team, date, attendance
FROM matches
WHERE attendance = (SELECT MAX(attendance) FROM matches);

/*9)What is the lowest attendance recorded in the dataset, and which match (including home and away teams, and date) does it correspond to set the criteria as greater than 1 as some matches had 0 attendance because of covid.*/
SELECT match_id, home_team, away_team, date, attendance
FROM matches
WHERE attendance > 1
ORDER BY attendance DESC LIMIT 1;



/*10) Identify the match with the highest total score (sum of home and away team scores) in the dataset. Include the match ID, home and away teams, and the total score.*/
SELECT match_id, home_team, away_team,
       (home_team_score + away_team_score) AS total_score
FROM matches
ORDER BY total_score DESC LIMIT 1;

/*11)Find the total goals scored by each team, distinguishing between home and away goals. Use a CASE WHEN statement to differentiate home and away goals within the subquery*/
SELECT  t.team_name as team_name,
SUM(CASE WHEN m.home_team = t.team_name THEN home_team_score ELSE 0 END)AS home_goals, 
SUM(CASE WHEN m.away_team = t.team_name THEN away_team_score ELSE 0 END)AS home_goals 
FROM teams AS t 
LEFT JOIN matches AS m ON t.team_name=m.home_team OR t.team_name=m.away_team 
GROUP BY t.team_name;
	
/*12) windows function - Rank teams based on their total scored goals (home and away combined) using a window function.In the stadium Old Trafford*/
SELECT team_name, 
RANK() OVER(ORDER BY total_goals DESC) AS RANK
FROM(SELECT team_name, 
     SUM(CASE WHEN matches.home_team=team_name THEN home_team_score ELSE 0 END + 
         CASE WHEN matches.away_team=team_name THEN away_team_score ELSE 0 END)AS total_goals
FROM teams
LEFT JOIN matches 
ON teams.team_name=matches.home_team OR teams.team_name=matches.away_team
WHERE stadium = 'Old Trafford'
GROUP BY team_name)AS ranked_teams

/*13) TOP 5 l players who scored the most goals in Old Trafford, ensuring null values are not included in the result (especially pertinent for cases where a player might not have scored any goals)*/
SELECT p.player_id, p.first_name, p.last_name, COUNT(g.goal_id)AS total_goals
FROM players p
JOIN goal g ON p.player_id=g.pid
JOIN matches m ON g.match_id=m.match_id
WHERE m.stadium='Old Trafford'
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY total_goals DESC LIMIT 5;

/*14)Write a query to list all players along with the total number of goals they have scored. Order the results by the number of goals scored in descending order to easily identify the top 6 scorers*/
SELECT p.player_id, p.first_name, p.last_name, COUNT(g.goal_id)AS total_goals
FROM players p
LEFT JOIN goal g ON p.player_id=g.pid
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY total_goals DESC LIMIT 6;

/*15)Identify the Top Scorer for Each Team - Find the player from each team who has scored the most goals in all matches combined. This question requires joining the Players, Goals, and possibly the Matches tables, and then using a subquery to aggregate goals by players and teams*/
SELECT t.team_name, p.player_id, p.first_name, p.last_name, MAX(p.goals)AS goals
FROM(SELECT player_id, first_name, last_name, team, COUNT(goal_id)AS goals
     FROM players
     LEFT JOIN goal ON players.player_id=goal.pid
     GROUP BY player_id, first_name, last_name, team)AS p
	 JOIN teams t ON p.team = t.team_name
	 GROUP BY t.team_name, p.player_id, p.first_name, p.last_name
	 ORDER BY t.team_name, goals DESC;

/*16)Find the Total Number of Goals Scored in the Latest Season - Calculate the total number of goals scored in the latest season available in the dataset. This question involves using a subquery to first identify the latest season from the Matches table, then summing the goals from the Goals table that occurred in matches from that season*/
SELECT SUM(goal_count)AS total_goals 
FROM(SELECT g.goal_id, m.season, COUNT(g.goal_id)AS goal_count 
     FROM goal g
	 JOIN matches m ON g.match_id=m.match_id
	 WHERE m.season = (select max(season) from matches)
	 GROUP BY g.goal_id, m.season)AS season_goals;

/*17)Find Matches with Above Average Attendance - Retrieve a list of matches that had an attendance higher than the average attendance across all matches. This question requires a subquery to calculate the average attendance first, then use it to filter matches*/
SELECT AVG(attendance) FROM matches ; 
SELECT*FROM matches 
WHERE attendance > (SELECT AVG(attendance) FROM matches);

/*18)Find the Number of Matches Played Each Month - Count how many matches were played in each month across all seasons. This question requires extracting the month from the match dates and grouping the results by this value. as January Feb march*/
SELECT*FROM matches ORDER BY EXTRACT(MONTH FROM date);
SELECT EXTRACT(MONTH FROM date)AS MONTH, COUNT(*)AS matches_played_each_month 
FROM matches 
GROUP BY MONTH
ORDER BY MONTH;
