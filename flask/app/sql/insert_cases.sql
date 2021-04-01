PREPARE insert_cases(int,int,date,int,int,int,int,int) AS
INSERT INTO district_daily(date_1,district_id,confirmed,recovered,deceased,other)
VALUES($3,
       $2,
       $4,
       $5,
       $6,
       $7) ;

EXECUTE insert_cases(%s,%s,%s,%s,%s,%s,%s,%s);

-- execute insert_cases(20,801,'30-04-2021',10,20,30,40,50);
-- execute update_state(20,801,'30-04-2021',10,20,30,40,50);
-- deallocate insert_cases;
-- deallocate update_state;
