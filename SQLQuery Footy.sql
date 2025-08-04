-- Who are the top 10 players by non-penalty expected goal contributions?

SELECT TOP 10
     Player
   , (npxG + xAG) AS expected_contrib
FROM dbo.players_states
ORDER BY expected_contrib DESC;

SELECT
     Player
   , (npxG + xAG) AS expected_contrib
FROM dbo.players_states
ORDER BY expected_contrib DESC
  OFFSET 0 ROWS
  FETCH NEXT 10 ROWS ONLY;

  -- Which competition has the highest average expected goals per 90 minutes?

SELECT
    Comp,
    ROUND(
      AVG(TRY_CAST(xG_90 AS DECIMAL(10,2))),
      2
    ) AS avg_xG_per_90
FROM dbo.players_states
GROUP BY Comp
ORDER BY avg_xG_per_90 DESC;

--How do goals per 90 (Gls_90) vary by player position?

SELECT
  Pos,
  ROUND(
    AVG( TRY_CAST(Gls_90 AS DECIMAL(10,2)) ),
    2
  ) AS avg_goals_per_90
FROM dbo.players_states
GROUP BY Pos
ORDER BY avg_goals_per_90 DESC;

-- Which age bracket is most productive in assists per 90?

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

  -- What’s the relationship between progressive carries and goals + assists per 90?

  SELECT
  Player,
  TRY_CAST(PrgC    AS DECIMAL(10,2)) AS progressive_carries,
  TRY_CAST([G+A_90] AS DECIMAL(10,2)) AS goals_assists_per_90
FROM dbo.players_states
WHERE
  TRY_CAST(PrgC     AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST([G+A_90] AS DECIMAL(10,2)) IS NOT NULL;

 -- Give me top 20 players who has the best progressive carries and goals + assists per 90?

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

-- Top 10 clubs by total goals scored

SELECT TOP 10
  Squad,
  SUM(TRY_CAST(Goal AS INT)) AS total_goals
FROM dbo.players_states
GROUP BY Squad
ORDER BY total_goals DESC;

-- Top 10 players by non-penalty expected goals (npxG)

SELECT TOP 10
  Player,
  TRY_CAST(npxG AS DECIMAL(10,2)) AS non_penalty_xG
FROM dbo.players_states
WHERE TRY_CAST(npxG AS DECIMAL(10,2)) IS NOT NULL
ORDER BY non_penalty_xG DESC;

SELECT TOP 20
  Player,
  TRY_CAST(npxG AS DECIMAL(10,2)) AS non_penalty_xG
FROM dbo.players_states
WHERE TRY_CAST(npxG AS DECIMAL(10,2)) IS NOT NULL
ORDER BY non_penalty_xG DESC;

-- Top 10 players by expected assists (xAG)

SELECT TOP 10
  Player,
  TRY_CAST(xAG AS DECIMAL(10,2)) AS expected_assists
FROM dbo.players_states
WHERE TRY_CAST(xAG AS DECIMAL(10,2)) IS NOT NULL
ORDER BY expected_assists DESC;

-- Top 10 over-performers: goals minus xG

SELECT TOP 10
  Player,
  TRY_CAST(Goal AS INT) - TRY_CAST(xG AS DECIMAL(10,2)) AS xG_overperformance
FROM dbo.players_states
WHERE
  TRY_CAST(Goal AS INT)       IS NOT NULL
  AND TRY_CAST(xG   AS DECIMAL(10,2)) IS NOT NULL
ORDER BY xG_overperformance DESC;

-- Card discipline by competition (total yellows and reds)

SELECT
  Comp,
  SUM(TRY_CAST(CrdY AS INT)) AS total_yellow_cards,
  SUM(TRY_CAST(CrdR AS INT)) AS total_red_cards
FROM dbo.players_states
GROUP BY Comp
ORDER BY total_yellow_cards DESC;

-- Squads ranked by total progressive passes

SELECT
  Squad,
  SUM(TRY_CAST(PrgP AS DECIMAL(10,2))) AS total_progressive_passes
FROM dbo.players_states
WHERE TRY_CAST(PrgP AS DECIMAL(10,2)) IS NOT NULL
GROUP BY Squad
ORDER BY total_progressive_passes DESC;

-- Top 10 players by non-penalty expected goal contributions per 90

SELECT TOP 10
  Player,
  TRY_CAST([npxG+xAG_90] AS DECIMAL(10,2)) AS npxG_plus_xAG_per_90
FROM dbo.players_states
WHERE TRY_CAST([npxG+xAG_90] AS DECIMAL(10,2)) IS NOT NULL
ORDER BY npxG_plus_xAG_per_90 DESC;

 -- Top 10 players by progressive runs

SELECT TOP 10
  Player,
  TRY_CAST(PrgR AS DECIMAL(10,2)) AS progressive_runs
FROM dbo.players_states
WHERE TRY_CAST(PrgR AS DECIMAL(10,2)) IS NOT NULL
ORDER BY progressive_runs DESC;

