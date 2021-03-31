PREPARE analysis_india_daily_daily(date,date,text) AS
SELECT *
FROM
    (SELECT date_1 AS "Date",
            confirmed AS "Confirmed Cases",
            recovered AS "Recovered Cases",
            active AS "Active Cases",
            deceased AS "Deceased Cases",
            other AS "Other Cases",
            tested AS "Tested",
            coalesce(total_doses_administered,0) AS "Total Vaccine Doses"
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
         AND date_1<=$2) AS temp4
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

EXECUTE analysis_india_daily_daily(%s,%s,%s);

--execute analysis_india_daily_daily('01-05-2020','01-11-2020','Active Cases');
--deallocate analysis_india_daily_daily;
