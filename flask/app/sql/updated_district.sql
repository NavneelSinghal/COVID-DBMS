PREPARE updated_district(int,text) AS
UPDATE district
SET district = $2
WHERE district_id=$1 ;

EXECUTE updated_district(%s,%s);

-- execute updated_district(801,'yoyo2');
-- deallocate updated_district;
