PREPARE india_summary(date,date) as 

SELECT cum_confirmed as "Confirmed Cases",
       cum_recovered as "Recovered Cases",
       cum_active as "Active Cases",
       cum_deceased as "Deceased Cases",
       cum_other as "Other Cases",
       cum_tested as "Tested",
       cum_total_doses_administered as "Total Vaccine Doses",
       ROUND(cum_active/cum_confirmed,2) as "Active Ratio",
       ROUND(cum_recovered/cum_confirmed,2) as "Recovery Ratio",
       ROUND(cum_deceased/cum_confirmed,2) as "Case Fatality Ratio",
       ROUND(cum_confirmed/cum_tested,2) as "Test Positivity Ratio",
       ROUND(cum_confirmed/population*100000,2) as "Confirmed per lakh",
       ROUND(cum_recovered/population*100000,2) as "Recovered per lakh",
       ROUND(cum_active/population*100000,2) as "Active per lakh",
       ROUND(cum_deceased/population*100000,2) as "Deceased per lakh",
       ROUND(cum_other/population*100000,2) as "Other per lakh",
       ROUND(cum_tested/population*100000,2) as "Tested per lakh",
       ROUND(cum_total_doses_administered/population*100000,2) as "Total Vaccine Doses per lakh",
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
    FROM india_cumulative LEFT OUTER JOIN india_vaccine_cumulative USING (date_1)
    WHERE india_cumulative.date_1 < $1
    ORDER BY india_cumulative.date_1 DESC
    LIMIT 1
  ) AS from_row
  FULL OUTER JOIN 
  (
    SELECT *, 1 as row_num
    FROM india_cumulative LEFT OUTER JOIN india_vaccine_cumulative USING (date_1)
    WHERE india_cumulative.date_1 <= $2
    ORDER BY india_cumulative.date_1 DESC
    LIMIT 1
  ) AS to_row
  USING (row_num)
  FULL OUTER JOIN
  (
    SELECT population, 1 AS row_num
    FROM india_population
  ) AS pop_table
  USING (row_num)
) AS temp
;

execute india_summary(%s, %s);
-- execute india_summary('27-04-2020','10-03-2021');
-- deallocate india_summary;
