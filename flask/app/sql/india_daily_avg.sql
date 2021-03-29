Prepare india_daily_avg(int) as 
Select date_1 as "Date",Round(avg(confirmed) over (order by date_1 rows between 6 preceding and current row),2) as "Confirmed Cases", Round(avg(Recovered) over (order by date_1 rows between 6 preceding and current row),2) as "Recovered Cases", Round(avg(Active) over (order by date_1 rows between 6 preceding and current row),2) as "Active Cases", Round(avg(Deceased) over (order by date_1 rows between 6 preceding and current row),2) as "Deceased Cases", Round(avg(Other) over (order by date_1 rows between 6 preceding and current row),2) as "Other Cases", Round(avg(Tested) over (order by date_1 rows between 6 preceding and current row),2) as "Tested", Round(Coalesce(avg(Total_Doses_Administered) over (order by date_1 rows between 6 preceding and current row),0),2) as "Total Vaccine Doses" from (
Select date_1,Confirmed,Recovered,Active,Deceased,Other,Tested,Total_Doses_Administered from(
Select * from (
Select India_Daily.date_1,confirmed,Recovered,Deceased,other,Tested,active,Total_Doses_Administered 
from India_Daily left outer join India_Vaccine_daily
on India_Daily.date_1=India_Vaccine_daily.date_1) as temp1, India_population)
as temp2 )
as temp3
order by date_1 desc
limit $1;

execute india_daily_avg(4);
deallocate india_daily_avg;