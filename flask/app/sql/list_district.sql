PREPARE list_district(text) AS
SELECT *
FROM
    (SELECT district AS "Name",
            cum_confirmed AS "Confirmed Cases",
            cum_recovered AS "Recovered Cases",
            active AS "Active Cases",
            cum_deceased AS "Deceased Cases"
     FROM district_cumulative
     NATURAL JOIN district
     ORDER BY date_1 DESC, district_id
     LIMIT 801) AS temp1
ORDER BY CASE
             WHEN $1='Name' THEN "Name"
         END, -- Case when $1='Name' and $2='Descending' then "Name" desc end,
CASE
    WHEN $1='Confirmed Cases' THEN "Confirmed Cases"
                                                                              END, -- Case when $1='Confirmed Cases' and $2='Descending' then "Confirmed Cases" desc end,
CASE
    WHEN $1='Recovered Cases' THEN "Recovered Cases"
                                                                                                                                                                         END, -- Case when $1='Recovered Cases' and $2='Descending' then "Recovered Cases" desc end,
CASE
    WHEN $1='Deceased Cases' THEN "Deceased Cases"
                                                                                                                                                                                                                                                                    END, -- Case when $1='Desceased Cases' and $2='Descending' then "Desceased Cases" desc end,
CASE
    WHEN $1='Active Cases' THEN "Active Cases"
                                                                                                                                                                                                                                                                                                                                                               END -- Case when $1='Active Cases' and $2='Descending' then "Active Cases" desc end,
;

EXECUTE list_district(%s);

--deallocate list_district;
