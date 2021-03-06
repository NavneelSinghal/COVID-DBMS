Prepare india_vaccine_summary(date,date) as
Select cum_Total_Doses_Administered as "Total Dose",
       cum_First_Dose_Administered as "First Dose",
       cum_Second_Dose_Administered as "Second Dose",
       cum_Male_Individuals_Vaccinated as "Males Vaccinated",
       cum_Female_Individuals_Vaccinated as "Females Vaccinated",
       cum_Transgender_Individuals_Vaccinated as "Transgender Vaccinated",
       cum_Total_Sessions_Conducted as "Total Sessions Conducted",
       cum_Total_Covaxin_Administered as "Total Covaxin",
       cum_Total_CoviShield_Administered as "Total Covishield", 
       a1 as "Percentage Vaccinated (first dose)",
       a2 as "Total Dose per lakh",
       a3 as "First Dose per lakh",
       a4 as "Second Dose per lakh"
from(
  Select cum_Total_Doses_Administered,
         cum_First_Dose_Administered,
         cum_Second_Dose_Administered,
         cum_Male_Individuals_Vaccinated,
         cum_Female_Individuals_Vaccinated,
         cum_Transgender_Individuals_Vaccinated,
         cum_Total_Sessions_Conducted,
         cum_Total_Covaxin_Administered,
         cum_Total_CoviShield_Administered,
         round(100 * cum_First_Dose_Administered/NULLIF(cum_Total_Doses_Administered,0),2) as a1,
         round(cum_Total_Doses_Administered/NULLIF(population,0)*100000,2) as a2,
         round(cum_First_Dose_Administered/NULLIF(population,0)*100000,2) as a3,
         round(cum_Second_Dose_Administered/NULLIF(population,0)*100000,2) as a4
  from(
Select 
Coalesce(to_row.cum_Total_Doses_Administered,0)-coalesce(from_row.cum_Total_Doses_Administered,0) as cum_Total_Doses_Administered,
Coalesce(to_row.cum_First_Dose_Administered,0)-coalesce(from_row.cum_First_Dose_Administered,0) as cum_First_Dose_Administered,
Coalesce(to_row.cum_Second_Dose_Administered,0)-coalesce(from_row.cum_Second_Dose_Administered,0) as cum_Second_Dose_Administered,
Coalesce(to_row.cum_Male_Individuals_Vaccinated,0)-coalesce(from_row.cum_Male_Individuals_Vaccinated,0) as cum_Male_Individuals_Vaccinated,
Coalesce(to_row.cum_Female_Individuals_Vaccinated,0)-coalesce(from_row.cum_Female_Individuals_Vaccinated,0) as cum_Female_Individuals_Vaccinated,
Coalesce(to_row.cum_Transgender_Individuals_Vaccinated,0)-coalesce(from_row.cum_Transgender_Individuals_Vaccinated,0) as cum_Transgender_Individuals_Vaccinated,
Coalesce(to_row.cum_Total_Sessions_Conducted,0)-coalesce(from_row.cum_Total_Sessions_Conducted,0) as cum_Total_Sessions_Conducted,
Coalesce(to_row.cum_Total_Covaxin_Administered,0)-coalesce(from_row.cum_Total_Covaxin_Administered,0) as cum_Total_Covaxin_Administered,
Coalesce(to_row.cum_Total_CoviShield_Administered,0)-coalesce(from_row.cum_Total_CoviShield_Administered,0) as cum_Total_CoviShield_Administered,
population from
(Select *,1 as row_num from india_vaccine_cumulative
where date_1<$1 
order by date_1 desc
limit 1) as from_row full outer join 
(Select *,1 as row_num from india_vaccine_cumulative
where date_1<=$2
order by date_1 desc
limit 1) as to_row using(row_num)
full outer join
(Select population,1 as row_num from India_population) as pop_table 
using (row_num) ) as temp1 ) as temp2

;

execute india_vaccine_summary(%s,%s);
-- execute india_vaccine_summary('01-02-2021','10-03-2021');
-- deallocate india_vaccine_summary;
