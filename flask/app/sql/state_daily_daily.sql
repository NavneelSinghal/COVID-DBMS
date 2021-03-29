Prepare state_daily_daily(int) as
Select state as "Name",date_1 as "Date",Confirmed as "Confirmed Cases",Recovered as "Recovered Cases", Active as "Active Cases",Deceased as "Deceased Cases",Other as "Other Cases", Tested as "Tested", coalesce(Total_Doses_Administered,0) as "Total Vaccine Doses" from(
Select state,date_1,Confirmed,Recovered,Active,Deceased,Other,Tested,Total_Doses_Administered from(
Select * from (
Select state_daily.state_id, state_Daily.date_1,confirmed,Recovered,Deceased,other,Tested,confirmed-Recovered-Deceased-other as active,coalesce(Total_Doses_Administered,0) as Total_Doses_Administered
from state_Daily left outer join vaccine_daily
on state_Daily.date_1=Vaccine_daily.date_1
and state_daily.state_id=Vaccine_daily.state_id
) as temp1 natural join state_and_ut)
as temp2 
) as temp3
order by date_1 desc,state
limit 37*$1;

execute state_daily_daily(5);
deallocate state_daily_daily;
