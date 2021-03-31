PREPARE district_daily_daily(int,int) AS
SELECT 
       date_1 AS "Date",
       confirmed AS "Confirmed Cases",
       recovered AS "Recovered Cases",
       active AS "Active Cases",
       deceased AS "Deceased Cases",
       other AS "Other Cases",
        round(active::decimal/nullif(confirmed,0),2) as "Active Ratio",
        round(recovered:: decimal/nullif(confirmed,0),2) as "Recovery Ratio",
        round(deceased::decimal/nullif(confirmed,0),2) as "Fatality Ratio"
FROM
    (SELECT *,confirmed-recovered-deceased-other AS active
               FROM district_daily natural join district)   AS temp3
WHERE district_id=$2
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE district_daily_daily(%s,%s);
-- EXECUTE district_daily_daily(5,10);
-- DEALLOCATE district_daily_daily;
