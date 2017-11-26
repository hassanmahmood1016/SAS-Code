libname project "C:\Users\TEMP\Desktop\project";


/* question1 */
data project.cotton_ops;
set project.cotton_ops;
run;

proc sql;
create table project.cotton_ops as
select poid, county, state, acres_owned, acres_rented_from, acres_rented_t0, corn_acres_harv, 
soy_acres_harv, upland_cotton_acres_harv, pima_cotton_acres_harv, fertilizer_exp, chem_exp, 
COTTON_ACRES, (ACRES_OWNED + ACRES_RENTED_FROM - acres_rented_t0 ) as ACRES_OPERATED,
(UPLAND_COTTON_ACRES_harv + PIMA_COTTON_ACRES_harv) as cotton_harv

from project.cotton_ops
group by STATE;
quit;

run;

libname project "C:\Users\TEMP\Desktop\project";
data project.cotton_ops;
set project.cotton_ops;
run;

proc sql;
create table project.cotton_ops as
select poid, county, state, acres_owned, acres_rented_from, acres_rented_t0, corn_acres_harv, 
soy_acres_harv, upland_cotton_acres_harv, pima_cotton_acres_harv, fertilizer_exp, chem_exp, COTTON_ACRES,
acres_operated, cotton_harv, 
(CORN_ACRES_HARV+ SOY_ACRES_HARV + COTTON_HARV) as crop_acres
from project.cotton_ops
group by STATE;
quit;

run;

/*  question 2.1 */
proc corr data = project.cotton_ops;
var cotton_harv acres_operated;
run;

/*  question 2.2 */
proc corr data = project.cotton_ops;
var fertilizer_exp chem_exp crop_acres;
run;

/*  question 2.3 */
proc means data = project.cotton_ops;
	 class state;
	 var cotton_harv;
	 run;

/*  question 2.4 */

proc means data = project.cotton_ops;
	 class state;
	 var crop_acres cotton_harv;
	 run;
/*  question 2.5 */

proc univariate data = project.cotton_ops;
	 var cotton_harv;
	 histogram;
	 run;


/*  question 2.6 */
proc means data = project.cotton_ops;
	 class state;
	 var pima_cotton_acres_harv upland_cotton_acres_harv;
	 run;

/* question 3 /*

PROC SQL;
create table project.cotton_summary as
SELECT state, count(poid) as state_ops,  sum( cotton_harv) as state_cotton

FROM project.cotton_ops
group by state;
QUIT;



PROC SQL;
create table project.cotton_summary as
SELECT state, state_ops, state_cotton,
(100*state_ops/sum(state_ops))  as ops_pct format 7.1,
(100*state_cotton/sum(state_cotton)) as cotton_pct format 7.1
FROM project.cotton_summary

QUIT;

proc sort data = project.cotton_summary;
by descending state_cotton;
run;


proc export 
data = project.cotton_summary
dbms = xlsx
outfile= "C:\Users\TEMP\Desktop\project\Summary.xlsx"
replace;
   run;



/*question 4*/

proc sql;
create table state2 as
select * 
from project.cotton_summary as A left join project.Cotton_ops as B
on A.state = B.state;
quit;

%MACRO stratify(state,k);

data state_&state;
set project.cotton_pop;
where state = &state;
output;
run;

proc sort data = state_&state;
by Cotton_Acres;
run;


proc iml;

use state_&state;
read all var {state COTTON_ACRES} into COTTON;



COTTON_TOTAL = sum(COTTON[,2]);



N_OPS = NROW(COTTON);
COTTON_CUM = J(N_OPS,1,0);


COTTON_CUM[1] = COTTON[1,2];

do i = 2 to N_OPS;
COTTON_CUM[i] = COTTON_CUM[i-1] + COTTON[i,2];
end;


COTTON_CUM = COTTON_CUM/COTTON_TOTAL;

NSTRATA = &k;


STRAT = J(N_OPS,1,NSTRATA);

do i = 1 to N_OPS;
do j = 1 to NSTRATA;
if COTTON_CUM[i] < (NSTRATA - j)/NSTRATA then STRAT[i,1] = NSTRATA - j;
end;
end;


