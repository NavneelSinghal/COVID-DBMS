Prepare state_summary(date,date,int) as 
Select state as "Name",cum_Confirmed as "Confirmed Cases",cum_Recovered as "Recovered Cases", Active as "Active Cases",cum_Deceased as "Deceased Cases",cum_Other as "Other Cases", cum_Tested as "Tested", coalesce(cum_Total_Doses_Administered,0) as "Total Vaccine Doses",Round(a1,2) as "Active Ratio", Round(a2,2) as "Recovery Ratio",Round(a3,2) as "Case Fatality  Ratio", Round(a4,2) as "Test Positivity Ratio", Round(a5,2) as "Confirmed Per lakh", Round(a6,2) as "Recovered per lakh", Round(a7,2) as "Active per lakh", Round(a8,2) as "Deceased per lakh",Round(a9,2) as "Other per lakh", Round(a10,2) as "Tested per lakh", Round(coalesce(a11,0),2) as "Total Vaccine Doses per lakh", Population as "Population" from(
Select date_1,state,cum_Confirmed,cum_Recovered,cum_Confirmed-cum_Recovered-cum_Deceased-cum_Other as Active,cum_Deceased,cum_Other,cum_Tested,cum_Total_Doses_Administered,(cum_Confirmed-cum_Recovered-cum_Deceased-cum_Other)/Nullif(cum_Confirmed,0) as a1, cum_Recovered/nullif(cum_Confirmed,0) as a2, cum_Deceased/nullif(cum_Confirmed,0) as a3, cum_Confirmed/nullif(cum_Tested,0) as a4,cum_Confirmed/nullif(population,0)*100000 as a5, cum_Recovered/nullif(population,0)*100000 as a6, (cum_Confirmed-cum_Recovered-cum_Deceased-cum_Other)/nullif(population,0)*100000 as a7, cum_Deceased/nullif(population,0)*100000 as a8, cum_Other/nullif(population,0)*100000 as a9,cum_Tested/nullif(population,0)*100000 as a10,cum_Total_Doses_Administered/nullif(population,0)*100000 as a11,Population from(
Select state,date_1,state_id,cum_Confirmed-lag(cum_Confirmed) over(order by state_id,date_1) as cum_Confirmed,cum_Recovered-lag(cum_Recovered) over(order by state_id,date_1) as cum_Recovered,cum_Deceased-lag(cum_Deceased) over(order by state_id,date_1) as cum_Deceased, cum_Other-lag(cum_Other) over(order by state_id,date_1) as cum_Other, cum_Tested-lag(cum_Tested) over(order by state_id,date_1) as cum_Tested,cum_Total_Doses_Administered-lag(cum_Total_Doses_Administered) over(order by state_id,date_1) as cum_Total_Doses_Administered,population from
( 
Select * from(
Select state_Cumulative.state_id,state_Cumulative.date_1,cum_Confirmed,cum_Recovered,Active,cum_Deceased,cum_Other,coalesce(cum_Total_Doses_Administered,0) as cum_Total_Doses_Administered,cum_Tested
from state_Cumulative left outer join state_Vaccine_Cumulative
on state_Cumulative.date_1=state_Vaccine_Cumulative.date_1
and state_Cumulative.state_id=state_Vaccine_Cumulative.state_id
) as temp1 natural join state_and_ut
where date_1=$1 or date_1=$2
)as temp2
order by date_1 desc,state_id limit 37

) as temp3
where state_id =$3
) as temp4 ;

execute state_summary('26-04-2020','10-03-2021',20);
deallocate state_summary;