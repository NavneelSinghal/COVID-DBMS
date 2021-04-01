
Prepare new_district(int,text,int) as
Insert into district(district_id,district,state_id,population)
Values((Select max(district_id) from district)+1,$2,$1,$3)
;

-- execute new_district(%s,%s,%s);

execute new_district(20,'yoyo',1000);
deallocate new_district;
