PREPARE state_daily_avg(int,int) AS
SELECT state AS "Name",
       state_id,
       date_1 AS "Date",
       round(avg(confirmed) OVER (PARTITION BY state
                                  ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Confirmed Cases",
       round(avg(recovered) OVER (PARTITION BY state
                                  ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Recovered Cases",
       round(avg(active) OVER (PARTITION BY state
                               ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Active Cases",
       round(avg(deceased) OVER (PARTITION BY state
                                 ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Deceased Cases",
       round(avg(other) OVER (PARTITION BY state
                              ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Other Cases",
       round(avg(tested) OVER (PARTITION BY state
                               ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Tested",
       round(coalesce(avg(total_doses_administered) OVER (PARTITION BY state
                                                          ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),0),2) AS "Total Vaccine Doses"
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
                      total_doses_administered
               FROM state_daily
               LEFT OUTER JOIN vaccine_daily ON state_daily.date_1=vaccine_daily.date_1
               AND state_daily.state_id=vaccine_daily.state_id) AS temp1
          NATURAL JOIN state_and_ut) AS temp2) AS temp3
WHERE state_id=$2
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE state_daily_avg(%s,%s);

--execute state_daily_avg(4,20);
--deallocate state_daily_avg;
