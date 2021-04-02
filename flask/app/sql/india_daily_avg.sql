PREPARE india_daily_avg(int) AS 
SELECT 
  date_1 AS "Date", 
  round(
    avg(confirmed) OVER (
      ORDER BY 
        date_1 ROWS BETWEEN 6 preceding 
        AND CURRENT ROW
    ), 
    2
  ) AS "Confirmed Cases", 
  round(
    avg(recovered) OVER (
      ORDER BY 
        date_1 ROWS BETWEEN 6 preceding 
        AND CURRENT ROW
    ), 
    2
  ) AS "Recovered Cases", 
  round(
    avg(active) OVER (
      ORDER BY 
        date_1 ROWS BETWEEN 6 preceding 
        AND CURRENT ROW
    ), 
    2
  ) AS "Active Cases", 
  round(
    avg(deceased) OVER (
      ORDER BY 
        date_1 ROWS BETWEEN 6 preceding 
        AND CURRENT ROW
    ), 
    2
  ) AS "Deceased Cases", 
  round(
    avg(other) OVER (
      ORDER BY 
        date_1 ROWS BETWEEN 6 preceding 
        AND CURRENT ROW
    ), 
    2
  ) AS "Other Cases", 
  round(
    avg(tested) OVER (
      ORDER BY 
        date_1 ROWS BETWEEN 6 preceding 
        AND CURRENT ROW
    ), 
    2
  ) AS "Tested", 
  round(
    coalesce(
      avg(total_doses_administered) OVER (
        ORDER BY 
          date_1 ROWS BETWEEN 6 preceding 
          AND CURRENT ROW
      ), 
      0
    ), 
    2
  ) AS "Total Vaccine Doses", 
  round(
    (
      avg(active) OVER (
        ORDER BY 
          date_1 ROWS BETWEEN 6 preceding 
          AND CURRENT ROW
      )/ nullif(
        avg(confirmed) OVER (
          ORDER BY 
            date_1 ROWS BETWEEN 6 preceding 
            AND CURRENT ROW
        ), 
        0
      )
    ), 
    2
  ) AS "Active Ratio", 
  round(
    round(
      avg(recovered) OVER (
        ORDER BY 
          date_1 ROWS BETWEEN 6 preceding 
          AND CURRENT ROW
      ), 
      2
    )/ nullif(
      round(
        avg(confirmed) OVER (
          ORDER BY 
            date_1 ROWS BETWEEN 6 preceding 
            AND CURRENT ROW
        ), 
        2
      ), 
      0.00
    ), 
    2
  ) AS "Recovery Ratio", 
  round(
    round(
      avg(deceased) OVER (
        ORDER BY 
          date_1 ROWS BETWEEN 6 preceding 
          AND CURRENT ROW
      ), 
      2
    )/ nullif(
      round(
        avg(confirmed) OVER (
          ORDER BY 
            date_1 ROWS BETWEEN 6 preceding 
            AND CURRENT ROW
        ), 
        2
      ), 
      0.00
    ), 
    2
  ) AS "Fatality Ratio", 
  round(
    round(
      avg(confirmed) OVER (
        ORDER BY 
          date_1 ROWS BETWEEN 6 preceding 
          AND CURRENT ROW
      ), 
      2
    )/ nullif(
      round(
        avg(tested) OVER (
          ORDER BY 
            date_1 ROWS BETWEEN 6 preceding 
            AND CURRENT ROW
        ), 
        2
      ), 
      0.00
    ), 
    2
  ) AS "Test Positivity Ratio" 
FROM
  (SELECT india_daily.date_1,
          confirmed,
          recovered,
          deceased,
          other,
          tested,
          active,
          total_doses_administered
   FROM india_daily
   LEFT OUTER JOIN india_vaccine_daily USING (date_1)) AS temp1
ORDER BY date_1 DESC
LIMIT $1;

EXECUTE india_daily_avg(%s);
