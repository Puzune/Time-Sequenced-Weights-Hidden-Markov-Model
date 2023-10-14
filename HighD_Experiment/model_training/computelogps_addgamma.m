function logps = computelogps_addgamma(data,lambda,gamma)

ini = lambda.guessINISTATE;
tr = lambda.guessTR;
mu = lambda.guessMU;
sigma = lambda.guessSIGMA;
df = lambda.discountFactor;

numk = length(data);
[tw,D] = size(data{1});

data = cell2mat(data)';

B = observation_prob_dfhmm(data,mu,sigma,df,numk,tw,D);
logps = fbward_dfhmm_onlylogp_addgamma(ini,tr,B,gamma)';