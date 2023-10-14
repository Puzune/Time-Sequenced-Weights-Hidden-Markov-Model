function [Flambda, logp] = emdfhmm_opti(O,inilamda,maxiter,tol, ...
    discountFactor)
%   基于EM算法的GMHMM参数训练

inistate = inilamda.guessINISTATE;
tr = inilamda.guessTR;
mu = inilamda.guessMU;
sigma = inilamda.guessSIGMA;

prelogp = -inf;
dif = inf;
i = 0;

% 组数
numK = size(O,1);
% 时间窗及变量数
[tw,D] = size(O{1});

data = cell2mat(O)';

% gpu化
inistate = gpuArray(inistate);
tr = gpuArray(tr);
mu = gpuArray(mu);
sigma = gpuArray(sigma);
discountFactor = gpuArray(discountFactor);
numK = gpuArray(numK);
tw = gpuArray(tw);
D = gpuArray(D);
maxiter = gpuArray(maxiter);
tol = gpuArray(tol);
data = gpuArray(data);

while (i<maxiter) && (abs(dif)>=tol)
    i = i+1;
    [B,TS] = observation_prob_dfhmm(data,mu,sigma,discountFactor, ...
        numK,tw,D);
    [salpha, sbeta, logp] = fbward_dfhmm(inistate,tr,B);
    if logp>prelogp
        Flambda.guessINISTATE = inistate;
        Flambda.guessTR = tr;
        Flambda.guessMU = mu;
        Flambda.guessSIGMA = sigma;
        Flambda.discountFactor = discountFactor;
    end
    trainlamda = paraupdate_dfhmm(tr,B,salpha,sbeta,data, ...
        discountFactor,TS, tw, numK, D);

    inistate = trainlamda.guessINISTATE;
    tr = trainlamda.guessTR;
    mu = trainlamda.guessMU;
    sigma = trainlamda.guessSIGMA;

    if i~=1
        dif = (logp-prelogp)/(abs(prelogp)+(prelogp==0));
        if isinf(dif)
            disp('dif is inf!')
            keyboard
        end
    end
    prelogp = logp;
end

B = observation_prob_dfhmm(data, mu,sigma,discountFactor, ...
    numK,tw,D);
[~, ~, logp] = fbward_dfhmm(inistate,tr,B);
if logp>prelogp
    Flambda.guessINISTATE = inistate;
    Flambda.guessTR = tr;
    Flambda.guessMU = mu;
    Flambda.guessSIGMA = sigma;
    Flambda.discountFactor = discountFactor;
end

Flambda.label = inilamda.label;
Flambda.numN = inilamda.numN;
Flambda.Tw = tw;

Flambda.guessINISTATE = gather(Flambda.guessINISTATE);
Flambda.guessTR = gather(Flambda.guessTR);
Flambda.guessMU = gather(Flambda.guessMU);
Flambda.guessSIGMA = gather(Flambda.guessSIGMA);
Flambda.discountFactor = gather(Flambda.discountFactor);
Flambda.Tw = gather(Flambda.Tw);

end