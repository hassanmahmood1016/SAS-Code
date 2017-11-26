proc iml;
seed = J(99,1,0);
X = uniform(seed);
x = x*100;
n1 = ncol(x);
rowMeans = x[ ,:];
mean = rowMeans;
mean1 = mean[:,1];
std_dev1 = std(mean);
MAX_mean1 =  mean[<>,1];
MIN_mean1 =  mean[><,1];
print n1 mean1 std_dev1 Min_mean1 Max_Mean1;


proc iml;
seed = J(99,4,0);
X = uniform(seed);
x = x*100;
n2 = ncol(x);
rowMeans = x[ ,:];
means = rowMeans;
mean2 = means[:,1];
std_dev2 = std(means);
MAX_mean2 =  means[<>,1];
MIN_mean2 =  means[><,1];
print n2 mean2 std_dev2 Min_mean2 Max_Mean2;


proc iml;
seed = J(99,16,0);
X = uniform(seed);
x = x*100;
n3 = ncol(x);
rowMeans = x[ ,:];
means = rowMeans;
mean3 = means[:,1];
std_dev3 = std(means);
MAX_mean3 =  means[<>,1];
MIN_mean3 =  means[><,1];
print n3 mean3 std_dev3 Min_mean3 Max_Mean3;


proc iml;
seed = J(99,64,0);
X = uniform(seed);
x = x*100;
n4 = ncol(x);
rowMeans = x[ ,:];
means = rowMeans;
mean4 = means[:,1];
std_dev4 = std(means);
MAX_mean4 =  means[<>,1];
MIN_mean4 =  means[><,1];
print n4 mean4 std_dev4 Min_mean4 Max_Mean4;


proc iml;
seed = J(99,256,0);
X = uniform(seed);
x = x*100;
n5 = ncol(x);
rowMeans = x[ ,:];
means = rowMeans;
mean5 = means[:,1];
std_dev5 = std(means);
MAX_mean5 =  means[<>,1];
MIN_mean5 =  means[><,1];
print n5 mean5 std_dev5 Min_mean5 Max_Mean5;


proc iml;
seed = J(99,1024,0);
X = uniform(seed);
x = x*100;
n6 = ncol(x);
rowMeans = x[ ,:];
means = rowMeans;
mean6 = means[:,1];
std_dev6 = std(means);
MAX_mean6 =  means[<>,1];
MIN_mean6 =  means[><,1];
print n6 mean6 std_dev6 Min_mean6 Max_Mean6;



proc iml;
seed = J(99,4096,0);
X = uniform(seed);
x = x*100;
n7 = ncol(x);
rowMeans = x[ ,:];
means = rowMeans;
mean7 = means[:,1];
std_dev7 = std(means);
MAX_mean7 =  means[<>,1];
MIN_mean7 =  means[><,1];
print n7 mean7 std_dev7 Min_mean7 Max_Mean7;
