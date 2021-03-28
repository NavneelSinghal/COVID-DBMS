
Create Materialized view State_Vaccine_Cumulative as
select date_1,state_id,
sum(Total_Individuals_Registered)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Total_Individuals_Registered,
sum(Total_Sessions_Conducted)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Total_Sessions_Conducted,
sum(Total_Sites)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Total_Sites,
sum(First_Dose_Administered)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_First_Dose_Administered,
sum(Second_Dose_Administered)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Second_Dose_Administered,
sum(Male_Individuals_Vaccinated)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Male_Individuals_Vaccinated,
sum(Female_Individuals_Vaccinated)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Female_Individuals_Vaccinated,
sum(Transgender_Individuals_Vaccinated)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Transgender_Individuals_Vaccinated,
sum(Total_Covaxin_Administered)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Total_Covaxin_Administered,
sum(Total_CoviShield_Administered)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Total_CoviShield_Administered,
sum(Total_Doses_Administered)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Total_Doses_Administered,
sum(Total_Individuals_Vaccinated)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Total_Individuals_Vaccinated
from vaccine_daily
order by state_id,date_1;

Create Materialized View India_population as 
Select sum(Population) as Population 
from
state_and_ut;

Create Materialized View India_Vaccine_Cumulative as
Select date_1,
sum(cum_Total_Individuals_Registered) as cum_Total_Individuals_Registered,
sum(cum_Total_Sessions_Conducted) as cum_Total_Sessions_Conducted,
sum(cum_Total_Sites) as cum_Total_Sites,
sum(cum_First_Dose_Administered) as cum_First_Dose_Administered,
sum(cum_Second_Dose_Administered) as cum_Second_Dose_Administered,
sum(cum_Male_Individuals_Vaccinated) as cum_Male_Individuals_Vaccinated,
sum(cum_Female_Individuals_Vaccinated) as cum_Female_Individuals_Vaccinated,
sum(cum_Transgender_Individuals_Vaccinated) as cum_Transgender_Individuals_Vaccinated,
sum(cum_Total_Covaxin_Administered) as cum_Total_Covaxin_Administered,
sum(cum_Total_CoviShield_Administered) as cum_Total_CoviShield_Administered,
sum(cum_Total_Doses_Administered) as cum_Total_Doses_Administered,
sum(cum_Total_Individuals_Vaccinated) as cum_Total_Individuals_Vaccinated
from State_Vaccine_Cumulative
group by date_1
order by date_1;

Create Materialized View State_Cumulative as 
select *,
cum_Confirmed-cum_Recovered-cum_Other-cum_Deceased as Active from(
select date_1,state_id,
sum(confirmed)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Confirmed,
sum(Recovered)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Recovered,
sum(Deceased)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Deceased,
sum(Other)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Other,
sum(Tested)over(partition by state_id order by date_1 rows between unbounded preceding and current row) as cum_Tested
from state_daily) as temp1
order by state_id,date_1;


Create Materialized View District_Cumulative as 
select *,
cum_Confirmed-cum_Recovered-cum_Other-cum_Deceased as Active from(
select date_1,District_id,
sum(confirmed)over(partition by district_id order by date_1 rows between unbounded preceding and current row) as cum_Confirmed,
sum(Recovered)over(partition by district_id order by date_1 rows between unbounded preceding and current row) as cum_Recovered,
sum(Deceased)over(partition by district_id order by date_1 rows between unbounded preceding and current row) as cum_Deceased,
sum(Other)over(partition by district_id order by date_1 rows between unbounded preceding and current row) as cum_Other
from district_daily) as temp1
where district_id=366
order by District_id,date_1;

Create Materialized View India_Cumulative as
Select date_1,sum(cum_Confirmed) as cum_Confirmed,sum(cum_Recovered) as cum_Recovered,sum(cum_Deceased) as cum_Deceased, sum(cum_Other) as cum_Other,sum(cum_Tested) as cum_Tested, sum(Active) as active
from State_Cumulative 
group by date_1
order by date_1;

Create Materialized view India_Daily as 
Select *,confirmed-Recovered-other-Deceased as active from(
Select date_1,sum(confirmed) as confirmed,sum(Recovered) as Recovered, sum(Deceased) as Deceased, sum(Other) as Other, sum(Tested) as Tested
from state_daily
group by date_1)
as temp1
order by date_1;

Create Materialized view India_Vaccine_daily as
Select date_1,
sum(Total_Individuals_Registered) as Total_Individuals_Registered,
sum(Total_Sessions_Conducted) as Total_Sessions_Conducted,
sum(Total_Sites) as Total_Sites,
sum(First_Dose_Administered) as First_Dose_Administered,
sum(Second_Dose_Administered) as Second_Dose_Administered,
sum(Male_Individuals_Vaccinated) as Male_Individuals_Vaccinated,
sum(Female_Individuals_Vaccinated) as Female_Individuals_Vaccinated,
sum(Transgender_Individuals_Vaccinated) as Transgender_Individuals_Vaccinated,
sum(Total_Covaxin_Administered) as Total_Covaxin_Administered,
sum(Total_CoviShield_Administered) as Total_CoviShield_Administered,
sum(Total_Doses_Administered) as Total_Doses_Administered,
sum(Total_Individuals_Vaccinated) as Total_Individuals_Vaccinated
from vaccine_daily
group by date_1
order by date_1;



-- Drop Materialized view India_Vaccine_daily;
-- Drop Materialized view India_Daily;
-- Drop Materialized View India_Cumulative;
-- Drop Materialized View India_Vaccine_Cumulative;
-- Drop materialized view State_Vaccine_Cumulative;
-- Drop materialized view District_Cumulative;
-- Drop materialized view State_Cumulative;
-- Drop Materialized View India_population;
