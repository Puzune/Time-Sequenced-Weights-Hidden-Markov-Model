if exist('data','var')
    clc;clearvars -except data
else
    clc;clear
    data = load("A_rounDdata2.mat");
end

lcdata = data.lcdata;
lkdata = data.lkdata;
numdata = 1500;
lcdata = lcdata(randperm(length(lcdata),numdata));
lkdata = lkdata(randperm(length(lkdata),numdata));
rowlcdata = lcdata;
rowlkdata = lkdata;
for i = 1:length(lcdata)
    lcdata{i} = lcdata{i}(:,["lonVelocity","latVelocity", ...
        "lonAcceleration","latAcceleration"]);
    lcdata{i} = table2array(lcdata{i});
end
for i = 1:length(lkdata)
    lkdata{i} = lkdata{i}(:,["lonVelocity","latVelocity", ...
        "lonAcceleration","latAcceleration"]);
    lkdata{i} = table2array(lkdata{i});
end
mergedata = [cell2mat(lcdata);cell2mat(lkdata)];
mu = mean(mergedata);
s = std(mergedata);
Nmergedata = (mergedata-mu)./s;
[coeff,score,latent,tsquared,explained,~] = pca(Nmergedata);
number_of_principal_components = find(cumsum(explained)>95,1,"first");
pcacoeff = coeff(:,1:number_of_principal_components);
for i = 1:length(lcdata)
    tempdata = lcdata{i};
    lcdata{i} = (tempdata-mu)./s * pcacoeff;
end
for i = 1:length(lkdata)
    tempdata = lkdata{i};
    lkdata{i} = (tempdata-mu)./s * pcacoeff;
end
save('E_testdata.mat','lcdata',"lkdata","mu","s","pcacoeff", ...
    "rowlcdata","rowlkdata")