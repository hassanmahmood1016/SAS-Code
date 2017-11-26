/* PROGRAM_7A */
/* MANIPULATING SAS DATA SETS */
/* Find the 10 US operations ( program states ) with the largest sales. */
/* Find the 5 operations with the the largest sales in each program state. */
libname GWU
'C:\Users\salmanmahmood15\Desktop\homework1';
/* Catfish has sales data for farm operations reporting catfish sales in 2016.
Variables StateId district county PoId sales */
/* StateId is the FIPS code for the state -
The file FIPS gives the state name and state abbreviation for the
corresponding FIPS code.
Let see how to attach the state name to our data using the MERGE statmement
..*/
proc sort data = fish.catfish;
by stateId;
proc sort data = fish.fips;
by stateId;
data catfish2;
merge fish.catfish fish.fips;
by stateId;
run;
/*proc print data = catfish2;
run;*/
data catfish2;
set catfish2;
if sales ne '.';
run;
/*proc print data = catfish2;
run;*/
/* Limit to PROGRAM STATES ...*/
data catfish3;
set catfish2;
if State in ( 'AL', 'AR','CA' ,'GA' ,'LA', 'MS', 'MO', 'NC' ,'TX' );
run;
/*proc print data = catfish3;
run;*/
/* Find the 10 largest catfish opearation - results are in data set BIG_FISH.
*/
proc sort data = catfish3 ;
by descending sales;

run;
data catfish4;
set catfish3;
rank = _N_;
run;
data big_fish;
set catfish4;
if rank < 11;
run;
/*---------------*/
/*proc print data = big_fish;
run;*/
/* Find the 5 operations with the the largest sales in each program state. */
proc sort data = catfish4;
by State descending sales;
run;
proc print data = big_fish;
run;
proc export
data = big_fish
dbms=xlsx
outfile=
"C:\Users\hassan\Desktop\homework1\big_fish.xlsx"
replace;
run;
