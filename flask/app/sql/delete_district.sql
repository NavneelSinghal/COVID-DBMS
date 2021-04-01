PREPARE delete_district(int) AS
DELETE
FROM district
WHERE district_id=$1 ;

EXECUTE delete_district(%s);

--execute delete_district(801);
--deallocate delete_district;
