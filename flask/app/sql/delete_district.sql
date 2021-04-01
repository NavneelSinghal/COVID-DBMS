Prepare delete_district(int) as
Delete from district 
where district_id=$1
;

-- execute delete_district(%s);

execute delete_district(801);
deallocate delete_district;