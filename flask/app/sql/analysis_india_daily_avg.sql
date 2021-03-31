PREPARE analysis_india_daily_avg(date,date,text) AS
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
                                                               ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),0),2) AS "Total Vaccine Doses"
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
             WHEN $3='Confirmed Cases' THEN "Confirmed Cases"
         END,
         CASE
             WHEN $3='Recovered Cases' THEN "Recovered Cases"
         END,
         CASE
             WHEN $3='Deceased Cases' THEN "Deceased Cases"
         END,
         CASE
             WHEN $3='Active Cases' THEN "Active Cases"
         END,
         CASE
             WHEN $3='Other Cases' THEN "Other Cases"
         END,
         CASE
             WHEN $3='Tested' THEN "Tested"
         END,
         CASE
             WHEN $3='Total Vaccine Doses' THEN "Total Vaccine Doses"
         END -- Case when $3='Active Ratio'  then "Active Ratio" end,
-- Case when $3='Recovery Ratio'  then "Recovery Ratio" end,
-- Case when $3='Test Positivity Ratio'  then "Test Positivity Ratio" end,
-- Case when $3='Fatality Ratio'  then "Fatality Ratio" end,
LIMIT 1;

EXECUTE analysis_india_daily_avg(%s, %s, %s);
--EXECUTE analysis_india_daily_avg('01-05-2020','01-11-2020','Active Cases');
--DEALLOCATE analysis_india_daily_avg;
