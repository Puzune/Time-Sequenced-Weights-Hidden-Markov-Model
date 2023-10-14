function tia = tia_hmm_round(lambda,ns,tw,gamma,LCtiadata,mu,s,pcacoeff)

numclasses = length(ns);
templambda = cell(numclasses,1);
for i = 1:numclasses
    temp = lambda{tw,i,ns(i)};
    templambda{i} = temp;
end

LCtiadata = cellfun(@(x) x(:,["lonVelocity","latVelocity", ...
    "lonAcceleration","latAcceleration","rho"]),LCtiadata, ...
    'UniformOutput',false);
LCtiadata = cellfun(@(x) (table2array(x)-mu)./s*pcacoeff,LCtiadata, ...
    'UniformOutput',false);
olength = cellfun(@(x) size(x,1)-tw+1,LCtiadata);

LCtiadata = cellfun(@(x) datasplitbytw2(x,tw),LCtiadata, ...
    'UniformOutput',false);
logps = cell(numclasses,1);
for i = 1:numclasses
    logps{i} = computelogps_addgamma(vertcat(LCtiadata{:}), ...
        templambda{i},gamma,1);
end
logps = [logps{:}];
[~,recogR] = max(logps,[],2);
rrcell = mat2cell(recogR,olength);

tia = cellfun(@(x) (length(x)-find(x==2,1,'last'))/25,rrcell, ...
    'UniformOutput',false);
tia(cellfun(@isempty,tia)) = [];
tia = cell2mat(tia);
tia = sort(tia);
tia(tia==0) = [];
tia = mean(tia);