
-- 1. Project Overview

-- This project aims to analyze and predict fraudulent transaction trends 
-- from Wells Fargo to identify high-risk factors and develop actionable insights. By leveraging historical transaction data, the project will uncover 
-- patterns in fraudulent activities, analyze correlations with socioeconomic factors, and forecast future fraud trends to aid proactive mitigation efforts.


-- Creating a new dataset to save query time 

-- Here I am Aggregating the dataset to include the customer amount by month by category. 
-- Including all relevant information of each user....

SELECT 
    CONCAT(first, ' ', last) AS full_name,
    DATE_FORMAT(trans_date_trans_time, '%Y-%m') AS month_year,
    category,
    gender,
    state,
    street,
    city,
    zip,
    lat,
    `long`,
    is_fraud,
    dob,
    SUM(amt) AS total_amt
FROM 
    `Customer_Fraud`.`credit_card_transactions`
GROUP BY 
    full_name, month_year, category, gender,state, street, city, zip, lat, `long`, is_fraud, dob
    -- , is_fraud, dob
ORDER BY 
    full_name, month_year ASC
LIMIT 100000;


