PREPARE district_daily_avg(int,int) AS
SELECT district_id,
       date_1 AS "Date",
    --    district,
       round(avg(confirmed) OVER (PARTITION BY district
                                  ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Confirmed Cases",
       round(avg(recovered) OVER (PARTITION BY district
                                  ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Recovered Cases",
       round(avg(active) OVER (PARTITION BY district
                               ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Active Cases",
       round(avg(deceased) OVER (PARTITION BY district
                                 ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Deceased Cases",
       round(avg(other) OVER (PARTITION BY district
                              ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2) AS "Other Cases",       
        round(round(avg(active) OVER (PARTITION BY district
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (PARTITION BY district
                                       ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Active Ratio",
        round(round(avg(recovered) OVER (PARTITION BY district
                                ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (PARTITION BY district
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Recovery Ratio",
        round(round(avg(deceased) OVER (PARTITION BY district
                                ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2)/nullif(round(avg(confirmed) OVER (PARTITION BY district
                                    ORDER BY date_1 ROWS BETWEEN 6 preceding AND CURRENT ROW),2),0.00),2) as "Fatality Ratio"

FROM
    (SELECT *,confirmed-recovered-deceased-other AS active
               FROM district_daily natural join district)   AS temp3
WHERE district_id=$2
ORDER BY date_1 DESC
LIMIT $1;
EXECUTE district_daily_avg(%s,%s);

-- execute district_daily_avg(4,366);
-- deallocate district_daily_avg;