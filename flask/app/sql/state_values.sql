PREPARE state_values(int,date) AS
SELECT confirmed AS "Confirmed Cases",
       recovered AS "Recovered Cases",
       deceased AS "Deceased Cases",
       other AS "Other Cases",
       tested AS "Tested Cases"
FROM state_daily
WHERE state_id=$1
    AND date_1=$2 ;

EXECUTE state_values(%s,%s);
