PREPARE district_list_statewise(int) AS
SELECT district AS "Name",
       district_id AS "districtid"
FROM district
WHERE state_id =$1;

EXECUTE district_list_statewise(%s);

--deallocate district_list_statewise;
