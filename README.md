# ⚽ UEFA Competition Analysis (PostgreSQL Project)

## 📊 Project Overview

This project presents a comprehensive SQL-based data analytics solution built on **PostgreSQL** to analyze historical data from UEFA football competitions. The dataset includes detailed information on matches, players, teams, goals, and stadiums. Through carefully crafted SQL queries, the project uncovers meaningful insights such as top scorers, team rankings, attendance trends, and performance metrics.

---

## 🛠 Technologies Used

- **PostgreSQL**  
- **pgAdmin / DBeaver**  
- **CSV Files (Relational Tables)**  
- **SQL Features:** Window Functions, Joins, Subqueries, Aggregates

---

## 📁 Dataset Overview

The analysis is based on the following tables:

- `matches` – Match details including date, teams involved, score, and stadium
- `players` – Player data including ID, name, age, nationality, position
- `teams` – Team records including country and performance
- `goals` – Goal event logs with player and match references
- `stadiums` – Information on location and capacity of stadiums

> *Sample datasets (CSV format) are available in the `data/` folder.*

---

## 🔍 Key Insights Derived

- Top scorers across seasons
- Team rankings based on match outcomes
- Attendance trends and average attendance per team/stadium
- Highest goal-scoring matches and players
- Match statistics using advanced SQL **window functions**
- Average goals per team and per match

---

## 🚀 How to Use

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/uefa-sql-analysis.git
   cd uefa-sql-analysis
