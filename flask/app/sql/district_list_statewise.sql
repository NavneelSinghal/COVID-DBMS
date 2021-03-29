prepare district_list_statewise(int) as

Select District as "Name", district_id as "districtid" from district
where state_id =$1;

execute district_list_statewise(20) ;
deallocate district_list_statewise;

