PREPARE update_vaccinations(int,date,int,int,int,int,int,int,int,int,int,int,int) AS
UPDATE vaccine_daily
SET total_sessions_conducted=total_sessions_conducted+$3,
    total_individuals_registered=total_individuals_registered+$4,
    male_individuals_vaccinated=male_individuals_vaccinated+$5,
    female_individuals_vaccinated=female_individuals_vaccinated+$6,
    transgender_individuals_vaccinated=transgender_individuals_vaccinated+$7,
    first_dose_administered=first_dose_administered+$8,
    second_dose_administered=second_dose_administered+$9,
    total_doses_administered=total_doses_administered+$10,
    total_covaxin_administered=total_covaxin_administered+$11,
    total_covishield_administered=total_covishield_administered+$12,
    total_sites=total_sites+$13
WHERE state_id=$1
    AND date_1=$2;

EXECUTE update_vaccinations(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);
