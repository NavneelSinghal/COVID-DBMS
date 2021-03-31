PREPARE state_summary(date,date,int) AS
SELECT state AS "Name",
       cum_confirmed AS "Confirmed Cases",
       cum_recovered AS "Recovered Cases",
       active AS "Active Cases",
       cum_deceased AS "Deceased Cases",
       cum_other AS "Other Cases",
       cum_tested AS "Tested",
       coalesce(cum_total_doses_administered,0) AS "Total Vaccine Doses",
       round(a1,2) AS "Active Ratio",
       round(a2,2) AS "Recovery Ratio",
       round(a3,2) AS "Case Fatality  Ratio",
       round(a4,2) AS "Test Positivity Ratio",
       round(a5,2) AS "Confirmed Per lakh",
       round(a6,2) AS "Recovered per lakh",
       round(a7,2) AS "Active per lakh",
       round(a8,2) AS "Deceased per lakh",
       round(a9,2) AS "Other per lakh",
       round(a10,2) AS "Tested per lakh",
       round(coalesce(a11,0),2) AS "Total Vaccine Doses per lakh",
       population AS "Population"
FROM
    (SELECT date_1,
            state,
            cum_confirmed,
            cum_recovered,
            cum_confirmed-cum_recovered-cum_deceased-cum_other AS active,
            cum_deceased,
            cum_other,
            cum_tested,
            cum_total_doses_administered,
            (cum_confirmed-cum_recovered-cum_deceased-cum_other)/nullif(cum_confirmed,0) AS a1,
            cum_recovered/nullif(cum_confirmed,0) AS a2,
            cum_deceased/nullif(cum_confirmed,0) AS a3,
            cum_confirmed/nullif(cum_tested,0) AS a4,
            cum_confirmed/nullif(population,0)*100000 AS a5,
            cum_recovered/nullif(population,0)*100000 AS a6,
            (cum_confirmed-cum_recovered-cum_deceased-cum_other)/nullif(population,0)*100000 AS a7,
            cum_deceased/nullif(population,0)*100000 AS a8,
            cum_other/nullif(population,0)*100000 AS a9,
            cum_tested/nullif(population,0)*100000 AS a10,
            cum_total_doses_administered/nullif(population,0)*100000 AS a11,
            population
     FROM
         (SELECT state,
                 date_1,
                 state_id,
                 cum_confirmed-lag(cum_confirmed) over(
                                                       ORDER BY state_id,date_1) AS cum_confirmed,
                 cum_recovered-lag(cum_recovered) over(
                                                       ORDER BY state_id,date_1) AS cum_recovered,
                 cum_deceased-lag(cum_deceased) over(
                                                     ORDER BY state_id,date_1) AS cum_deceased,
                 cum_other-lag(cum_other) over(
                                               ORDER BY state_id,date_1) AS cum_other,
                 cum_tested-lag(cum_tested) over(
                                                 ORDER BY state_id,date_1) AS cum_tested,
                 cum_total_doses_administered-lag(cum_total_doses_administered) over(
                                                                                     ORDER BY state_id,date_1) AS cum_total_doses_administered,
                 population
          FROM
              (SELECT *
               FROM
                   (SELECT state_cumulative.state_id,
                           state_cumulative.date_1,
                           cum_confirmed,
                           cum_recovered,
                           active,
                           cum_deceased,
                           cum_other,
                           coalesce(cum_total_doses_administered,0) AS cum_total_doses_administered,
                           cum_tested
                    FROM state_cumulative
                    LEFT OUTER JOIN state_vaccine_cumulative ON state_cumulative.date_1=state_vaccine_cumulative.date_1
                    AND state_cumulative.state_id=state_vaccine_cumulative.state_id) AS temp1
               NATURAL JOIN state_and_ut
               WHERE date_1=$1
                   OR date_1=$2 )AS temp2
          ORDER BY date_1 DESC,state_id
          LIMIT 37) AS temp3
     WHERE state_id =$3 ) AS temp4 ;

EXECUTE state_summary(%s,%s,%s);
--EXECUTE state_summary('26-04-2020','10-03-2021',20);
--DEALLOCATE state_summary;
