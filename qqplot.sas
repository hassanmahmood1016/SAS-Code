Data A;
do i = 1 to 200;
xvar = normal (0);
wvar = normal (1234587);
output;
end;
proc print data=a;
proc univariate noprint;
qqplot wvar/ normal (mu=0 sigma=1 color=red);
run;

%let nsamp = 200;
data normal;
do sample = 1 to &nsamp;
  meanx = 0;
  do obs = 1 to &nsamp;
    x = normal(0);
 meanx = ((meanx * (obs -1)) + x)/obs;
 output;
  end;
end;
run;

proc print data=normal;
run;
proc univariate noprint;
qqplot x/ normal (mu=0 sigma=1 color=red);
run;



%let n = 200 ;



data rands ;

     seed = 1234587 ;

     do i = 1 to &n ;

      
       rcauchy = rancau(1234587) ;
       
       output ;

     end ;

run ;
proc print data = rands ;
proc univariate noprint;
qqplot rcauchy/ normal (mu=0 sigma=1 color=red);
run;


proc iml;
call randseed (1234587);
X= J(200,1,1);
do i = 1 to 200;
do until (U <= exp(-(((Y-1)**2)/2)));
V=0;
call randgen(V,'uniform');
V=1-V;
Y=-log(V);
U=0;
call randgen(U,'uniform');
end;
X[i]=Y;
W=0;
call randgen (W,'uniform');
if W <.5 then X[i]=-Y;
end;

print X;

cname={x};

create random from x[colname=cname];
append form x;
quit;
proc print data = random;
run;

proc univariate data = random noprint;
qqplot x / normal (mu=0 sigma=1);
run;

