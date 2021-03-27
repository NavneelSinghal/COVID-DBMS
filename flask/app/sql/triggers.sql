drop trigger if exists district_to_state_daily on district_daily;
drop function if exists prop_to_state_daily;

create function prop_to_state_daily() returns trigger as
$$
  declare
	mystate_id bigint := (select state_id from district where district_id = new.district_id);
  begin
	if (new.date_1 is null) or (new.district_id is null) then
	  raise exception 'null key values impossible';
	end if;

	insert into state_daily values (new.date_1, mystate_id, 0, 0, 0, 0, 0)
	on conflict do nothing;

	if old is null then
	  update state_daily
	  set confirmed = confirmed + new.confirmed,
	      recovered = recovered + new.recovered,
		  deceased = deceased + new.deceased,
		  other = other + new.other
	  where
		(date_1, state_id) = (new.date_1, mystate_id);
	else
	  update state_daily
	  set confirmed = confirmed + (new.confirmed - old.confirmed),
	      recovered = recovered + (new.recovered - old.recovered),
		  deceased = deceased + (new.deceased - old.deceased),
		  other = other + (new.other - old.other)
	  where
		(date_1, state_id) = (new.date_1, mystate_id);
	end if;
	return new;
  end;
$$
language plpgsql
;

create trigger district_to_state_daily
  after insert or update on district_daily
  for each row
	execute procedure prop_to_state_daily()
;

-- \echo 'Datia, a district of Madhya Pradesh ...\n'
-- 
-- select * from district_daily
-- where (District_id = (select District_id from district where district = 'Datia')) AND
--   (date_1 = '2021-03-20')
-- ;
-- 
-- select * from state_daily
-- where (State_id = (select State_id from state_and_ut where state = 'Madhya Pradesh'))
-- AND (date_1 = '2021-03-20')
-- ;
-- 
-- \echo 'Now incrementing confirmed cases, deceased cases and recovered cases of datia by one on 20th March 2021\n'
-- 
-- update district_daily
-- set Confirmed = Confirmed + 1,
--     Deceased = Deceased + 1,
-- 	Recovered = Recovered + 1
-- where (District_id = (select District_id from district where district = 'Datia')) AND
--   (date_1 = '2021-03-20')
-- ;
-- 
-- \echo 'Updated values shown below ... \n'
-- 
-- select * from district_daily
-- where (District_id = (select District_id from district where district = 'Datia')) AND
--   (date_1 = '2021-03-20')
-- ;
-- 
-- select * from state_daily
-- where (State_id = (select State_id from state_and_ut where state = 'Madhya Pradesh'))
-- AND (date_1 = '2021-03-20')
-- ;
-- 
-- \echo 'Now attempting to insert new data of datia on 31st March (does not already exist in db)\n'
-- delete
-- from district_daily
-- where (District_id = (select District_id from district where district = 'Datia')) AND
--   (date_1 = '2021-03-31')
-- ;
-- 
-- delete
-- from state_daily
-- where (State_id = (select State_id from state_and_ut where state = 'Madhya Pradesh'))
-- AND (date_1 = '2021-03-31')
-- ;
-- 
-- insert
-- into district_daily
-- values ('2021-03-31', (select District_id from district where district = 'Datia'),
--   1, 1, 1, 0)
-- ;
-- 
-- select * from district_daily
-- where (District_id = (select District_id from district where district = 'Datia')) AND
--   (date_1 = '2021-03-31')
-- ;
-- 
-- select * from state_daily
-- where (State_id = (select State_id from state_and_ut where state = 'Madhya Pradesh'))
-- AND (date_1 = '2021-03-31')
-- ;
