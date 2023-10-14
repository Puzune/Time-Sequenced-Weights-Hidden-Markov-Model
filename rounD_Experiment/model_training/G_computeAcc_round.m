function acc = G_computeAcc_round(data,lambdasets,ns,tw,gamma)

numclasses = numel(ns);
lambda = cell(numclasses,1);
for c = 1:numclasses
    lambda{c} = lambdasets{tw,c,ns(c)};
end

tdata = datasplitbytw0(data,tw);
tempx = cell(numclasses,1);
tempolength = cell(numclasses,1);
for c = 1:numclasses
    tempolength{c} = cellfun(@(x) size(x,1),tdata{c});
    tempx{c} = vertcat(tdata{c}{:});
end
tempy = cellfun(@(x) ones(length(x),1),tempolength,'UniformOutput',false);
tempy{2} = tempy{2}*2;
% tempy{3} = tempy{3}*3;
x = vertcat(tempx{:});
y = vertcat(tempy{:});
y = mat2cell(y,ones(length(y),1));
olength = vertcat(tempolength{:});

celllogps = cell(1,numclasses);
for c = 1:numclasses
    celllogps{c} = computelogps_addgamma(x,lambda{c},gamma,1);
end
logps = [celllogps{:}];

[~,maxindex] = max(logps,[],2);
Rcell = mat2cell(maxindex,olength);

logi = cellfun(@(x,y) all(x==y),Rcell,y);
num_per_c = cellfun(@(x) length(x),tdata);
logi2per = mat2cell(logi,num_per_c);
acc = cellfun(@(x) sum(x)./numel(x),logi2per);
acc = acc';
acc = [acc,mean(acc),ns,tw,gamma];
