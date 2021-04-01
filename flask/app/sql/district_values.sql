Prepare district_values(int,date) as
Select confirmed as "Confirmed Cases",
    recovered as "Recovered Cases",
    deceased as "Deceased Cases",
    other as "Other Cases"
from district_daily
where district_id=$1
and date_1=$2
;

execute district_values(%s,%s);