/*Step 1: import data*/
data homework1;
input x y;
datalines;
1  2.4
2  5.8
3  6.9
4  7.7
5  9.1
6  21.1
;
run;

/*Step 2: Compute p-value and run hypothesis test for correlation coefficient*/

title 'Test of Correlation between X and Y, 95% CI';
ods output FisherPearsonCorr=corr;
proc corr data=homework1 fisher ( biasadj=no );
 var x y;
run; 
