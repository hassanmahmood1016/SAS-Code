libname project "C:\Users\hassan\Desktop\project";
data project.mink;
set mink;
run;

proc sql;
    create table project.totalmink as
    SELECT
           STATEid
           ,sum(mink_females) as totalmink, count(stateid) as number_obs    
           
    FROM project.mink
    GROUP BY STATEid
    order by STATEid;
quit;

data project.final;
set project.totalmink;
run;

proc sql;
    create table project.final as
    SELECT
           STATEid, totalmink, number_obs, (number_obs/sum(number_obs)) as percentobs  format=percent7.1, (totalmink/sum(totalmink)) as minkpercent format=percent7.1      
    FROM project.totalmink
    order by STATEid;
quit;

proc print data = project.final;
run;


data finally;
set project.fips;
run;

proc sort data = finally;
 by stateid;
 run;

 proc sort data = project.final;
 by stateid;
 run;

 

data last;
merge finally project.final;
if totalmink = . then delete;
by stateid;
run;

proc sort data=last;
by descending number_obs;

proc print data=last;
 run;


