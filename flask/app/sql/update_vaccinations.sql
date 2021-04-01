Prepare update_vaccinations(int,date,int,int,int,int,int,int,int,int,int,int,int) as 
update vaccine_daily
set Total_Sessions_Conducted=Total_Sessions_Conducted+$3,
Total_Individuals_Registered=Total_Individuals_Registered+$4,
Male_Individuals_Vaccinated=Male_Individuals_Vaccinated+$5,
Female_Individuals_Vaccinated=Female_Individuals_Vaccinated+$6,
Transgender_Individuals_Vaccinated=Transgender_Individuals_Vaccinated+$7,
First_Dose_Administered=First_Dose_Administered+$8,
Second_Dose_Administered=Second_Dose_Administered+$9,
Total_Doses_Administered=Total_Doses_Administered+$10,
Total_Covaxin_Administered=Total_Covaxin_Administered+$11,
Total_CoviShield_Administered=Total_CoviShield_Administered+$12,
Total_Sites=Total_Sites+$13
where state_id=$1 and date_1=$2;

update_vaccinations(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);