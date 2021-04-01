PREPARE state_summary(date,date,int) AS

SELECT cum_confirmed as "Confirmed Cases",
       cum_recovered as "Recovered Cases",
       cum_active as "Active Cases",
       cum_deceased as "Deceased Cases",
       cum_other as "Other Cases",
       cum_tested as "Tested",
       cum_total_doses_administered as "Total Vaccine Doses",
       ROUND(cum_active/NULLIF(cum_confirmed, 0),2) as "Active Ratio",
       ROUND(cum_recovered/NULLIF(cum_confirmed, 0),2) as "Recovery Ratio",
       ROUND(cum_deceased/NULLIF(cum_confirmed, 0),2) as "Case Fatality Ratio",
       ROUND(cum_confirmed/NULLIF(cum_tested, 0),2) as "Test Positivity Ratio",
       ROUND(cum_confirmed/NULLIF(population, 0)*100000,2) as "Confirmed per lakh",
       ROUND(cum_recovered/NULLIF(population, 0)*100000,2) as "Recovered per lakh",
       ROUND(cum_active/NULLIF(population, 0)*100000,2) as "Active per lakh",
       ROUND(cum_deceased/NULLIF(population, 0)*100000,2) as "Deceased per lakh",
       ROUND(cum_other/NULLIF(population, 0)*100000,2) as "Other per lakh",
       ROUND(cum_tested/NULLIF(population, 0)*100000,2) as "Tested per lakh",
       ROUND(cum_total_doses_administered/NULLIF(population, 0)*100000,2) as "Total Vaccine Doses per lakh",
       Population as "Population"
FROM
(
  SELECT
        (COALESCE(to_row.cum_confirmed, 0) - COALESCE(from_row.cum_confirmed, 0)) as cum_confirmed,
        (COALESCE(to_row.cum_recovered, 0) - COALESCE(from_row.cum_recovered, 0)) as cum_recovered,
        (COALESCE(to_row.cum_deceased, 0) - COALESCE(from_row.cum_deceased, 0)) as cum_deceased,
        (COALESCE(to_row.cum_tested, 0) - COALESCE(from_row.cum_tested, 0)) as cum_tested,
        (COALESCE(to_row.cum_other, 0) - COALESCE(from_row.cum_other, 0)) as cum_other,
        (COALESCE(to_row.active, 0) - COALESCE(from_row.active, 0)) as cum_active,
        (COALESCE(to_row.cum_total_doses_administered, 0) - COALESCE(from_row.cum_total_doses_administered, 0)) as cum_total_doses_administered,
        population
  FROM
  (
    SELECT *, 1 as row_num
    FROM state_cumulative LEFT OUTER JOIN state_vaccine_cumulative USING (state_id, date_1)
    WHERE state_cumulative.state_id = $3 AND state_cumulative.date_1 < $1
    ORDER BY state_cumulative.date_1 DESC
    LIMIT 1
  ) AS from_row
  FULL OUTER JOIN 
  (
    SELECT *, 1 as row_num
    FROM state_cumulative LEFT OUTER JOIN state_vaccine_cumulative USING (state_id, date_1)
    WHERE state_cumulative.state_id = $3 AND state_cumulative.date_1 <= $2
    ORDER BY state_cumulative.date_1 DESC
    LIMIT 1
  ) AS to_row
  USING (row_num)
  FULL OUTER JOIN
  (
    SELECT population, 1 AS row_num
    FROM state_and_ut
    WHERE state_id = $3
  ) AS pop_table
  USING (row_num)
) AS temp
;

EXECUTE state_summary(%s,%s,%s);
--EXECUTE state_summary('27-04-2020','25-05-2021',20);
--DEALLOCATE state_summary;
