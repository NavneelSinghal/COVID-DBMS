PREPARE district_daily_cumulative(int,int) AS
SELECT district AS "Name",
       date_1 AS "Date",
       cum_confirmed AS "Confirmed Cases",
       cum_recovered AS "Recovered Cases",
       active AS "Active Cases",
       cum_deceased AS "Deceased Cases",
       cum_other AS "Other Cases",
       round(a1,2) AS "Active Ratio",
       round(a2,2) AS "Recovery Ratio",
       round(a3,2) AS "Fatality  Ratio"
FROM
    (SELECT district,
            district_id,
            date_1,
            cum_confirmed,
            cum_recovered,
            active,
            cum_deceased,
            cum_other,
            active/nullif(cum_confirmed,0) AS a1,
            cum_recovered/nullif(cum_confirmed,0) AS a2,
            cum_deceased/nullif(cum_confirmed,0) AS a3,
            cum_confirmed/nullif(population,0)*100000 AS a5,
            cum_recovered/nullif(population,0)*100000 AS a6,
            active/nullif(population,0)*100000 AS a7,
            cum_deceased/nullif(population,0)*100000 AS a8,
            cum_other/nullif(population,0)*100000 AS a9,
            population
     FROM
         (SELECT *
               FROM District_Cumulative natural join district) AS temp2) AS temp3
WHERE district_id=$2
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE district_daily_cumulative(%s,%s);

-- execute district_daily_cumulative(3,366);
-- deallocate district_daily_cumulative;
