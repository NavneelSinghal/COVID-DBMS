Prepare list_district(text) as 
Select * from(
Select district as "Name",cum_Confirmed as "Confirmed Cases", cum_Recovered as "Recovered Cases", Active as "Active Cases",cum_Deceased as "Deceased Cases" from District_Cumulative natural join district
order by date_1 desc, district_id
limit 801) as temp1
order by 
Case when $1='Name'  then "Name" end,
-- Case when $1='Name' and $2='Descending' then "Name" desc end,
Case when $1='Confirmed Cases'  then "Confirmed Cases" end,
-- Case when $1='Confirmed Cases' and $2='Descending' then "Confirmed Cases" desc end,
Case when $1='Recovered Cases'  then "Recovered Cases" end,
-- Case when $1='Recovered Cases' and $2='Descending' then "Recovered Cases" desc end,
Case when $1='Deceased Cases'  then "Deceased Cases" end,
-- Case when $1='Desceased Cases' and $2='Descending' then "Desceased Cases" desc end,
Case when $1='Active Cases'  then "Active Cases" end
-- Case when $1='Active Cases' and $2='Descending' then "Active Cases" desc end,
;
execute list_district('Name');
deallocate list_district;