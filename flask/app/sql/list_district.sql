PREPARE list_district(int, text) AS
SELECT *
FROM
    ( SELECT district AS "Name",
             cum_confirmed AS "Confirmed Cases",
             cum_recovered AS "Recovered Cases",
             active AS "Active Cases",
             cum_deceased AS "Deceased Cases"
     FROM
         ( SELECT *
          FROM
              ( SELECT *,
                       rank() OVER ( PARTITION BY district_id
                                    ORDER BY date_1 DESC ) AS rank
               FROM district_cumulative ) AS temp100
          WHERE rank = 1 ) AS temp0
     NATURAL
      JOIN district
     WHERE state_id = $1 ) AS temp1
ORDER BY CASE
             WHEN $2 = 'Name' THEN "Name"
         END, -- Case when $1='Name' and $2='Descending' then "Name" desc end,
 CASE
     WHEN $2 = 'Confirmed Cases' THEN "Confirmed Cases"
 END, -- Case when $1='Confirmed Cases' and $2='Descending' then "Confirmed Cases" desc end,
 CASE
     WHEN $2 = 'Recovered Cases' THEN "Recovered Cases"
 END, -- Case when $1='Recovered Cases' and $2='Descending' then "Recovered Cases" desc end,
 CASE
     WHEN $2 = 'Deceased Cases' THEN "Deceased Cases"
 END, -- Case when $1='Desceased Cases' and $2='Descending' then "Desceased Cases" desc end,
 CASE
     WHEN $2 = 'Active Cases' THEN "Active Cases"
 END -- Case when $1='Active Cases' and $2='Descending' then "Active Cases" desc end,
 ;

EXECUTE list_district(%s, %s);
