Prepare analysis_india_daily_avg(date,date,text) as
Select * from(
Select date_1 as "Date",Round(avg(confirmed) over (order by date_1 rows between 6 preceding and current row),2) as "Confirmed Cases", Round(avg(Recovered) over (order by date_1 rows between 6 preceding and current row),2) as "Recovered Cases", Round(avg(Active) over (order by date_1 rows between 6 preceding and current row),2) as "Active Cases", Round(avg(Deceased) over (order by date_1 rows between 6 preceding and current row),2) as "Deceased Cases", Round(avg(Other) over (order by date_1 rows between 6 preceding and current row),2) as "Other Cases", Round(avg(Tested) over (order by date_1 rows between 6 preceding and current row),2) as "Tested", Round(Coalesce(avg(Total_Doses_Administered) over (order by date_1 rows between 6 preceding and current row),0),2) as "Total Vaccine Doses" from (
Select date_1,Confirmed,Recovered,Active,Deceased,Other,Tested,Total_Doses_Administered from(
Select * from (
Select India_Daily.date_1,confirmed,Recovered,Deceased,other,Tested,active,coalesce(Total_Doses_Administered,0) as Total_Doses_Administered
from India_Daily left outer join India_Vaccine_daily
on India_Daily.date_1=India_Vaccine_daily.date_1) as temp1, India_population)
as temp2 )
as temp3
where date_1>=$1 and date_1<=$2
) as temp4
order by
Case when $3='Confirmed Cases'  then "Confirmed Cases" end,
Case when $3='Recovered Cases'  then "Recovered Cases" end,
Case when $3='Deceased Cases'  then "Deceased Cases" end,
Case when $3='Active Cases'  then "Active Cases" end,
Case when $3='Other Cases'  then "Other Cases" end,
Case when $3='Tested'  then "Tested" end,
Case when $3='Total Vaccine Doses'  then "Total Vaccine Doses" end
-- Case when $3='Active Ratio'  then "Active Ratio" end,
-- Case when $3='Recovery Ratio'  then "Recovery Ratio" end,
-- Case when $3='Test Positivity Ratio'  then "Test Positivity Ratio" end,
-- Case when $3='Fatality Ratio'  then "Fatality Ratio" end,
limit 1;

execute analysis_india_daily_avg('01-05-2020','01-11-2020','Active Cases');
deallocate analysis_india_daily_avg;

