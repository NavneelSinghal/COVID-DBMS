-- Select * from state_Cumulative
-- Select * from(
Prepare list_state( text) as
 Select * from(
Select state as "Name",cum_Confirmed as "Confirmed Cases", cum_Recovered as "Recovered Cases", Active as "Active Cases", cum_Deceased as "Deceased Cases", cum_Tested as "Tested", cum_Total_Doses_Administered as "Vaccinated" from(
Select * from (
Select state_Cumulative.state_id, state_Cumulative.date_1,cum_Confirmed,cum_Recovered,Active,cum_Deceased,cum_Other,cum_Total_Doses_Administered,cum_Tested
from state_Cumulative left outer join state_Vaccine_Cumulative
on state_Cumulative.date_1=state_Vaccine_Cumulative.date_1
and state_Cumulative.state_id=state_Vaccine_Cumulative.state_id) as temp1 natural join state_and_ut
order by date_1 desc
limit 37) as temp2
) as temp3
order by
Case when $1='Name'  then "Name" end,
-- Case when $1='Name' and $2='Descending' then "Name" desc end,
Case when $1='Confirmed Cases'  then "Confirmed Cases" end,
-- Case when $1='Confirmed Cases' and $2='Descending' then "Confirmed Cases" desc end,
Case when $1='Recovered Cases'  then "Recovered Cases" end,
-- Case when $1='Recovered Cases' and $2='Descending' then "Recovered Cases" desc end,
Case when $1='Deceased Cases'  then "Deceased Cases" end,
-- Case when $1='Desceased Cases' and $2='Descending' then "Desceased Cases" desc end,
Case when $1='Active Cases'  then "Active Cases" end,
-- Case when $1='Active Cases' and $2='Descending' then "Active Cases" desc end,
Case when $1='Tested'  then "Tested" end,
-- Case when $1='Tested' and $2='Descending' then "Tested" desc end,
Case when $1='Vaccinated' then "Vaccinated" end
-- Case when $1='Vaccinated' and $2='Descending' then "Vaccinated" desc end

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

execute list_state('Confirmed Cases');
deallocate list_state;


-- ) as temp1