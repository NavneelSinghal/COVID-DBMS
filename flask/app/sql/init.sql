drop table state_daily;
drop table district_daily;
drop table vaccine_daily;
drop table district;
drop table state_and_ut;



CREATE table state_and_ut(
    State_id bigint not NULL,
    State text ,
    Population bigint,
    constraint state_and_ut_key primary key(State_id)
);

CREATE table district(
    District_id bigint Not NULL,
    District text,
    State_id bigint not null references state_and_ut(State_id),
    Population bigint,
    constraint district_key primary key(District_id)
);

CREATE table state_daily(
    date1 Date not null,
    State_id bigint Not null references state_and_ut(State_id),
    Confimed bigint,
    Recovered bigint,
    Deceased bigint,
    Other bigint,
    Tested bigint,
    constraint state_daily_key primary key(date1,State_id)
);

CREATE table district_daily(
    date1 Date not null,
    District_id bigint Not null references District(District_id),
    Confimed bigint,
    Recovered bigint,
    Deceased bigint,
    Other bigint,
    Tested bigint,
    constraint district_daily_key primary key(date1,District_id)
);

Create table vaccine_daily(
    date1 Date not null,
    State_id bigint references state_and_ut(State_id),
    Total_Individuals_Registered bigint,
    Total_Sessions_Conducted bigint,
    Total_Sites bigint,
    First_Dose_Administered bigint,
    Second_Dose_Administered bigint,
    Male_Individuals_Vaccinated bigint,
    Female_Individuals_Vaccinated bigint,
    Transgender_Individuals_Vaccinated bigint,
    Total_Covaxin_Administered bigint,
    Total_CoviShield_Administered bigint,
    Total_Individuals_Vaccinated bigint,
    Total_Doses_Administered bigint,
    constraint vaccine_daily_key primary key(date1,State_id)

);


Delete from vaccine_daily
Delete from state_daily
Delete from district_daily
Delete from district
Delete from state_and_ut

\copy state_and_ut from './../../utils/output/state_and_ut.csv' csv header;
\copy district from './../../utils/output/district.csv' csv header;
\copy district_daily from './../../utils/output/district_daily.csv' csv header;
\copy state_daily from './../../utils/output/state_daily.csv' csv header;
\copy vaccine_daily from './../../utils/output/vaccine_daily.csv' csv header;
