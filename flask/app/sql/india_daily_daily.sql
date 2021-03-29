Prepare india_daily_daily(int) as
Select date_1 as "Date",Confirmed as "Confirmed Cases",Recovered as "Recovered Cases", Active as "Active Cases",Deceased as "Deceased Cases",Other as "Other Cases", Tested as "Tested", coalesce(Total_Doses_Administered,0) as "Total Vaccine Doses" from(
Select date_1,Confirmed,Recovered,Active,Deceased,Other,Tested,Total_Doses_Administered from(
Select * from (
Select India_Daily.date_1,confirmed,Recovered,Deceased,other,Tested,active,Total_Doses_Administered 
from India_Daily left outer join India_Vaccine_daily
on India_Daily.date_1=India_Vaccine_daily.date_1) as temp1, India_population)
as temp2 
) as temp3
order by date_1 desc
limit $1;

execute india_daily_daily(5);
deallocate india_daily_daily;
