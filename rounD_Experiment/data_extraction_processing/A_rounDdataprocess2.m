if exist('data','var')
    clc;clearvars -except data
else
    clc;clear
    data = load('A_rounDdata1.mat');
end
close all

lcdata = data.LCdata;
numlc = length(lcdata);
lkdata = data.LKdata;
numlk = length(lkdata);
lcpercent = [10 90];
lkpercent = [10 90];
lcOlength = zeros(numlc,1);
for i = 1:numlc
    lcOlength(i) = size(lcdata{i},1);
end
[lcOlength,idx] = sort(lcOlength);
lcdata = lcdata(idx);
[cleanedData,outlierIndices] = ...
    rmoutliers(lcOlength,"percentiles",lcpercent);
clear thresholdLow thresholdHigh
lcdata(outlierIndices) = [];

lkOlength = zeros(numlk,1);
for i = 1:numlk
    lkOlength(i) = size(lkdata{i},1);
end
[lkOlength,idx] = sort(lkOlength);
lkdata = lkdata(idx);
[cleanedData2,outlierIndices2] = ...
    rmoutliers(lkOlength,"percentiles",lkpercent);
clear thresholdLow2 thresholdHigh2
lkdata(outlierIndices2) = [];