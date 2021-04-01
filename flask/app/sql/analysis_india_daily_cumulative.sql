PREPARE analysis_india_daily_cumulative(date,date,text,text) AS
SELECT *
FROM
    (SELECT date_1 AS "Date",
            cum_confirmed AS "Confirmed Cases",
            cum_recovered AS "Recovered Cases",
            active AS "Active Cases",
            cum_deceased AS "Deceased Cases",
            cum_other AS "Other Cases",
            cum_tested AS "Tested",
            coalesce(cum_total_doses_administered,0) AS "Total Vaccine Doses",
            round(a1,2) AS "Active Ratio",
            round(a2,2) AS "Recovery Ratio",
            round(a3,2) AS "Fatality Ratio",
            round(a4,2) AS "Test Positivity Ratio"
     FROM
         (SELECT date_1,
                 cum_confirmed,
                 cum_recovered,
                 active,
                 cum_deceased,
                 cum_other,
                 cum_tested,
                 cum_total_doses_administered,
                 active/cum_confirmed AS a1,
                 cum_recovered/cum_confirmed AS a2,
                 cum_deceased/cum_confirmed AS a3,
                 cum_confirmed/cum_tested AS a4,
                 cum_confirmed/population*100000 AS a5,
                 cum_recovered/population*100000 AS a6,
                 active/population*100000 AS a7,
                 cum_deceased/population*100000 AS a8,
                 cum_other/population*100000 AS a9,
                 cum_tested/population*100000 AS a10,
                 cum_total_doses_administered/population*100000 AS a11,
                 population
          FROM
              (SELECT *
               FROM
                   (SELECT india_cumulative.date_1,
                           cum_confirmed,
                           cum_recovered,
                           active,
                           cum_deceased,
                           cum_other,
                           coalesce(cum_total_doses_administered,0) AS cum_total_doses_administered,
                           cum_tested
                    FROM india_cumulative
                    LEFT OUTER JOIN india_vaccine_cumulative ON india_cumulative.date_1=india_vaccine_cumulative.date_1) AS temp1,
                    india_population) AS temp2) AS temp3
     WHERE date_1>=$1
         AND date_1<=$2) AS temp4
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
         END desc,
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

EXECUTE analysis_india_daily_cumulative(%s, %s, %s,%s);
-- EXECUTE analysis_india_daily_cumulative('25-05-2020','21-03-2021','Active Ratio','DSC');
-- DEALLOCATE analysis_india_daily_cumulative;
