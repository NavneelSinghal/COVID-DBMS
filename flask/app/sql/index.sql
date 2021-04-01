 CREATE INDEX india_daily_date_index
  ON india_daily(date_1);

CREATE INDEX india_vaccine_daily_date_index
  ON india_vaccine_daily(date_1);

CREATE INDEX india_vaccine_cumulative_date_index
  ON india_vaccine_cumulative(date_1);

CREATE INDEX india_cumulative_date_index
  ON india_cumulative(date_1);

CREATE INDEX state_vaccine_cumulative_date_index
  ON state_vaccine_cumulative(date_1, state_id);

CREATE INDEX state_cumulative_date_index
  ON state_cumulative(date_1, state_id);

CREATE INDEX district_cumulative_date_index
  ON district_cumulative(date_1, district_id);  
