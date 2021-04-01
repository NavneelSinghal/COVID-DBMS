PREPARE state_daily_daily(int,int) AS
SELECT state AS "Name",
       date_1 AS "Date",
       confirmed AS "Confirmed Cases",
       recovered AS "Recovered Cases",
       active AS "Active Cases",
       deceased AS "Deceased Cases",
       other AS "Other Cases",
       tested AS "Tested",
       coalesce(total_doses_administered,0) AS "Total Vaccine Doses",
        round(active::decimal/nullif(confirmed,0),2) as "Active Ratio",
        round(recovered:: decimal/nullif(confirmed,0),2) as "Recovery Ratio",
        round(confirmed:: decimal/nullif(tested,0),2) as "Test Positivity Ratio",
        round(deceased::decimal/nullif(confirmed,0),2) as "Fatality Ratio"
FROM
    (SELECT state,
            state_id,
            date_1,
            confirmed,
            recovered,
            active,
            deceased,
            other,
            tested,
            total_doses_administered
     FROM
         (SELECT *
          FROM
              (SELECT state_daily.state_id,
                      state_daily.date_1,
                      confirmed,
                      recovered,
                      deceased,
                      other,
                      tested,
                      confirmed-recovered-deceased-other AS active,
                      coalesce(total_doses_administered,0) AS total_doses_administered
               FROM state_daily
               LEFT OUTER JOIN vaccine_daily ON state_daily.date_1=vaccine_daily.date_1
               AND state_daily.state_id=vaccine_daily.state_id) AS temp1
          NATURAL JOIN state_and_ut) AS temp2) AS temp3
WHERE state_id=$2
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE state_daily_daily(%s,%s);
--EXECUTE state_daily_daily(5,10);
--DEALLOCATE state_daily_daily;
