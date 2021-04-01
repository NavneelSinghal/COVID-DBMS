PREPARE new_district(int,text,int) AS
INSERT INTO district(district_id,district,state_id,population)
VALUES(
           (SELECT max(district_id)
            FROM district)+1,
       $2,
       $1,
       $3) ;

EXECUTE new_district(%s,%s,%s);

--execute new_district(20,'yoyo',1000);
--deallocate new_district;
