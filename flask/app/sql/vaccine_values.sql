PREPARE vaccine_values(int,date) AS
SELECT total_doses_administered AS "Total Dose",
       first_dose_administered AS "First Dose",
       second_dose_administered AS "Second Dose",
       male_individuals_vaccinated AS "Male Vaccinated",
       female_individuals_vaccinated AS "Female Vaccinated",
       transgender_individuals_vaccinated AS "Transgender Vaccinated",
       total_sessions_conducted AS "Total Sessions Conducted",
       total_covaxin_administered AS "Total Covaxin",
       total_covishield_administered AS "Total Covishield"
FROM vaccine_daily
WHERE state_id=$1
    AND date_1=$2 ;

EXECUTE vaccine_values(%s,%s);
