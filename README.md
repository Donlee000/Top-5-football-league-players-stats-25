## Top football league players' performance stats

### Project Overview 

A project showcasing statistical insights into top football league players from five major leagues, with visualizations highlighting progressive carries, goal contributions, and competition performance."

<img width="1024" height="1536" alt="Footy_leon_top-5_players_states_matrics" src="https://github.com/user-attachments/assets/460af480-cb33-4443-b44d-a5bf564d117e" />


### Data Source
Data Source: The raw data includes player metrics such as progressive carries, expected goals (xG), assists, and goal contributions, extracted and analyzed using SQL queries. The dataset is supplemented by Excel files containing aggregated league and player stats for enhanced analysis and visualization.

### Tools

- Excel - Data Cleanning [Download here](https://fbref.com/en/comps/Big5/Big-5-European-Leagues-Stats)
- SQL Server - Data Analysis [Download here](https://1drv.ms/u/c/29f0e449ed577bcc/EdNOUJgUYplJgc6hKapmcKkBNF9YV3M93rd6TT7hahWsdQ?e=docL3X)
- Power BI - Creating Reports

### Data Cleaning & Preparation

The raw football data underwent a thorough cleaning and preparation process to ensure accuracy and consistency. Key steps included:

1. Removing duplicates and irrelevant columns
2. Handling missing values by imputation or removal
3. Standardizing player names and team identifiers
4. Converting data types for numerical analysis (e.g., casting strings to decimals)
5. Creating calculated fields such as total progressive carries, expected goals (xG), and assists per 90 minutes
6. Aggregating data at player, club, and competition levels to facilitate analysis and visualization

This preprocessing was performed primarily using Excel and SQL queries to prepare a clean dataset suitable for insightful visualizations and reporting

### Exploratory Data Analysis

The exploratory data analysis (EDA) phase involved investigating the cleaned dataset to uncover key trends and insights into player and league performance. The main activities included:

- Identifying top performers across multiple dimensions including progressive carries, goal contributions, and xG overperformance.
- Analyzing competition-level metrics to compare average goals per 90 minutes and performance across the top 5 leagues.
- Visualizing relationships between variables, such as progressive carries versus combined goals and assists, using scatter plots and line charts.
- Segmenting players by age brackets and positions to explore productivity differences.
- Detecting any anomalies or outliers in the data to ensure robustness of the analysis.

The insights gained from EDA informed the design of targeted visualizations and helped highlight the most impactful performance factors.

<img width="1024" height="1536" alt="footy_statistic_top-5_league" src="https://github.com/user-attachments/assets/daf70aae-fe52-4780-afe9-79bbd3b19c26" />


### Data Analysis

My analysis code/features i worked with:

1. Who are the top 10 players by non-penalty expected goal contributions?
```sql
SELECT TOP 10
     Player
   , (npxG + xAG) AS expected_contrib
FROM dbo.players_states
ORDER BY expected_contrib DESC;
```

2. Which competition has the highest average expected goals per 90 minutes?
```sql
SELECT
    Comp,
    ROUND(
      AVG(TRY_CAST(xG_90 AS DECIMAL(10,2))),
      2
    ) AS avg_xG_per_90
FROM dbo.players_states
GROUP BY Comp
ORDER BY avg_xG_per_90 DESC;
```

3. How do goals per 90 (Gls_90) vary by player position?
```sql
SELECT
  Pos,
  ROUND(
    AVG( TRY_CAST(Gls_90 AS DECIMAL(10,2)) ),
    2
  ) AS avg_goals_per_90
FROM dbo.players_states
GROUP BY Pos
ORDER BY avg_goals_per_90 DESC;
```

4. Which age bracket is most productive in assists per 90?
```sql
SELECT
  CASE 
    WHEN Age < 23             THEN '<23'
    WHEN Age BETWEEN 23 AND 26 THEN '23–26'
    WHEN Age BETWEEN 27 AND 30 THEN '27–30'
    ELSE '31+'
  END
    AS age_bracket,
  ROUND(
    AVG( TRY_CAST(Ast_90 AS DECIMAL(10,2)) ),
    2
  ) AS avg_assists_per_90
FROM dbo.players_states
GROUP BY
  CASE 
    WHEN Age < 23             THEN '<23'
    WHEN Age BETWEEN 23 AND 26 THEN '23–26'
    WHEN Age BETWEEN 27 AND 30 THEN '27–30'
    ELSE '31+'
  END
ORDER BY
  age_bracket;
```

5. What’s the relationship between progressive carries and goals + assists per 90?
```sql
SELECT
  Player,
  TRY_CAST(PrgC    AS DECIMAL(10,2)) AS progressive_carries,
  TRY_CAST([G+A_90] AS DECIMAL(10,2)) AS goals_assists_per_90
FROM dbo.players_states
WHERE
  TRY_CAST(PrgC     AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST([G+A_90] AS DECIMAL(10,2)) IS NOT NULL;
```


6. Give me top 20 players who has the best progressive carries and goals + assists per 90?
```sql
SELECT TOP 20
  Player,
  TRY_CAST(PrgC    AS DECIMAL(10,2))  AS progressive_carries,
  TRY_CAST([G+A_90] AS DECIMAL(10,2)) AS goals_assists_per_90
FROM dbo.players_states
WHERE
  TRY_CAST(PrgC     AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST([G+A_90] AS DECIMAL(10,2)) IS NOT NULL
ORDER BY
  progressive_carries    DESC,
  goals_assists_per_90   DESC;
```

7. Top 10 clubs by total goals scored
```sql
SELECT TOP 10
  Squad,
  SUM(TRY_CAST(Goal AS INT)) AS total_goals
FROM dbo.players_states
GROUP BY Squad
ORDER BY total_goals DESC;
```

8. Top 10 players by non-penalty expected goals (npxG)
```sql
SELECT TOP 10
  Player,
  TRY_CAST(npxG AS DECIMAL(10,2)) AS non_penalty_xG
FROM dbo.players_states
WHERE TRY_CAST(npxG AS DECIMAL(10,2)) IS NOT NULL
ORDER BY non_penalty_xG DESC;
```

9. Top 10 players by expected assists (xAG)
```sql
SELECT TOP 10
  Player,
  TRY_CAST(xAG AS DECIMAL(10,2)) AS expected_assists
FROM dbo.players_states
WHERE TRY_CAST(xAG AS DECIMAL(10,2)) IS NOT NULL
ORDER BY expected_assists DESC;
```

10. Top 10 over-performers: goals minus xG
```sql
SELECT TOP 10
  Player,
  TRY_CAST(Goal AS INT) - TRY_CAST(xG AS DECIMAL(10,2)) AS xG_overperformance
FROM dbo.players_states
WHERE
  TRY_CAST(Goal AS INT)       IS NOT NULL
  AND TRY_CAST(xG   AS DECIMAL(10,2)) IS NOT NULL
ORDER BY xG_overperformance DESC;
```

11. Card discipline by competition (total yellows and reds)
```sql
SELECT
  Comp,
  SUM(TRY_CAST(CrdY AS INT)) AS total_yellow_cards,
  SUM(TRY_CAST(CrdR AS INT)) AS total_red_cards
FROM dbo.players_states
GROUP BY Comp
ORDER BY total_yellow_cards DESC;
```

12. Squads ranked by total progressive passes
```sql
SELECT
  Squad,
  SUM(TRY_CAST(PrgP AS DECIMAL(10,2))) AS total_progressive_passes
FROM dbo.players_states
WHERE TRY_CAST(PrgP AS DECIMAL(10,2)) IS NOT NULL
GROUP BY Squad
ORDER BY total_progressive_passes DESC;
```

13. Top 10 players by non-penalty expected goal contributions per 90
```sql
SELECT TOP 10
  Player,
  TRY_CAST([npxG+xAG_90] AS DECIMAL(10,2)) AS npxG_plus_xAG_per_90
FROM dbo.players_states
WHERE TRY_CAST([npxG+xAG_90] AS DECIMAL(10,2)) IS NOT NULL
ORDER BY npxG_plus_xAG_per_90 DESC;
```

14. Top 10 players by progressive runs
```sql
SELECT TOP 10
  Player,
  TRY_CAST(PrgR AS DECIMAL(10,2)) AS progressive_runs
FROM dbo.players_states
WHERE TRY_CAST(PrgR AS DECIMAL(10,2)) IS NOT NULL
ORDER BY progressive_runs DESC;
```
### Result and Findings 

The analysis of top football league players across the five major European competitions revealed several key insights:

1. Jeremy Doku leads in progressive carries, demonstrating exceptional ability in advancing the ball and creating offensive opportunities.Vinicius Junior, Mohamed Salah, Noni Madueke, Kylian Mbappe, and Kaoru Mitoma also rank highly, showcasing their significant contributions to their teams’ offensive play.
2. The top clubs by total goals scored align with traditional leading the way is Fc Barcelona, Bayern Munich, PSG, Real Madrid, Manchester City and Liverpool, reflecting their consistent offensive dominance.
3. The Bundesliga leads in xG overperformance, suggesting teams and players in this league often outperform expected goal metrics, indicating high efficiency in finishing chances.
4. Analysis of goals per 90 minutes by competition shows La Liga as the most prolific league in terms of goal scoring per match
5. Age bracket analysis highlights that players aged 23–26 tend to have the highest average assists per 90, indicating a peak period for playmaking ability.
6. There is a strong positive relationship between progressive carries and combined goals plus assists, emphasizing the importance of ball progression in overall offensive productivity.

### Recommendations

I recommend the following action that could be taken:

- Teams should emphasize developing players' progressive carrying skills, as this metric correlates strongly with goal involvement and overall attacking effectiveness.
- Scouting efforts might prioritize players in the 23–26 age bracket, who statistically offer peak playmaking contributions.
- Leagues like Bundesliga could be studied further to understand the factors driving xG overperformance and applied in training to improve finishing efficiency.
- Clubs should consider integrating advanced metrics like progressive carries and xG into regular performance evaluations to optimize player development and tactical strategies.
- Further research could explore defensive metrics and transition play to provide a more holistic understanding of player impact beyond offensive statistics.

### Limitations

- Contextual Factors Not Captured: The dataset focuses primarily on offensive metrics and does not fully account for contextual factors such as team tactics, player roles, or match situations, which may influence player performance and stats.

### References

1. fbref. Football States
2. [Big 5 European Leagues Stats](https://fbref.com/en/comps/Big5/Big-5-European-Leagues-Stats)
