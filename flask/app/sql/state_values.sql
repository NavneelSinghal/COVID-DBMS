Prepare state_values(int,date) as
Select confirmed as "Confirmed Cases",
    recovered as "Recovered Cases",
    deceased as "Deceased Cases",
    other as "Other Cases",
    tested as "Tested Cases"
from state_daily
where state_id=$1
and date_1=$2
;

execute state_values(%s,%s);