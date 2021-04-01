Prepare insert_vaccinations(int,date,int,int,int,int,int,int,int,int,int,int,int) as 
insert into vaccine_daily(state_id,date_1,Total_Sessions_Conducted, Total_Individuals_Registered,Male_Individuals_Vaccinated,Female_Individuals_Vaccinated,Transgender_Individuals_Vaccinated,First_Dose_Administered,Second_Dose_Administered,Total_Doses_Administered,Total_Covaxin_Administered,Total_CoviShield_Administered,Total_Sites)
values ($1,$2,$3,$4,$5,$6,$7,$8,$9,10,$11,$12,$13);

insert_vaccinations(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);