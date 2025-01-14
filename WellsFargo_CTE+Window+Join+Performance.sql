
-- Project Overview

-- This project aims to analyze and predict fraudulent transaction trends 
-- from Wells Fargo to identify high-risk factors and develop actionable insights. By leveraging historical transaction data, the project will uncover 
-- patterns in fraudulent activities, analyze correlations with socioeconomic factors, and forecast future fraud trends to aid proactive mitigation efforts.

-- Correlated Subquery

-- Average Load Time 16.5 seconds

with athousa as 
(select * from `Customer_Fraud`.`credit_card_transactions` cf order by amt asc  limit 10000) 

select concat(first, ' ', last) as full_name, amt as amount, state
from athousa ct
where amt > (select avg(cf.amt) 
             from athousa cf 
             where cf.state = ct.state)
order by 3 desc

-- 	CTE + JOIN

-- Average Load Time 0.316 seconds

with athousa as 
(select * from `Customer_Fraud`.`credit_card_transactions` cf order by amt asc  limit 10000) ,

state_avg as (
    select state, avg(amt) as state_amount
    from athousa
    group by 1)
select concat(first, ' ', last) as full_name, amt, c.state
from athousa c
join state_avg on c.state = state_avg.state
where amt > state_amount and amt is not null
order by 3 desc


-- Window Function 

-- Average Load Time 0.216 seconds


WITH athousa AS (
    SELECT * 
    FROM `Customer_Fraud`.`credit_card_transactions` 
    ORDER BY amt ASC 
    LIMIT 10000
),
cte AS (
    SELECT 
        CONCAT(first, ' ', last) AS full_name, 
        amt AS amount,
        c.state,
        AVG(amt) OVER (PARTITION BY c.state ORDER BY city DESC) AS avg_amount
    FROM athousa c
)
SELECT full_name, amount, state
FROM cte
WHERE amount > avg_amount
order by 3 desc





