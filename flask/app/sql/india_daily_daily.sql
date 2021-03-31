PREPARE india_daily_daily(int) AS
SELECT date_1 AS "Date",
       confirmed AS "Confirmed Cases",
       recovered AS "Recovered Cases",
       active AS "Active Cases",
       deceased AS "Deceased Cases",
       other AS "Other Cases",
       tested AS "Tested",
       coalesce(total_doses_administered,0) AS "Total Vaccine Doses" from
    (SELECT date_1,confirmed,recovered,active,deceased,other,tested,total_doses_administered from
         (SELECT *
          FROM
              (SELECT india_daily.date_1,confirmed,recovered,deceased,other,tested,active,total_doses_administered
               FROM india_daily
               LEFT OUTER JOIN india_vaccine_daily ON india_daily.date_1=india_vaccine_daily.date_1) AS temp1, india_population) AS temp2) AS temp3
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE india_daily_daily(%d);
--DEALLOCATE india_daily_daily;
