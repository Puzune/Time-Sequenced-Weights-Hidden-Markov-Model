function tia = tia_hmm(lambdasets,ns,tw,gamma,data)

numclasses = size(lambdasets,1);
lambda = cell(numclasses,1);
for i = 1:numclasses
    temp = lambdasets{i,ns(i)};
    temp.discountFactor = 1;
    lambda{i} = temp;
end

data.Splitdata = cellfun(@(x) datasplitbytw2(x,tw),data.Inputdata, ...
    'UniformOutput',0);
data.NumSdata = cellfun(@length,data.Splitdata);

logps = cell(1,numclasses);
for i = 1:numclasses
    logps{i} = computelogps_addgamma(vertcat(data.Splitdata{:}), ...
        lambda{i},gamma);
end
logps = cell2mat(logps);
[~,maxindex] = max(logps,[],2);
data.RR = mat2cell(maxindex,data.NumSdata);
data.Inipoint = cellfun(@(x,y) find((-2*y+3)*x.HeadingAngle>0,1,"last") ...
    +1-tw+1, data.Samples,mat2cell(data.Label,ones(height(data),1)));
data.Rinipoint = cellfun(@(x,y) find((x==y)==0,1,'last')+1, data.RR, ...
    mat2cell(data.Label,ones(height(data),1)),"UniformOutput",false);
data.Rinipoint(cellfun("isempty",data.Rinipoint)) = {1};
data.TIA = (data.NumSdata-cell2mat(data.Rinipoint))/25;
data.TIA(data.TIA<0) = 0;
lcltia = mean(data.TIA(data.Label==1));
lcrtia = mean(data.TIA(data.Label==2));
avertia = (lcltia+lcrtia)*0.5;
tia = [lcltia,lcrtia,avertia];