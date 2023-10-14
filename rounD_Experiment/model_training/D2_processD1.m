clc;clear
load D_rounD_acc.mat
acc = vertcat(acc{:});
varnames = {'lc','lk','aver','n1','n2','tw'};
acc = array2table(acc,VariableNames=varnames);
save("D2_processacc.mat","acc")