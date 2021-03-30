-- Select Date_1,cum_Confirmed as "Confirmed Cases",cum_Recovered as "Recovered Cases",Active as "Active Cases",cum_Deceased as "Deceased Cases",cum_Other as "Active Cases"
Prepare india_summary(date,date) as 
Select cum_Confirmed as "Confirmed Cases",cum_Recovered as "Recovered Cases", Active as "Active Cases",cum_Deceased as "Deceased Cases",cum_Other as "Other Cases", cum_Tested as "Tested", coalesce(cum_Total_Doses_Administered,0) as "Total Vaccine Doses",Round(a1,2) as "Active Ratio", Round(a2,2) as "Recovery Ratio",Round(a3,2) as "Case Fatality  Ratio", Round(a4,2) as "Test Positivity Ratio", Round(a5,2) as "Confirmed Per lakh", Round(a6,2) as "Recovered per lakh", Round(a7,2) as "Active per lakh", Round(a8,2) as "Deceased per lakh",Round(a9,2) as "Other per lakh", Round(a10,2) as "Tested per lakh", Round(coalesce(a11,0),2) as "Total Vaccine Doses per lakh", Population as "Population" from(
Select date_1,cum_Confirmed,cum_Recovered,cum_Confirmed-cum_Recovered-cum_Deceased-cum_Other as Active,cum_Deceased,cum_Other,cum_Tested,cum_Total_Doses_Administered,(cum_Confirmed-cum_Recovered-cum_Deceased-cum_Other)/cum_Confirmed as a1, cum_Recovered/cum_Confirmed as a2, cum_Deceased/cum_Confirmed as a3, cum_Confirmed/cum_Tested as a4,cum_Confirmed/Population*100000 as a5, cum_Recovered/Population*100000 as a6, (cum_Confirmed-cum_Recovered-cum_Deceased-cum_Other)/Population*100000 as a7, cum_Deceased/Population*100000 as a8, cum_Other/Population*100000 as a9,cum_Tested/Population*100000 as a10,cum_Total_Doses_Administered/Population*100000 as a11,Population from(
Select date_1,cum_Confirmed-lag(cum_Confirmed) over(order by date_1) as cum_Confirmed,cum_Recovered-lag(cum_Recovered) over(order by date_1) as cum_Recovered,cum_Deceased-lag(cum_Deceased) over(order by date_1) as cum_Deceased, cum_Other-lag(cum_Other) over(order by date_1) as cum_Other, cum_Tested-lag(cum_Tested) over(order by date_1) as cum_Tested,cum_Total_Doses_Administered-lag(cum_Total_Doses_Administered) over(order by date_1) as cum_Total_Doses_Administered,population from
( 
Select * from(
Select India_Cumulative.date_1,cum_Confirmed,cum_Recovered,Active,cum_Deceased,cum_Other,coalesce(cum_Total_Doses_Administered,0) as cum_Total_Doses_Administered,cum_Tested
from India_Cumulative left outer join India_Vaccine_Cumulative
on India_Cumulative.date_1=India_Vaccine_Cumulative.date_1) as temp1,India_population
where date_1=$1 or date_1=$2
) 
as temp2
order by date_1 desc limit 1
) as temp3
) as temp4
;

execute india_summary(%s, %s);
--execute india_summary('26-04-2020','10-03-2021');
--deallocate india_summary;
