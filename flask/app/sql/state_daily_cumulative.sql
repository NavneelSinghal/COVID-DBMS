PREPARE state_daily_cumulative(int,int) AS
SELECT state AS "Name",
       date_1 AS "Date",
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
    (SELECT state,
            state_id,
            date_1,
            cum_confirmed,
            cum_recovered,
            active,
            cum_deceased,
            cum_other,
            cum_tested,
            cum_total_doses_administered,
            active/nullif(cum_confirmed,0) AS a1,
            cum_recovered/nullif(cum_confirmed,0) AS a2,
            cum_deceased/nullif(cum_confirmed,0) AS a3,
            cum_confirmed/nullif(cum_tested,0) AS a4,
            cum_confirmed/nullif(population,0)*100000 AS a5,
            cum_recovered/nullif(population,0)*100000 AS a6,
            active/nullif(population,0)*100000 AS a7,
            cum_deceased/nullif(population,0)*100000 AS a8,
            cum_other/nullif(population,0)*100000 AS a9,
            cum_tested/nullif(population,0)*100000 AS a10,
            cum_total_doses_administered/nullif(population,0)*100000 AS a11,
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
          NATURAL JOIN state_and_ut) AS temp2) AS temp3
WHERE state_id=$2
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE state_daily_cumulative(%s,%s);

--execute state_daily_cumulative(3,20);
--deallocate state_daily_cumulative;
