
Prepare updated_district(int,text) as
Update district 
set district = $2
where district_id=$1
;

execute updated_district(%s,%s);

-- execute updated_district(801,'yoyo2');
-- deallocate updated_district;