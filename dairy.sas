libname american  "C:\Users\hassan\Desktop\homework";
data final;
set gwu.missouri_dairy;
if milk_sales > 0;
run;

proc print data=final;
run;

proc iml;


/* Read the SAS data set gwu.missouri_dairy in a matrix called last */
/* ..and sort by sales ..*/

 use final;
 read all var { poid county milk_sales } into last;
 call sort(last, {3 1}, 3);

print last;

/* Find the cumulative fraction of sales for the sorted matrix.*/


 SALES_TOTAL = sum(last[ ,3]);
 N_OPS = NROW(last);
 SALES_CUM = J(N_OPS,1,0);

 SALES_CUM[1] = last[1,3];
 do i = 2 to N_OPS;
 SALES_CUM[i] = SALES_CUM[i-1] + last[i,3];
 end;

 SALES_CUM = SALES_CUM/SALES_TOTAL;

 last = last||SALES_CUM;

/* Classify operations into  NSTRATA groups ( strata ).*/


 NSTRATA = 4;

 STRATA = J(N_OPS,1,NSTRATA);

 do i = 1 to N_OPS;
 do j = 1 to NSTRATA;
 if last[i,4] < (NSTRATA - j)/NSTRATA then STRATA[i,1] = NSTRATA - j;
 end;
 end;

last = last||strata;


 /*print the last matrix*/

Print last;

 /* OUTPUT matrix last to a SAS data set last_classify.*/


   cname = {  poid county milk_sales cum strata_number };

      CREATE last_classify  FROM last[ colname = cname ];

      append from last; 
quit;

proc print data = last_classify;
run;


data last_classify;
set last_classify;
drop cum;
run;

proc print data=last_classify;
run;
