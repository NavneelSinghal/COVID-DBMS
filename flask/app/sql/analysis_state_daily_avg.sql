PREPARE analysis_state_daily_avg(int,date,date,text,text) AS
SELECT *
FROM
    (SELECT state AS "Name",
            state_id,
            date_1 AS "Date",
            round(avg(confirmed) OVER (PARTITION BY state
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Confirmed Cases",
            round(avg(recovered) OVER (PARTITION BY state
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Recovered Cases",
            round(avg(active) OVER (PARTITION BY state
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Active Cases",
            round(avg(deceased) OVER (PARTITION BY state
                                      ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Deceased Cases",
            round(avg(other) OVER (PARTITION BY state
                                   ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Other Cases",
            round(avg(tested) OVER (PARTITION BY state
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Tested",
            round(coalesce(avg(total_doses_administered) OVER (PARTITION BY state
                                                               ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),0),2) AS "Total Vaccine Doses",
            round(round(avg(active) OVER (PARTITION BY state
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (PARTITION BY state
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Active Ratio",
            round(round(avg(recovered) OVER (PARTITION BY state
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (PARTITION BY state
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Recovery Ratio",
            round(round(avg(deceased) OVER (PARTITION BY state
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (PARTITION BY state
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Fatality Ratio",
            round(round(avg(confirmed) OVER (PARTITION BY state
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(tested) OVER (PARTITION BY state
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Test Positivity Ratio"

     FROM
         (SELECT state,
                 state_id,
                 date_1,
                 confirmed,
                 recovered,
                 active,
                 deceased,
                 other,
                 tested,
                 total_doses_administered
          FROM
              (SELECT *
               FROM
                   (SELECT state_daily.state_id,
                           state_daily.date_1,
                           confirmed,
                           recovered,
                           deceased,
                           other,
                           tested,
                           confirmed-recovered-deceased-other AS active,
                           total_doses_administered
                    FROM state_daily
                    LEFT OUTER JOIN vaccine_daily ON state_daily.date_1=vaccine_daily.date_1
                    AND state_daily.state_id=vaccine_daily.state_id) AS temp1
               NATURAL JOIN state_and_ut) AS temp2) AS temp3
     WHERE state_id=$1
         AND date_1>=$2
         AND date_1<=$3 ) AS temp4
ORDER BY CASE
             WHEN $4='Confirmed Cases' and $5= 'ASC' THEN "Confirmed Cases"
         END,
         CASE
             WHEN $4='Confirmed Cases' and $5= 'DSC' THEN "Confirmed Cases" 
         END desc,
         CASE
             WHEN $4='Recovered Cases' and $5= 'ASC' THEN "Recovered Cases"
         END,
         CASE
             WHEN $4='Recovered Cases' and $5= 'DSC' THEN "Recovered Cases" 
         END desc,
         CASE
             WHEN $4='Deceased Cases' and $5= 'ASC' THEN "Deceased Cases"
         END,
         CASE
             WHEN $4='Deceased Cases' and $5= 'DSC' THEN "Deceased Cases" 
         END desc,
         CASE
             WHEN $4='Active Cases' and $5= 'ASC' THEN "Active Cases"
         END,
         CASE
             WHEN $4='Active Cases' and $5= 'DSC' THEN "Active Cases" 
         END desc,
         CASE
             WHEN $4='Other Cases' and $5= 'ASC' THEN "Other Cases"
         END,
         CASE
             WHEN $4='Other Cases' and $5= 'DSC' THEN "Other Cases" 
         END desc,
         CASE
             WHEN $4='Tested' and $5= 'ASC' THEN "Tested"
         END,
         CASE
             WHEN $4='Tested' and $5= 'DSC' THEN "Tested" 
         END desc,
         CASE
             WHEN $4='Total Vaccine Doses' and $5= 'ASC' THEN "Total Vaccine Doses"
         END,
         CASE
             WHEN $4='Total Vaccine Doses' and $5= 'DSC' THEN "Total Vaccine Doses" 
         END desc
         ,
         CASE
             WHEN $4='Active Ratio' and $5='ASC' THEN "Active Ratio"
         END,
         CASE
             WHEN $4='Active Ratio' and $5='DSC' THEN "Active Ratio" 
         END desc,
         CASE
             WHEN $4='Recovery Ratio' and $5= 'ASC' THEN "Recovery Ratio"
         END,
         CASE
             WHEN $4='Recovery Ratio' and $5= 'DSC' THEN "Recovery Ratio" 
         END desc,
         CASE
             WHEN $4='Test Positivity Ratio' and $5='ASC' THEN "Test Positivity Ratio"
         END,
         CASE
             WHEN $4='Test Positivity Ratio' and $5='DSC' THEN "Test Positivity Ratio" 
         END desc,
         CASE
             WHEN $4='Fatality Ratio' and $5= 'ASC' THEN "Fatality Ratio"
         END,
         CASE
             WHEN $4='Fatality Ratio' and $5= 'DSC' THEN "Fatality Ratio" 
         END desc
LIMIT 3;
EXECUTE analysis_state_daily_avg(%s, %s, %s, %s,%s);
-- EXECUTE analysis_state_daily_avg(20,'01-05-2020','01-11-2020','Active Ratio','DSC');
-- DEALLOCATE analysis_state_daily_avg;
