PREPARE state_vaccine_summary(date,date,int) AS
SELECT state AS "Name",
       cum_total_doses_administered AS "Total Dose",
       cum_first_dose_administered AS "First Dose",
       cum_second_dose_administered AS "Second Dose",
       cum_male_individuals_vaccinated AS "Males Vaccinated",
       cum_female_individuals_vaccinated AS "Females Vaccinated",
       cum_transgender_individuals_vaccinated AS "Transgender Vaccinated",
       cum_total_sessions_conducted AS "Total Sessions Conducted",
       cum_total_covaxin_administered AS "Total Covaxin",
       cum_total_covishield_administered AS "Total Covishield",
       a1 AS "Percentage Vaccinated (first dose)",
       a2 AS "Total Dose per lakh",
       a3 AS "First Dose per lakh",
       a4 AS "Second Dose per lakh"
FROM
    (SELECT state,
            cum_total_doses_administered,
            cum_first_dose_administered,
            cum_second_dose_administered,
            cum_male_individuals_vaccinated,
            cum_female_individuals_vaccinated,
            cum_transgender_individuals_vaccinated,
            cum_total_sessions_conducted,
            cum_total_covaxin_administered,
            cum_total_covishield_administered,
            round(cum_first_dose_administered/nullif(cum_total_doses_administered,0),2) AS a1,
            round(cum_total_doses_administered/nullif(population,0)*100000,2) AS a2,
            round(cum_first_dose_administered/nullif(population,0)*100000,2) AS a3,
            round(cum_second_dose_administered/nullif(population,0)*100000,2) AS a4
     FROM
         (SELECT state_id,
                 state,
                 cum_total_doses_administered-lag(cum_total_doses_administered) over(PARTITION BY state_id
                                                                                     ORDER BY date_1) AS cum_total_doses_administered,
                 cum_first_dose_administered-lag(cum_first_dose_administered) over(PARTITION BY state_id
                                                                                   ORDER BY date_1) AS cum_first_dose_administered,
                 cum_second_dose_administered-lag(cum_second_dose_administered) over(PARTITION BY state_id
                                                                                     ORDER BY date_1) AS cum_second_dose_administered,
                 cum_male_individuals_vaccinated-lag(cum_male_individuals_vaccinated) over(PARTITION BY state_id
                                                                                           ORDER BY date_1) AS cum_male_individuals_vaccinated,
                 cum_female_individuals_vaccinated-lag(cum_female_individuals_vaccinated) over(PARTITION BY state_id
                                                                                               ORDER BY date_1) AS cum_female_individuals_vaccinated,
                 cum_transgender_individuals_vaccinated-lag(cum_transgender_individuals_vaccinated) over(PARTITION BY state_id
                                                                                                         ORDER BY date_1) AS cum_transgender_individuals_vaccinated,
                 cum_total_sessions_conducted-lag(cum_total_sessions_conducted) over(PARTITION BY state_id
                                                                                     ORDER BY date_1) AS cum_total_sessions_conducted,
                 cum_total_covaxin_administered-lag(cum_total_covaxin_administered) over(PARTITION BY state_id
                                                                                         ORDER BY date_1) AS cum_total_covaxin_administered,
                 cum_total_covishield_administered-lag(cum_total_covishield_administered) over(PARTITION BY state_id
                                                                                               ORDER BY date_1) AS cum_total_covishield_administered,
                 population
          FROM
              (SELECT *
               FROM state_vaccine_cumulative
               NATURAL JOIN state_and_ut
               WHERE date_1=$1
                   OR date_1=$2) AS temp1
          ORDER BY date_1 DESC
          LIMIT 37) AS temp2
     WHERE state_id=$3) AS temp3;

EXECUTE state_vaccine_summary(%s, %s, %s);
--EXECUTE state_vaccine_summary('01-02-2021','10-03-2021',23);
--DEALLOCATE state_vaccine_summary;
