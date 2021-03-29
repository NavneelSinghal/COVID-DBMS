Prepare analysis_state_daily_cumulative(int,date,date,text) as 
Select * from(
Select state as "Name",date_1 as "Date",cum_Confirmed as "Confirmed Cases",cum_Recovered as "Recovered Cases", Active as "Active Cases",cum_Deceased as "Deceased Cases",cum_Other as "Other Cases", cum_Tested as "Tested", coalesce(cum_Total_Doses_Administered,0) as "Total Vaccine Doses",Round(a1,2) as "Active Ratio", Round(a2,2) as "Recovery Ratio",Round(a3,2) as "Fatality  Ratio", Round(a4,2) as "Test Positivity Ratio" from (
Select state,state_id,date_1,cum_Confirmed,cum_Recovered,Active,cum_Deceased,cum_Other,cum_Tested,cum_Total_Doses_Administered,Active/nullif(cum_confirmed,0) as a1, cum_Recovered/nullif(cum_confirmed,0) as a2, cum_Deceased/nullif(cum_confirmed,0) as a3, cum_Confirmed/nullif(cum_Tested,0) as a4,cum_Confirmed/nullif(population,0)*100000 as a5, cum_Recovered/nullif(population,0)*100000 as a6, Active/nullif(population,0)*100000 as a7, cum_Deceased/nullif(population,0)*100000 as a8, cum_Other/nullif(population,0)*100000 as a9,cum_Tested/nullif(population,0)*100000 as a10,cum_Total_Doses_Administered/nullif(population,0)*100000 as a11,Population from
( 
Select * from(
Select state_Cumulative.state_id, state_Cumulative.date_1,cum_Confirmed,cum_Recovered,Active,cum_Deceased,cum_Other,coalesce(cum_Total_Doses_Administered,0) as cum_Total_Doses_Administered,cum_Tested
from state_Cumulative left outer join state_Vaccine_Cumulative
on state_Cumulative.date_1=state_Vaccine_Cumulative.date_1
and state_Cumulative.state_id=state_Vaccine_Cumulative.state_id
) as temp1 natural join state_and_ut
) 
as temp2
) as temp3
where state_id=$1
and date_1>=$2 and date_1<=$3
) as temp4
order by
Case when $4='Confirmed Cases'  then "Confirmed Cases" end,
Case when $4='Recovered Cases'  then "Recovered Cases" end,
Case when $4='Deceased Cases'  then "Deceased Cases" end,
Case when $4='Active Cases'  then "Active Cases" end,
Case when $4='Other Cases'  then "Other Cases" end,
Case when $4='Tested'  then "Tested" end,
Case when $4='Total Vaccine Doses'  then "Total Vaccine Doses" end
-- Case when $4='Active Ratio'  then "Active Ratio" end,
-- Case when $4='Recovery Ratio'  then "Recovery Ratio" end,
-- Case when $4='Test Positivity Ratio'  then "Test Positivity Ratio" end,
-- Case when $4='Fatality Ratio'  then "Fatality Ratio" end,
limit 1;

execute analysis_state_daily_cumulative(20,'01-05-2020','01-11-2020','Active Cases');
deallocate analysis_state_daily_cumulative;







