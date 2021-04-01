Prepare insert_cases(int,int,date,int,int,int,int,int) as
Insert into district_daily(date_1,District_id,Confirmed,Recovered,Deceased,Other)
Values($3,$2,$4,$5,$6,$7)
;
Prepare update_state(int,int,date,int,int,int,int,int) as
Update state_daily
set tested=tested+$8
where state_id=$1 and date_1=$3;


execute insert_cases(%s,%s,%s,%s,%s,%s,%s,%s);
execute update_state(%s,%s,%s,%s,%s,%s,%s,%s);


-- execute insert_cases(20,801,'30-04-2021',10,20,30,40,50);
-- execute update_state(20,801,'30-04-2021',10,20,30,40,50);
-- deallocate insert_cases;
-- deallocate update_state;