STRATUM = J(N_OPS, 1, 0);

do i = 1 to N_OPS;

STRATUM[i] = 100*COTTON[i,1] + STRAT[i,1];

end;

COTTON = COTTON || STRATUM;

var = {state COTTON_ACRES stratum};

create strat_&state from COTTON[colname = var];
append from COTTON;
close strat_&state;
quit;

data Full_&state;
merge state_&state strat_&state;
run;

%mend stratify;

%stratify(48,5);
run;
%stratify(13,4);
run;
%stratify(37,4);
run;
%stratify(5,4);
run;
%stratify(28,3);
run;
%stratify(47,3);
run;
%stratify(6,4);
run;
%stratify(1,3);
RUN;
%stratify(29,3);
run;
%stratify(45,3);
run;
%stratify(22,3);
run;
%stratify(4,3);
run;

data stratified;
set Full_48
    Full_13
    Full_37
    Full_5
    Full_28
    Full_47
    Full_6
    Full_1
    Full_29
    Full_45
    Full_22
    Full_4;
output;
run;
proc sort data = project.stratify;
by stratum;
run;

proc means data = project.stratify noprint; 
var COTTON_ACRES; 
output out = sample_strat  (drop= _type_)
	sum(COTTON_ACRES) = strat_cotton;
by stratum;
run; 
data sample_strat1;
set sample_strat;
rename _freq_ = strat_ops;
output;
run;
proc iml;
use sample_strat1;
read all var {STRATUM strat_ops strat_cotton} into STRAT;

N_OPS = NROW(STRAT);

TOTAL_ACRES = sum(STRAT[,3]);

STRATUM = J(N_OPS,1,0);

do i = 1 to N_OPS;

STRATUM[i] = (STRAT[i,3]/TOTAL_ACRES) * 1200;
STRATUM[i] = ROUND(STRATUM[i]);
if STRATUM[i] > STRAT[i,2] then STRATUM[i] = STRAT[i,2];



end;


STRAT = STRAT || STRATUM;



var = {stratum strat_ops strat_cotton _NSIZE_};

create project.cotton_strat from STRAT[colname = var];
append from STRAT;
close project.cotton_strat;
quit;
proc print data = project.cotton_strat;
run;
/* question 5 */
proc surveyselect noprint data  = stratified out= project.sample method= srs n= project.cotton_strat seed = 9786;
strata stratum;
id STRATUM state POID county ACRES_OWNED ACRES_RENTED_FROM ACRES_RENTED_T0 CORN_ACRES_HARV SOY_ACRES_HARV FERTILIZER_EXP CHEM_EXP Cotton_Harv CROP_ACRES;
quit;
data weighted;
set project.Sample;
weighted_chem = CHEM_EXP * SamplingWeight;
weighted_fert = FERTILIZER_EXP * SamplingWeight;
output;
run;



proc means data = stratified noprint; 
var CROP_ACRES; 
output out = project.sample_totals  (drop= _type_)
	sum(CHEM_EXP) = strat_CHEM
	sum(FERTILIZER_EXP) = strat_fert;
by stratum;
run; 

proc means data = weighted noprint; 
var CROP_ACRES; 
output out = project.sample_totals  (drop= _type_)
	sum(weighted_chem) = strat_CHEM
	sum(weighted_fert) = strat_fert;
by stratum;
run; 
proc print data = project.pop_totals;
run;
proc print data = project.sample_totals;
run;

%MACRO state_samp(state);

%let outpath = C:\Users\TEMP\Desktop\project;
FILENAME setdirection PIPE "smdir &outpath";
data _null_;  
      infile setdirection;
      input;
      put _infile_;
run;


libname CURRENT "&outpath.";

data CURRENT.COTTON&state;
set project.sample;
if state = &state;
run;


%mend state_samp;


%state_samp(1);
run;
%state_samp(4);
run;
%state_samp(5);
run;
%state_samp(6);
run;
%state_samp(13);
run;
%state_samp(22);
run;
%state_samp(28);
run;
%state_samp(29);
run;
%state_samp(37);
run;
%state_samp(45);
run;
%state_samp(47);
run;
%state_samp(48);
run;


