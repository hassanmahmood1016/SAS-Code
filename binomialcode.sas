proc iml;

start Exp_revenue(T,A,S,M,p,R);

R = 0;
do x=0 to M;
if x <= S then
R = R + T*x*PDF('binomial', x,p,M);
if x > S then  
R = R + ((T*S)-(A*(x-S)))*PDF('binomial',x,p,M);
end;

finish Exp_revenue;

revenue1 = J(13,2,0);

call Exp_Revenue(100,250,199,199,.95,last);


revenue1[1,1] = 199;
revenue1[1,2] = last;
do j = 2 to  13;
gwu = 199 + j - 1; 
call Exp_revenue(100, 250, 199,gwu, .95, last);
revenue1[j,1] = gwu;
revenue1[j,2] = last;
end;
maxvaluerow = revenue1[<:>,2];
maxrev= revenue1[<>,2];
optimum=revenue1[maxvaluerow,1];


v = {"opt_books" "max_rev"};
last = optimum || maxrev;
print 'Optimum B bookings // maximum revenue';
 
print last;

revenue2 = J(maxvaluerow+4,2,0);
do j = 1 to maxvaluerow+4;
gwu2 = 199 + j;
call Exp_revenue(100,250,199, gwu2, .95,last2);
revenue2[j,1] = gwu2;
revenue2[j,2] = last2;
end;
print revenue2;

