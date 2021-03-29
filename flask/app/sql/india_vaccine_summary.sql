Prepare india_vaccine_summary(date,date) as
Select cum_Total_Doses_Administered as "Total Dose",cum_First_Dose_Administered as "First Dose",cum_Second_Dose_Administered as "Second Dose", cum_Male_Individuals_Vaccinated as "Males Vaccinated", cum_Female_Individuals_Vaccinated as "Females Vaccinated", cum_Transgender_Individuals_Vaccinated as "Transgender Vaccinated", cum_Total_Sessions_Conducted as "Total Sessions Conducted", 
cum_Total_Covaxin_Administered as "Total Covaxin", cum_Total_CoviShield_Administered as "Total Covishield", a1 as "Percentage Vaccinated (first dose)", a2 as "Total Dose per lakh", a3 as "First Dose per lakh", a4 as "Second Dose per lakh" from(
Select cum_Total_Doses_Administered,cum_First_Dose_Administered,cum_Second_Dose_Administered,cum_Male_Individuals_Vaccinated,cum_Female_Individuals_Vaccinated,cum_Transgender_Individuals_Vaccinated,cum_Total_Sessions_Conducted,cum_Total_Covaxin_Administered,cum_Total_CoviShield_Administered,round(cum_First_Dose_Administered/cum_Total_Doses_Administered,2) as a1,round(cum_Total_Doses_Administered/population*100000,2) as a2, round(cum_First_Dose_Administered/population*100000,2) as a3,round(cum_Second_Dose_Administered/population*100000,2) as a4 from(
Select 
cum_Total_Doses_Administered-lag(cum_Total_Doses_Administered) over( order by date_1) as cum_Total_Doses_Administered,
cum_First_Dose_Administered-lag(cum_First_Dose_Administered) over(order by date_1) as cum_First_Dose_Administered,
cum_Second_Dose_Administered-lag(cum_Second_Dose_Administered) over(order by date_1) as cum_Second_Dose_Administered,
cum_Male_Individuals_Vaccinated-lag(cum_Male_Individuals_Vaccinated) over(order by date_1) as cum_Male_Individuals_Vaccinated,
cum_Female_Individuals_Vaccinated-lag(cum_Female_Individuals_Vaccinated) over(order by date_1) as cum_Female_Individuals_Vaccinated,
cum_Transgender_Individuals_Vaccinated-lag(cum_Transgender_Individuals_Vaccinated) over(order by date_1) as cum_Transgender_Individuals_Vaccinated,
cum_Total_Sessions_Conducted-lag(cum_Total_Sessions_Conducted) over(order by date_1) as cum_Total_Sessions_Conducted,
cum_Total_Covaxin_Administered-lag(cum_Total_Covaxin_Administered) over(order by date_1) as cum_Total_Covaxin_Administered,
cum_Total_CoviShield_Administered-lag(cum_Total_CoviShield_Administered) over(order by date_1) as cum_Total_CoviShield_Administered,
population from(
Select * from India_Vaccine_Cumulative,India_population
where date_1=$1 or date_1=$2) as temp1
order by date_1 desc
limit 1) as temp2)
 as temp3
;


execute india_vaccine_summary('01-02-2021','10-03-2021');
deallocate india_vaccine_summary;