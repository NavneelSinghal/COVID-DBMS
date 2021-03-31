-- Select * from state_Cumulative
-- Select * from(
PREPARE list_state(text) AS
SELECT *
FROM
    (SELECT state AS "Name",
            cum_confirmed AS "Confirmed Cases",
            cum_recovered AS "Recovered Cases",
            active AS "Active Cases",
            cum_deceased AS "Deceased Cases",
            cum_tested AS "Tested",
            cum_total_doses_administered AS "Vaccinated"
     FROM
         (SELECT *
          FROM
              (SELECT state_cumulative.state_id,
                      state_cumulative.date_1,
                      cum_confirmed,
                      cum_recovered,
                      active,
                      cum_deceased,
                      cum_other,
                      cum_total_doses_administered,
                      cum_tested
               FROM state_cumulative
               LEFT OUTER JOIN state_vaccine_cumulative ON state_cumulative.date_1=state_vaccine_cumulative.date_1
               AND state_cumulative.state_id=state_vaccine_cumulative.state_id) AS temp1
          NATURAL JOIN state_and_ut
          ORDER BY date_1 DESC
          LIMIT 37) AS temp2) AS temp3
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
                                                                                                                                                                                                                                                                                                                                                               END, -- Case when $1='Active Cases' and $2='Descending' then "Active Cases" desc end,
CASE
    WHEN $1='Tested' THEN "Tested"
                                                                                                                                                                                                                                                                                                                                                                                                                                                    END, -- Case when $1='Tested' and $2='Descending' then "Tested" desc end,
CASE
    WHEN $1='Vaccinated' THEN "Vaccinated"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             END -- Case when $1='Vaccinated' and $2='Descending' then "Vaccinated" desc end
 -- Case when $2= 'Descending' then desc end
-- CASE
-- When 2>1 then
-- order by $1
 -- CASE
-- When $2="As" then
-- order by $1
-- else
-- order by $1 desc
-- End
;

EXECUTE list_state(%s);
--EXECUTE list_state('Confirmed Cases');
--DEALLOCATE list_state;
-- ) as temp1
