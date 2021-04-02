PREPARE india_daily_cumulative(int) AS
SELECT date_1 AS "Date",
       confirmed AS "Confirmed Cases",
       recovered AS "Recovered Cases",
       active AS "Active Cases",
       deceased AS "Deceased Cases",
       other AS "Other Cases",
       tested AS "Tested",
       coalesce(total_doses_administered, 0) AS "Total Vaccine Doses",
       round(active/ nullif(confirmed, 0), 2) AS "Active Ratio",
       round(recovered/nullif(confirmed, 0), 2) AS "Recovery Ratio",
       round(confirmed/nullif(tested, 0), 2) AS "Test Positivity Ratio",
       round(deceased/nullif(confirmed, 0), 2) AS "Fatality Ratio"
FROM
  (SELECT india_cumulative.date_1,
          cum_confirmed AS confirmed,
          cum_recovered AS recovered,
          cum_deceased AS deceased,
          cum_other AS other,
          cum_tested AS tested,
          active,
          cum_total_doses_administered AS total_doses_administered
   FROM india_cumulative
   LEFT OUTER JOIN india_vaccine_cumulative USING (date_1)) AS temp1
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE india_daily_cumulative(%s);

--DEALLOCATE india_daily_cumulative;
