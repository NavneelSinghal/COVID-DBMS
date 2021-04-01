PREPARE update_cases(int,int,date,int,int,int,int,int) AS
UPDATE district_daily
SET confirmed=confirmed+$4,
    recovered=recovered+$5,
    deceased=deceased+$6,
    other=other+$7
WHERE date_1=$3
    AND district_id=$2 ;

EXECUTE update_cases(%s,%s,%s,%s,%s,%s,%s,%s);

-- execute update_cases(20,805,'30-04-2021',11,20,30,40,50);
-- execute update_state(20,805,'30-04-2021',11,20,30,40,50);
-- deallocate update_cases;
-- deallocate update_state;
