Prepare state_daily_avg(int,int) as 
Select state as "Name",state_id,date_1 as "Date",Round(avg(confirmed) over (partition by state order by date_1 rows between 6 preceding and current row),2) as "Confirmed Cases", Round(avg(Recovered) over (partition by state order by date_1 rows between 6 preceding and current row),2) as "Recovered Cases", Round(avg(Active) over (partition by state order by date_1 rows between 6 preceding and current row),2) as "Active Cases", Round(avg(Deceased) over (partition by state order by date_1 rows between 6 preceding and current row),2) as "Deceased Cases", Round(avg(Other) over (partition by state order by date_1 rows between 6 preceding and current row),2) as "Other Cases", Round(avg(Tested) over (partition by state order by date_1 rows between 6 preceding and current row),2) as "Tested", Round(Coalesce(avg(Total_Doses_Administered) over (partition by state order by date_1 rows between 6 preceding and current row),0),2) as "Total Vaccine Doses" from (
Select state,state_id,date_1,Confirmed,Recovered, active,Deceased,Other,Tested,Total_Doses_Administered from(
Select * from (
Select state_Daily.state_id, state_Daily.date_1,confirmed,Recovered,Deceased,other,Tested,confirmed-Recovered-Deceased-other as active,Total_Doses_Administered 
from state_Daily left outer join Vaccine_daily
on state_Daily.date_1=Vaccine_daily.date_1
and state_daily.state_id=vaccine_daily.state_id
) as temp1 natural join state_and_ut)
as temp2 )
as temp3
where state_id=$2
order by date_1 desc 
limit $1;

execute state_daily_avg(4,20);
deallocate state_daily_avg;