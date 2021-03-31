PREPARE india_daily_cumulative(int) AS
SELECT date_1 AS "Date",
       cum_confirmed AS "Confirmed Cases",
       cum_recovered AS "Recovered Cases",
       active AS "Active Cases",
       cum_deceased AS "Deceased Cases",
       cum_other AS "Other Cases",
       cum_tested AS "Tested",
       coalesce(cum_total_doses_administered,0) AS "Total Vaccine Doses",
       round(a1,2) AS "Active Ratio",
       round(a2,2) AS "Recovery Ratio",
       round(a3,2) AS "Fatality  Ratio",
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
         (SELECT * from
              (SELECT india_cumulative.date_1,cum_confirmed,cum_recovered,active,cum_deceased,cum_other,cum_total_doses_administered,cum_tested
               FROM india_cumulative
               LEFT OUTER JOIN india_vaccine_cumulative ON india_cumulative.date_1=india_vaccine_cumulative.date_1) AS temp1,
                   india_population) AS temp2) AS temp3
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE india_daily_cumulative(%s);
--DEALLOCATE india_daily_cumulative;
