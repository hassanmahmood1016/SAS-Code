libname corn 'C:\Users\salmanmahmood15\Desktop\homework2'; 


data corn.hw2;
 INPUT id name$ acres yield  soy STATE$;
 cards;

 1  keller  400  135    1  mo
 2  brown   800  179    1  mo
 3  jones   650  155    1  mo
 4  green   335  200    0  mo
 5  henry   450  181    1  mo
 6  smith   176  163    1  mo
 7  grant   700  203    0  mo
 8  hughes  206  187    1  mo
 9  emmons  308  191    1  mo
 10 lindsay 250  174    0  ks
 11 eifert  310  195    0  ks
 12 ramey    80  145    1  ks
 13 thorsen 160  172    1  ks
 14 meyer   240  183    1  ks
 15 henry   300  165    1  ks
 16 graves  140  120    0  ks
 17 patrick 500  175    1  ks
 18 kirk    950  202    1  ks
 19 lowe    840  195    1  ks
 ;

 /* PROC  is for 'procedure'. */

proc print data = corn.hw2;
run;




proc freq data=corn.hw2;
tables soy / out = outputsoy;
run;

libname dataset "C:\Users\salmanmahmood15\Desktop\homework2";
data dataset.outputsoy;
set outputsoy;
run;

