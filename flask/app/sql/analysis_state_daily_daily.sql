Prepare analysis_state_daily_daily(int,date,date,text,text) as 
Select * from(
    Select state as "Name",
        date_1 as "Date",
        Confirmed as "Confirmed Cases",
        Recovered as "Recovered Cases", 
        Active as "Active Cases",
        Deceased as "Deceased Cases",
        Other as "Other Cases", 
        Tested as "Tested", 
        coalesce(Total_Doses_Administered,0) as "Total Vaccine Doses" ,
        round(active::decimal/nullif(confirmed,0),2) as "Active Ratio",
        round(recovered:: decimal/nullif(confirmed,0),2) as "Recovery Ratio",
        round(confirmed:: decimal/nullif(tested,0),2) as "Test Positivity Ratio",
        round(deceased::decimal/nullif(confirmed,0),2) as "Fatality Ratio"
    from(
        Select state,
            state_id,
            date_1,
            Confirmed,
            Recovered,
            Active,
            Deceased,
            Other,
            Tested,
            Total_Doses_Administered 
        from(
            Select * 
            from (
                Select state_daily.state_id, 
                    state_Daily.date_1,
                    confirmed,
                    Recovered,
                    Deceased,
                    other,
                    Tested,
                    confirmed-Recovered-Deceased-other as active,
                    coalesce(Total_Doses_Administered,0) as Total_Doses_Administered
                from state_Daily left outer join vaccine_daily
                on state_Daily.date_1=Vaccine_daily.date_1
                and state_daily.state_id=Vaccine_daily.state_id) as temp1 
            natural join state_and_ut)as temp2 ) as temp3
    where state_id=$1
    and date_1>=$2 and date_1<=$3
    ) as temp4
ORDER BY CASE
             WHEN $4='Confirmed Cases' and $5= 'ASC' THEN "Confirmed Cases"
         END,
         CASE
             WHEN $4='Confirmed Cases' and $5= 'DSC' THEN "Confirmed Cases" 
         END desc,
         CASE
             WHEN $4='Recovered Cases' and $5= 'ASC' THEN "Recovered Cases"
         END,
         CASE
             WHEN $4='Recovered Cases' and $5= 'DSC' THEN "Recovered Cases" 
         END desc,
         CASE
             WHEN $4='Deceased Cases' and $5= 'ASC' THEN "Deceased Cases"
         END,
         CASE
             WHEN $4='Deceased Cases' and $5= 'DSC' THEN "Deceased Cases" 
         END desc,
         CASE
             WHEN $4='Active Cases' and $5= 'ASC' THEN "Active Cases"
         END,
         CASE
             WHEN $4='Active Cases' and $5= 'DSC' THEN "Active Cases" 
         END desc,
         CASE
             WHEN $4='Other Cases' and $5= 'ASC' THEN "Other Cases"
         END,
         CASE
             WHEN $4='Other Cases' and $5= 'DSC' THEN "Other Cases" 
         END desc,
         CASE
             WHEN $4='Tested' and $5= 'ASC' THEN "Tested"
         END,
         CASE
             WHEN $4='Tested' and $5= 'DSC' THEN "Tested" 
         END desc,
         CASE
             WHEN $4='Total Vaccine Doses' and $5= 'ASC' THEN "Total Vaccine Doses"
         END,
         CASE
             WHEN $4='Total Vaccine Doses' and $5= 'DSC' THEN "Total Vaccine Doses" 
         END desc
         ,
         CASE
             WHEN $4='Active Ratio' and $5='ASC' THEN "Active Ratio"
         END,
         CASE
             WHEN $4='Active Ratio' and $5='DSC' THEN "Active Ratio" 
         END desc,
         CASE
             WHEN $4='Recovery Ratio' and $5= 'ASC' THEN "Recovery Ratio"
         END,
         CASE
             WHEN $4='Recovery Ratio' and $5= 'DSC' THEN "Recovery Ratio" 
         END desc,
         CASE
             WHEN $4='Test Positivity Ratio' and $5='ASC' THEN "Test Positivity Ratio"
         END,
         CASE
             WHEN $4='Test Positivity Ratio' and $5='DSC' THEN "Test Positivity Ratio" 
         END desc,
         CASE
             WHEN $4='Fatality Ratio' and $5= 'ASC' THEN "Fatality Ratio"
         END,
         CASE
             WHEN $4='Fatality Ratio' and $5= 'DSC' THEN "Fatality Ratio" 
         END desc
LIMIT 300;

-- EXECUTE analysis_state_daily_daily(%s, %s, %s, %s, %s);

execute analysis_state_daily_daily(17,'01-05-2020','01-11-2020','Active Cases','ASC');
deallocate analysis_state_daily_daily;



