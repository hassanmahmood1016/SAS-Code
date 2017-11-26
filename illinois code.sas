libname project "C:\Users\hassan\Desktop\project";
data project.illinois_crops;
set project.illinois_crops;
run;


data project.illinois_crops;
set project.illinois_crops;
number_of_acres_operated = (acres_owned) +(acres_rented_from)-(acres_rented_t0);
run;



proc sql;
    create table project.acresrented as
    SELECT  corn_acres_harv, soy_acres_harv, winter_wheat_acres_harv, number_of_acres_operated, sum(number_of_acres_operated) as total_acres_operated,
sum(acres_rented_from) as total_acres_rented_from,
number_of-acres_operated
               
    FROM project.illinois_crops;

quit;



proc sql;
    create table project.all as
    SELECT sum(corn_acres_harv>0) as harvesting_corn, sum(soy_acres_harv>0) as harvesting_soy, sum(winter_wheat_acres_harv>0) as harvestingwheat,
sum(corn_acres_harv > 0 ! soy_acres_harv > 0 ! winter_wheat_acres_harv>0) as atleastone,
sum (corn_acres_harv = 0 & soy_acres_harv = 0 & winter_wheat_acres_harv >0) as onlywheat,
(total_acres_rented_from/total_acres_operated) as total_acres_rented_from_percent format=percent7.1,
sum(corn_acres_harv)as total_corn_acres_harv, 
sum(soy_acres_harv)as total_soy_acres_harv,
sum(winter_wheat_acres_harv)as total_winter_wheat_acres_harv,

ACRES_RENTED_FROM
 
    FROM project.acresrented;

quit;

proc sql;
create table project.illinois  as
select county, count(ACRES_OWNED) as total_farm_operations, sum(ACRES_OPERATED)as county_acres_operated, (sum(ACRES_RENTED_FROM)/sum(number_of_ACRES_OPERATED))as Totalacres_rentedfrom format=percent7.1
from project_illinois_crops
group by county;
quit;





data project.partB;
 infile "C:\Users\hassan\Desktop\project\data.txt" dlm= ','; 
 input state$ district county countyname$;
 run;


data project.B;
set project.partB;
run;

proc sort data = project.B;
 by county;
 run;

data project.illinois;
set project.illinois;
run;

proc sort data = project.illinois;
 by county;
 run;

 

data project.last;
merge project.illinois project.B;
by county;
run;

