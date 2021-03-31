PREPARE analysis_india_daily_avg(date,date,text,text) AS
SELECT *
FROM
    (SELECT date_1 AS "Date",
            round(avg(confirmed) OVER (
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW), 2) AS "Confirmed Cases",
            round(avg(recovered) OVER (
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW), 2) AS "Recovered Cases",
            round(avg(active) OVER (
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW), 2) AS "Active Cases",
            round(avg(deceased) OVER (
                                      ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW), 2) AS "Deceased Cases",
            round(avg(other) OVER (
                                   ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW), 2) AS "Other Cases",
            round(avg(tested) OVER (
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW), 2) AS "Tested",
            round(coalesce(avg(total_doses_administered) OVER (
                                                               ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),0),2) AS "Total Vaccine Doses",
            round((avg(active) OVER (
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW)/nullif(avg(confirmed) OVER (
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),0)),2) as "Active Ratio",
            round(round(avg(recovered) OVER (
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Recovery Ratio",
            round(round(avg(deceased) OVER (
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Fatality Ratio",
            round(round(avg(confirmed) OVER (
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(tested) OVER (
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Test Positivity Ratio"


     FROM
         (SELECT date_1,
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
                   (SELECT india_daily.date_1,
                           confirmed,
                           recovered,
                           deceased,
                           other,
                           tested,
                           active,
                           coalesce(total_doses_administered,0) AS total_doses_administered
                    FROM india_daily
                    LEFT OUTER JOIN india_vaccine_daily ON india_daily.date_1=india_vaccine_daily.date_1) AS temp1,
                    india_population) AS temp2) AS temp3
     WHERE date_1>=$1
         AND date_1<=$2 ) AS temp4
ORDER BY CASE
             WHEN $3='Confirmed Cases' and $4= 'ASC' THEN "Confirmed Cases"
         END,
         CASE
             WHEN $3='Confirmed Cases' and $4= 'DSC' THEN "Confirmed Cases" 
         END desc,
         CASE
             WHEN $3='Recovered Cases' and $4= 'ASC' THEN "Recovered Cases"
         END,
         CASE
             WHEN $3='Recovered Cases' and $4= 'DSC' THEN "Recovered Cases" 
         END desc,
         CASE
             WHEN $3='Deceased Cases' and $4= 'ASC' THEN "Deceased Cases"
         END,
         CASE
             WHEN $3='Deceased Cases' and $4= 'DSC' THEN "Deceased Cases" 
         END desc,
         CASE
             WHEN $3='Active Cases' and $4= 'ASC' THEN "Active Cases"
         END,
         CASE
             WHEN $3='Active Cases' and $4= 'DSC' THEN "Active Cases" 
         END desc,
         CASE
             WHEN $3='Other Cases' and $4= 'ASC' THEN "Other Cases"
         END,
         CASE
             WHEN $3='Other Cases' and $4= 'DSC' THEN "Other Cases" 
         END desc,
         CASE
             WHEN $3='Tested' and $4= 'ASC' THEN "Tested"
         END,
         CASE
             WHEN $3='Tested' and $4= 'DSC' THEN "Tested" 
         END desc,
         CASE
             WHEN $3='Total Vaccine Doses' and $4= 'ASC' THEN "Total Vaccine Doses"
         END,
         CASE
             WHEN $3='Total Vaccine Doses' and $4= 'DSC' THEN "Total Vaccine Doses" 
         END desc
         ,
         CASE
             WHEN $3='Active Ratio' and $4='ASC' THEN "Active Ratio"
         END,
         CASE
             WHEN $3='Active Ratio' and $4='DSC' THEN "Active Ratio" 
         END desc,
         CASE
             WHEN $3='Recovery Ratio' and $4= 'ASC' THEN "Recovery Ratio"
         END,
         CASE
             WHEN $3='Recovery Ratio' and $4= 'DSC' THEN "Recovery Ratio" 
         END desc,
         CASE
             WHEN $3='Test Positivity Ratio' and $4='ASC' THEN "Test Positivity Ratio"
         END,
         CASE
             WHEN $3='Test Positivity Ratio' and $4='DSC' THEN "Test Positivity Ratio" 
         END desc,
         CASE
             WHEN $3='Fatality Ratio' and $4= 'ASC' THEN "Fatality Ratio"
         END,
         CASE
             WHEN $3='Fatality Ratio' and $4= 'DSC' THEN "Fatality Ratio" 
         END desc
LIMIT 3;

EXECUTE analysis_india_daily_avg(%s, %s, %s,%s);
-- EXECUTE analysis_india_daily_avg('01-05-2020','01-11-2020','Active Ratio','ASC');
-- DEALLOCATE analysis_india_daily_avg;
