PREPARE district_values(int,date) AS
SELECT confirmed AS "Confirmed Cases",
       recovered AS "Recovered Cases",
       deceased AS "Deceased Cases",
       other AS "Other Cases"
FROM district_daily
WHERE district_id=$1
    AND date_1=$2 ;

EXECUTE district_values(%s,%s);
