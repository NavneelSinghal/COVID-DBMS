Drop Materialized View India_Cumulative;
Drop Materialized View India_Vaccine_Cumulative;
Drop Materialized view India_Vaccine_daily;
Drop Materialized view India_Daily;
Drop materialized view State_Vaccine_Cumulative;
Drop materialized view District_Cumulative;
Drop materialized view State_Cumulative;
Drop Materialized View India_population; 
CREATE materialized VIEW state_vaccine_cumulative
AS SELECT date_1,
          state_id,
          SUM(total_individuals_registered)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Individuals_Registered,
          SUM(total_sessions_conducted)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Sessions_Conducted,
          SUM(total_sites)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Sites,
          SUM(first_dose_administered)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_First_Dose_Administered,
          SUM(second_dose_administered)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Second_Dose_Administered,
          SUM(male_individuals_vaccinated)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Male_Individuals_Vaccinated,
          SUM(female_individuals_vaccinated)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Female_Individuals_Vaccinated,
          SUM(transgender_individuals_vaccinated)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Transgender_Individuals_Vaccinated,
          SUM(total_covaxin_administered)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Covaxin_Administered,
          SUM(total_covishield_administered)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_CoviShield_Administered,
          SUM(total_doses_administered)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Doses_Administered,
          SUM(total_individuals_vaccinated)
            over(
              PARTITION BY state_id
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Individuals_Vaccinated
   FROM   vaccine_daily
;

CREATE materialized VIEW india_population
AS SELECT SUM(population) AS Population
   FROM   state_and_ut
;

-- CREATE materialized VIEW india_vaccine_cumulative
-- AS SELECT date_1,
--           SUM(cum_total_individuals_registered)       AS
--              cum_Total_Individuals_Registered,
--           SUM(cum_total_sessions_conducted)           AS
--              cum_Total_Sessions_Conducted,
--           SUM(cum_total_sites)                        AS cum_Total_Sites,
--           SUM(cum_first_dose_administered)            AS
--              cum_First_Dose_Administered,
--           SUM(cum_second_dose_administered)           AS
--              cum_Second_Dose_Administered,
--           SUM(cum_male_individuals_vaccinated)        AS
--              cum_Male_Individuals_Vaccinated,
--           SUM(cum_female_individuals_vaccinated)      AS
--              cum_Female_Individuals_Vaccinated,
--           SUM(cum_transgender_individuals_vaccinated) AS
--           cum_Transgender_Individuals_Vaccinated,
--           SUM(cum_total_covaxin_administered)         AS
--              cum_Total_Covaxin_Administered,
--           SUM(cum_total_covishield_administered)      AS
--              cum_Total_CoviShield_Administered,
--           SUM(cum_total_doses_administered)           AS
--              cum_Total_Doses_Administered,
--           SUM(cum_total_individuals_vaccinated)       AS
--              cum_Total_Individuals_Vaccinated
--    FROM   state_vaccine_cumulative
--    GROUP  BY date_1
-- -- order by date_1
-- ;

CREATE materialized VIEW state_cumulative
AS SELECT *,
          cum_confirmed - cum_recovered - cum_other - cum_deceased AS Active
   FROM  (SELECT date_1,
                 state_id,
                 SUM(confirmed)
                   over(
                     PARTITION BY state_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Confirmed,
                 SUM(recovered)
                   over(
                     PARTITION BY state_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Recovered,
                 SUM(deceased)
                   over(
                     PARTITION BY state_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Deceased,
                 SUM(other)
                   over(
                     PARTITION BY state_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Other,
                 SUM(tested)
                   over(
                     PARTITION BY state_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Tested
          FROM   state_daily) AS temp1
-- order by state_id,date_1
;

CREATE materialized VIEW district_cumulative
AS SELECT *,
          cum_confirmed - cum_recovered - cum_other - cum_deceased AS Active
   FROM  (SELECT date_1,
                 district_id,
                 SUM(confirmed)
                   over(
                     PARTITION BY district_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Confirmed,
                 SUM(recovered)
                   over(
                     PARTITION BY district_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Recovered,
                 SUM(deceased)
                   over(
                     PARTITION BY district_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Deceased,
                 SUM(other)
                   over(
                     PARTITION BY district_id
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Other
          FROM   district_daily) AS temp1
-- where district_id=366
-- order by District_id,date_1
;



CREATE materialized VIEW india_daily
AS SELECT *,
          confirmed - recovered - other - deceased AS active
   FROM  (SELECT date_1,
                 SUM(confirmed) AS confirmed,
                 SUM(recovered) AS Recovered,
                 SUM(deceased)  AS Deceased,
                 SUM(other)     AS Other,
                 SUM(tested)    AS Tested
          FROM   state_daily
          GROUP  BY date_1) AS temp1
-- order by date_1
;

-- CREATE materialized VIEW india_cumulative
-- AS SELECT date_1,
--           SUM(cum_confirmed) AS cum_Confirmed,
--           SUM(cum_recovered) AS cum_Recovered,
--           SUM(cum_deceased)  AS cum_Deceased,
--           SUM(cum_other)     AS cum_Other,
--           SUM(cum_tested)    AS cum_Tested,
--           SUM(active)        AS active
--    FROM   state_cumulative
--    GROUP  BY date_1
-- -- order by date_1
-- ;

CREATE materialized VIEW india_cumulative
AS SELECT *,
          cum_confirmed - cum_recovered - cum_other - cum_deceased AS Active
   FROM  (SELECT date_1,
                 SUM(confirmed)
                   over(
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Confirmed,
                 SUM(recovered)
                   over(
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Recovered,
                 SUM(deceased)
                   over(
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Deceased,
                 SUM(other)
                   over(
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Other,
                 SUM(tested)
                   over(
                     ORDER BY date_1 ROWS BETWEEN unbounded preceding AND
                   CURRENT
                   ROW) AS
                 cum_Tested
          FROM   india_daily) AS temp1
-- order by state_id,date_1
;

CREATE materialized VIEW india_vaccine_daily
AS SELECT date_1,
          SUM(total_individuals_registered)       AS
          Total_Individuals_Registered,
          SUM(total_sessions_conducted)           AS Total_Sessions_Conducted,
          SUM(total_sites)                        AS Total_Sites,
          SUM(first_dose_administered)            AS First_Dose_Administered,
          SUM(second_dose_administered)           AS Second_Dose_Administered,
          SUM(male_individuals_vaccinated)        AS Male_Individuals_Vaccinated
          ,
          SUM(female_individuals_vaccinated)      AS
          Female_Individuals_Vaccinated,
          SUM(transgender_individuals_vaccinated) AS
             Transgender_Individuals_Vaccinated,
          SUM(total_covaxin_administered)         AS Total_Covaxin_Administered,
          SUM(total_covishield_administered)      AS
          Total_CoviShield_Administered,
          SUM(total_doses_administered)           AS Total_Doses_Administered,
          SUM(total_individuals_vaccinated)       AS
          Total_Individuals_Vaccinated
   FROM   vaccine_daily
   GROUP  BY date_1
-- order by date_1
;

CREATE materialized VIEW india_vaccine_cumulative
AS SELECT date_1,
          SUM(total_individuals_registered)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Individuals_Registered,
          SUM(total_sessions_conducted)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Sessions_Conducted,
          SUM(total_sites)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Sites,
          SUM(first_dose_administered)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_First_Dose_Administered,
          SUM(second_dose_administered)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Second_Dose_Administered,
          SUM(male_individuals_vaccinated)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Male_Individuals_Vaccinated,
          SUM(female_individuals_vaccinated)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Female_Individuals_Vaccinated,
          SUM(transgender_individuals_vaccinated)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Transgender_Individuals_Vaccinated,
          SUM(total_covaxin_administered)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Covaxin_Administered,
          SUM(total_covishield_administered)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_CoviShield_Administered,
          SUM(total_doses_administered)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Doses_Administered,
          SUM(total_individuals_vaccinated)
            over(
               
              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW)
          AS
          cum_Total_Individuals_Vaccinated
   FROM   india_vaccine_daily
;
