PREPARE state_vaccine_summary(date,date,int) AS
SELECT cum_total_doses_administered AS "Total Dose",
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
    (SELECT cum_total_doses_administered,
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
         (SELECT from_row.state_id,
                 coalesce(to_row.cum_total_doses_administered,0)-coalesce(from_row.cum_total_doses_administered,0) AS cum_total_doses_administered,
                 coalesce(to_row.cum_first_dose_administered,0)-coalesce(from_row.cum_first_dose_administered,0) AS cum_first_dose_administered,
                 coalesce(to_row.cum_second_dose_administered,0)-coalesce(from_row.cum_second_dose_administered,0) AS cum_second_dose_administered,
                 coalesce(to_row.cum_male_individuals_vaccinated,0)-coalesce(from_row.cum_male_individuals_vaccinated,0) AS cum_male_individuals_vaccinated,
                 coalesce(to_row.cum_female_individuals_vaccinated,0)-coalesce(from_row.cum_female_individuals_vaccinated,0) AS cum_female_individuals_vaccinated,
                 coalesce(to_row.cum_transgender_individuals_vaccinated,0)-coalesce(from_row.cum_transgender_individuals_vaccinated,0) AS cum_transgender_individuals_vaccinated,
                 coalesce(to_row.cum_total_sessions_conducted,0)-coalesce(from_row.cum_total_sessions_conducted,0) AS cum_total_sessions_conducted,
                 coalesce(to_row.cum_total_covaxin_administered,0)-coalesce(from_row.cum_total_covaxin_administered,0) AS cum_total_covaxin_administered,
                 coalesce(to_row.cum_total_covishield_administered,0)-coalesce(from_row.cum_total_covishield_administered,0) AS cum_total_covishield_administered,
                 population
          FROM
              ( SELECT *,
                       1 AS row_num
               FROM state_cumulative
               LEFT OUTER JOIN state_vaccine_cumulative USING (state_id,
                                                               date_1)
               WHERE state_cumulative.state_id = $3
                   AND state_cumulative.date_1 < $1
               ORDER BY state_cumulative.date_1 DESC
               LIMIT 1 ) AS from_row
          FULL OUTER JOIN
              ( SELECT *,
                       1 AS row_num
               FROM state_cumulative
               LEFT OUTER JOIN state_vaccine_cumulative USING (state_id,
                                                               date_1)
               WHERE state_cumulative.state_id = $3
                   AND state_cumulative.date_1 <= $2
               ORDER BY state_cumulative.date_1 DESC
               LIMIT 1 ) AS to_row USING (row_num)
          FULL OUTER JOIN
              ( SELECT population,
                       1 AS row_num
               FROM state_and_ut
               WHERE state_id = $3 ) AS pop_table USING (row_num) ) AS temp1 ) AS temp2 ;

EXECUTE state_vaccine_summary(%s, %s, %s);

-- EXECUTE state_vaccine_summary2('01-02-2022','10-03-2022',23);
-- DEALLOCATE state_vaccine_summary2;
