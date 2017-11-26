libname project "C:\Users\salmanmahmood15\Desktop\project";
data project.mink;
set mink;
run;

proc sql;
    create table project.totalmink as
    SELECT
           STATEid, district, county, poid, mink_females, (mink_females/sum(mink_females))as stateminkpercent format=7.1       
        
    FROM project.mink
    GROUP BY STATEid
    order by STATEid;
quit;



proc sort data=project.totalmink;
by stateid mink_females;
run;

data project.totalmink;
set project.totalmink;
stateminkpercent = (stateminkpercent) * 100;
run;

data B;
do until (last.stateid);
set project.totalmink;
by stateid;
stateminkpercentmax= max(stateminkpercent, stateminkpercentmax);
end;
stateminkpercent = stateminkpercentmax;
drop stateminkpercentmax;
run;

libname project "C:\Users\salmanmahmood15\Desktop\project";
data fips;
set project.fips;
run;

proc sort data = fips;
 by stateid;
 run;


 data final;
 set B;
 run;

data last;
merge fips final;
if district=. then delete;
if stateminkpercent=100.000 then delete;
by stateid;
run;

proc print data=last;
run;
