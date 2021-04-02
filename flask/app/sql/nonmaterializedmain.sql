DROP VIEW india_cumulative;


DROP VIEW india_vaccine_cumulative;


DROP VIEW india_vaccine_daily;


DROP VIEW india_daily;


DROP VIEW state_vaccine_cumulative;


DROP VIEW district_cumulative;


DROP VIEW state_cumulative;


DROP VIEW india_population;

CREATE VIEW state_vaccine_cumulative AS
SELECT date_1,
       state_id,
       sum(total_individuals_registered) over( PARTITION BY state_id
                                              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_individuals_registered,
       sum(total_sessions_conducted) over( PARTITION BY state_id
                                          ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_sessions_conducted,
       sum(total_sites) over( PARTITION BY state_id
                             ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_sites,
       sum(first_dose_administered) over( PARTITION BY state_id
                                         ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_first_dose_administered,
       sum(second_dose_administered) over( PARTITION BY state_id
                                          ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_second_dose_administered,
       sum(male_individuals_vaccinated) over( PARTITION BY state_id
                                             ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_male_individuals_vaccinated,
       sum(female_individuals_vaccinated) over( PARTITION BY state_id
                                               ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_female_individuals_vaccinated,
       sum(transgender_individuals_vaccinated) over( PARTITION BY state_id
                                                    ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_transgender_individuals_vaccinated,
       sum(total_covaxin_administered) over( PARTITION BY state_id
                                            ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_covaxin_administered,
       sum(total_covishield_administered) over( PARTITION BY state_id
                                               ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_covishield_administered,
       sum(total_doses_administered) over( PARTITION BY state_id
                                          ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_doses_administered,
       sum(total_individuals_vaccinated) over( PARTITION BY state_id
                                              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_individuals_vaccinated
FROM vaccine_daily ;


CREATE VIEW india_population AS
SELECT sum(population) AS population
FROM state_and_ut ;

-- CREATE  VIEW india_vaccine_cumulative
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

CREATE VIEW state_cumulative AS
SELECT *,
       cum_confirmed - cum_recovered - cum_other - cum_deceased AS active
FROM
    (SELECT date_1,
            state_id,
            sum(confirmed) over( PARTITION BY state_id
                                ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_confirmed,
            sum(recovered) over( PARTITION BY state_id
                                ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_recovered,
            sum(deceased) over( PARTITION BY state_id
                               ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_deceased,
            sum(other) over( PARTITION BY state_id
                            ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_other,
            sum(tested) over( PARTITION BY state_id
                             ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_tested
     FROM state_daily) AS temp1 -- order by state_id,date_1
;


CREATE VIEW district_cumulative AS
SELECT *,
       cum_confirmed - cum_recovered - cum_other - cum_deceased AS active
FROM
    (SELECT date_1,
            district_id,
            sum(confirmed) over( PARTITION BY district_id
                                ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_confirmed,
            sum(recovered) over( PARTITION BY district_id
                                ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_recovered,
            sum(deceased) over( PARTITION BY district_id
                               ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_deceased,
            sum(other) over( PARTITION BY district_id
                            ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_other
     FROM district_daily) AS temp1 -- where district_id=366
-- order by District_id,date_1
;


CREATE VIEW india_daily AS
SELECT *,
       confirmed - recovered - other - deceased AS active
FROM
    (SELECT date_1,
            sum(confirmed) AS confirmed,
            sum(recovered) AS recovered,
            sum(deceased) AS deceased,
            sum(other) AS other,
            sum(tested) AS tested
     FROM state_daily
     GROUP BY date_1) AS temp1 -- order by date_1
;

-- CREATE  VIEW india_cumulative
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

CREATE VIEW india_cumulative AS
SELECT *,
       cum_confirmed - cum_recovered - cum_other - cum_deceased AS active
FROM
    (SELECT date_1,
            sum(confirmed) over(
                                ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_confirmed,
            sum(recovered) over(
                                ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_recovered,
            sum(deceased) over(
                               ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_deceased,
            sum(other) over(
                            ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_other,
            sum(tested) over(
                             ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_tested
     FROM india_daily) AS temp1 -- order by state_id,date_1
;


CREATE VIEW india_vaccine_daily AS
SELECT date_1,
       sum(total_individuals_registered) AS total_individuals_registered,
       sum(total_sessions_conducted) AS total_sessions_conducted,
       sum(total_sites) AS total_sites,
       sum(first_dose_administered) AS first_dose_administered,
       sum(second_dose_administered) AS second_dose_administered,
       sum(male_individuals_vaccinated) AS male_individuals_vaccinated ,
       sum(female_individuals_vaccinated) AS female_individuals_vaccinated,
       sum(transgender_individuals_vaccinated) AS transgender_individuals_vaccinated,
       sum(total_covaxin_administered) AS total_covaxin_administered,
       sum(total_covishield_administered) AS total_covishield_administered,
       sum(total_doses_administered) AS total_doses_administered,
       sum(total_individuals_vaccinated) AS total_individuals_vaccinated
FROM vaccine_daily
GROUP BY date_1 -- order by date_1
;


CREATE VIEW india_vaccine_cumulative AS
SELECT date_1,
       sum(total_individuals_registered) over(
                                              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_individuals_registered,
       sum(total_sessions_conducted) over(
                                          ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_sessions_conducted,
       sum(total_sites) over(
                             ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_sites,
       sum(first_dose_administered) over(
                                         ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_first_dose_administered,
       sum(second_dose_administered) over(
                                          ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_second_dose_administered,
       sum(male_individuals_vaccinated) over(
                                             ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_male_individuals_vaccinated,
       sum(female_individuals_vaccinated) over(
                                               ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_female_individuals_vaccinated,
       sum(transgender_individuals_vaccinated) over(
                                                    ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_transgender_individuals_vaccinated,
       sum(total_covaxin_administered) over(
                                            ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_covaxin_administered,
       sum(total_covishield_administered) over(
                                               ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_covishield_administered,
       sum(total_doses_administered) over(
                                          ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_doses_administered,
       sum(total_individuals_vaccinated) over(
                                              ORDER BY date_1 ROWS BETWEEN unbounded preceding AND CURRENT ROW) AS cum_total_individuals_vaccinated
FROM india_vaccine_daily ;
