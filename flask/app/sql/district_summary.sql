-- Select * from District_Cumulative natural join district
Prepare district_summary(date,date,int) as

SELECT cum_confirmed as "Confirmed Cases",
       cum_recovered as "Recovered Cases",
       cum_active as "Active Cases",
       cum_deceased as "Deceased Cases",
       cum_other as "Other Cases",
       ROUND(cum_active/NULLIF(cum_confirmed, 0),2) as "Active Ratio",
       ROUND(cum_recovered/NULLIF(cum_confirmed, 0),2) as "Recovery Ratio",
       ROUND(cum_deceased/NULLIF(cum_confirmed, 0),2) as "Case Fatality Ratio",
       ROUND(cum_confirmed/NULLIF(population, 0)*100000,2) as "Confirmed per lakh",
       ROUND(cum_recovered/NULLIF(population, 0)*100000,2) as "Recovered per lakh",
       ROUND(cum_active/NULLIF(population, 0)*100000,2) as "Active per lakh",
       ROUND(cum_deceased/NULLIF(population, 0)*100000,2) as "Deceased per lakh",
       ROUND(cum_other/NULLIF(population, 0)*100000,2) as "Other per lakh",
       Population as "Population"
FROM
(
    Select 
            (COALESCE(to_row.cum_confirmed, 0) - COALESCE(from_row.cum_confirmed, 0)) as cum_confirmed,
            (COALESCE(to_row.cum_recovered, 0) - COALESCE(from_row.cum_recovered, 0)) as cum_recovered,
            (COALESCE(to_row.cum_deceased, 0) - COALESCE(from_row.cum_deceased, 0)) as cum_deceased,
            (COALESCE(to_row.cum_other, 0) - COALESCE(from_row.cum_other, 0)) as cum_other,
            (COALESCE(to_row.active, 0) - COALESCE(from_row.active, 0)) as cum_active,
            temp_row.population 
    FROM (
    Select *,1 as row_num from District_Cumulative natural join district
    where district_id=$3 and date_1<$1
    order by date_1 desc
    limit 1 ) as from_row full outer join
    (Select *,1 as row_num from District_Cumulative natural join district
    where district_id=$3 and date_1<=$2
    order by date_1 desc
    limit 1 ) as to_row using(row_num) full outer join
    (Select *,1 as row_num from District_Cumulative limit 1) as temp_row using (row_num) 
) as temp1
;



execute district_summary('01-01-2012','01-02-2012',366);
deallocate district_summary;