Prepare vaccine_values(int,date) as
Select Total_Doses_Administered as "Total Dose",
    First_Dose_Administered as "First Dose",
    Second_Dose_Administered as "Second Dose",
    Male_Individuals_Vaccinated as "Male Vaccinated",
    Female_Individuals_Vaccinated as "Female Vaccinated",
    Transgender_Individuals_Vaccinated as "Transgender Vaccinated",
    Total_Sessions_Conducted as "Total Sessions Conducted",
    Total_Covaxin_Administered as "Total Covaxin",
    Total_CoviShield_Administered as "Total Covishield"
 from vaccine_daily
where state_id=$1
and date_1=$2
;

execute vaccine_values(%s,%s);