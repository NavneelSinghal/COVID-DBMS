Prepare update_cases(int,int,date,int,int,int,int,int) as
update district_daily
set confirmed=confirmed+$4,
recovered=recovered+$5,
deceased=deceased+$6,
other=other+$7
where date_1=$3 and district_id=$2
;
Prepare update_state(int,int,date,int,int,int,int,int) as
Update state_daily
set tested=tested+$8
where state_id=$1 and date_1=$3;


execute insert_cases(%s,%s,%s,%s,%s,%s,%s,%s);
execute update_state(%s,%s,%s,%s,%s,%s,%s,%s);

-- execute update_cases(20,805,'30-04-2021',11,20,30,40,50);
-- execute update_state(20,805,'30-04-2021',11,20,30,40,50);
-- deallocate update_cases;
-- deallocate update_state;
