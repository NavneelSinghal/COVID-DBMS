Prepare india_daily_cumulative(int) as
Select date_1 as "Date",cum_Confirmed as "Confirmed Cases",cum_Recovered as "Recovered Cases", Active as "Active Cases",cum_Deceased as "Deceased Cases",cum_Other as "Other Cases", cum_Tested as "Tested", coalesce(cum_Total_Doses_Administered,0) as "Total Vaccine Doses",Round(a1,2) as "Active Ratio", Round(a2,2) as "Recovery Ratio",Round(a3,2) as "Fatality  Ratio", Round(a4,2) as "Test Positivity Ratio" from (
Select date_1,cum_Confirmed,cum_Recovered,Active,cum_Deceased,cum_Other,cum_Tested,cum_Total_Doses_Administered,Active/cum_Confirmed as a1, cum_Recovered/cum_Confirmed as a2, cum_Deceased/cum_Confirmed as a3, cum_Confirmed/cum_Tested as a4,cum_Confirmed/Population*100000 as a5, cum_Recovered/Population*100000 as a6, Active/Population*100000 as a7, cum_Deceased/Population*100000 as a8, cum_Other/Population*100000 as a9,cum_Tested/Population*100000 as a10,cum_Total_Doses_Administered/Population*100000 as a11,Population from
( 
Select * from(
Select India_Cumulative.date_1,cum_Confirmed,cum_Recovered,Active,cum_Deceased,cum_Other,cum_Total_Doses_Administered,cum_Tested
from India_Cumulative left outer join India_Vaccine_Cumulative
on India_Cumulative.date_1=India_Vaccine_Cumulative.date_1) as temp1,India_population
) 
as temp2
) as temp3
order by date_1 desc
limit $1;

execute india_daily_cumulative(3);
deallocate india_daily_cumulative;
