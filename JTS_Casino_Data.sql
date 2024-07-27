-- July 4th Slots Promotion for JTS Casino
-- Note : Dataset was built using 2 seperate sets of queries. One for promotional data and another for pre promotional data to make my comparison.

-- Step 1. Subqueries to pull the total promotional bonus for each customer segment

WITH premium_status_bonus AS (
    SELECT
        playerid,
        MAX(bonus_awarded) AS bonus_awarded
    FROM
        casino.wager_data
    WHERE
        last_year_customer_type = 'premium'
    GROUP BY
        playerid
),
high_value_tier_bonus AS (
    SELECT
        playerid,
        MAX(bonus_awarded) AS bonus_awarded
    FROM
        casino.wager_data
    WHERE
        last_year_customer_type = 'high'
    GROUP BY
        playerid
),
medium_value_tier_bonus AS (
    SELECT
        playerid,
        MAX(bonus_awarded) AS bonus_awarded
    FROM
        casino.wager_data
    WHERE
        last_year_customer_type = 'medium'
    GROUP BY
        playerid
),
low_value_tier_bonus AS (
    SELECT
        playerid,
        MAX(bonus_awarded) AS bonus_awarded
    FROM
        casino.wager_data
    WHERE
        last_year_customer_type = 'low'
    GROUP BY
        playerid
)

 -- Step 2. Aggregated statistics for each last_year_customer_type

SELECT
    'Premium Value Tier' AS group_label,
    COUNT(*) AS group_count,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'premium' THEN ggr ELSE 0 END) AS net_ggr,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'premium' THEN handle ELSE 0 END) AS total_handle,
    COALESCE((SELECT SUM(bonus_awarded) FROM premium_status_bonus), 0) AS total_bonus_awarded
FROM
    casino.wager_data
WHERE
    last_year_customer_type = 'premium'

UNION ALL

-- Step 3. Combining all relevant data using "UNION ALL"

SELECT
    'High Value Tier' AS group_label,
    COUNT(*) AS group_count,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'high' THEN ggr ELSE 0 END) AS net_ggr,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'high' THEN handle ELSE 0 END) AS total_handle,
    COALESCE((SELECT SUM(bonus_awarded) FROM high_value_tier_bonus), 0) AS total_bonus_awarded
FROM
    casino.wager_data
WHERE
    last_year_customer_type = 'high'

UNION ALL

SELECT
    'Medium Value Tier' AS group_label,
    COUNT(*) AS group_count,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'medium' THEN ggr ELSE 0 END) AS net_ggr,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'medium' THEN handle ELSE 0 END) AS total_handle,
    COALESCE((SELECT SUM(bonus_awarded) FROM medium_value_tier_bonus), 0) AS total_bonus_awarded
FROM
    casino.wager_data
WHERE
    last_year_customer_type = 'medium'

UNION ALL

SELECT
    'Low Value Tier' AS group_label,
    COUNT(*) AS group_count,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'low' THEN ggr ELSE 0 END) AS net_ggr,
    SUM(CASE WHEN Is_Active = 1 AND last_year_customer_type = 'low' THEN handle ELSE 0 END) AS total_handle,
    COALESCE((SELECT SUM(bonus_awarded) FROM low_value_tier_bonus), 0) AS total_bonus_awarded
FROM
    casino.wager_data
WHERE
    last_year_customer_type = 'low';
