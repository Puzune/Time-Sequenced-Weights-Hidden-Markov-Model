function logps = computelogps_addgamma(data,lambda,gamma,gpu)

ini = lambda.guessINISTATE;
tr = lambda.guessTR;
mu = lambda.guessMU;
sigma = lambda.guessSIGMA;
df = lambda.discountFactor;

numk = length(data);
[tw,D] = size(data{1});

data = cell2mat(data)';

if gpu==1
    ini = gpuArray(ini);
    tr = gpuArray(tr);
    mu = gpuArray(mu);
    sigma = gpuArray(sigma);
    df = gpuArray(df);
    numk = gpuArray(numk);
    tw = gpuArray(tw);
    D = gpuArray(D);
    data = gpuArray(data);
end

B = observation_prob_dfhmm(data,mu,sigma,df,numk,tw,D,gpu);
logps = fbward_dfhmm_onlylogp_addgamma(ini,tr,B,gamma,gpu)';

if gpu==1
    logps = gather(logps);
end