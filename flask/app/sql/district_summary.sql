-- Select * from District_Cumulative natural join district
PREPARE district_summary(date,date,int) AS
SELECT cum_confirmed AS "Confirmed Cases",
       cum_recovered AS "Recovered Cases",
       cum_active AS "Active Cases",
       cum_deceased AS "Deceased Cases",
       cum_other AS "Other Cases",
       round(cum_active/nullif(cum_confirmed, 0),2) AS "Active Ratio",
       round(cum_recovered/nullif(cum_confirmed, 0),2) AS "Recovery Ratio",
       round(cum_deceased/nullif(cum_confirmed, 0),2) AS "Case Fatality Ratio",
       round(cum_confirmed/nullif(population, 0)*100000,2) AS "Confirmed per lakh",
       round(cum_recovered/nullif(population, 0)*100000,2) AS "Recovered per lakh",
       round(cum_active/nullif(population, 0)*100000,2) AS "Active per lakh",
       round(cum_deceased/nullif(population, 0)*100000,2) AS "Deceased per lakh",
       round(cum_other/nullif(population, 0)*100000,2) AS "Other per lakh",
       population AS "Population"
FROM
    ( SELECT (coalesce(to_row.cum_confirmed, 0) - coalesce(from_row.cum_confirmed, 0)) AS cum_confirmed,
             (coalesce(to_row.cum_recovered, 0) - coalesce(from_row.cum_recovered, 0)) AS cum_recovered,
             (coalesce(to_row.cum_deceased, 0) - coalesce(from_row.cum_deceased, 0)) AS cum_deceased,
             (coalesce(to_row.cum_other, 0) - coalesce(from_row.cum_other, 0)) AS cum_other,
             (coalesce(to_row.active, 0) - coalesce(from_row.active, 0)) AS cum_active,
             temp_row.population
     FROM
         ( SELECT *,
                  1 AS row_num
          FROM district_cumulative
          NATURAL JOIN district
          WHERE district_id=$3
              AND date_1<$1
          ORDER BY date_1 DESC
          LIMIT 1) AS from_row
     FULL OUTER JOIN
         (SELECT *,
                 1 AS row_num
          FROM district_cumulative
          NATURAL JOIN district
          WHERE district_id=$3
              AND date_1<=$2
          ORDER BY date_1 DESC
          LIMIT 1) AS to_row USING(row_num)
     FULL OUTER JOIN
         (SELECT *,
                 1 AS row_num
          FROM district_cumulative
          LIMIT 1) AS temp_row USING (row_num)) AS temp1 ;

EXECUTE district_summary(%s, %s, %s);

--execute district_summary('01-01-2012','01-02-2012',366);
--deallocate district_summary;
