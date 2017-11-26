libname homework "C:\Users\salmanmahmood15\Desktop\homework3";
data homework.concatenation;
set homework.trout_disqualify homework.trout_operations;
run;



Proc SQL ;
     Create table withcount as
          select *
               ,     count (poid) as count
          From homework.concatenation
          Group by poid;


data homework;
set withcount;
if count >1 then delete;
run;
