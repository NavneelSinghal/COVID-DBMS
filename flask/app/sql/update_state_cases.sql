PREPARE update_state(int,int,date,int,int,int,int,int) AS
UPDATE state_daily
SET tested=tested+$8
WHERE state_id=$1
    AND date_1=$3;

EXECUTE update_state(%s,%s,%s,%s,%s,%s,%s,%s);
