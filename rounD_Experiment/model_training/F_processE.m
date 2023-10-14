clc;clear;close all
load E_acc.mat acc_addgamma
load D2_processacc.mat acc

[numgroup,numgm] = size(acc_addgamma);
for i = 1:height(acc_addgamma)
    acc_addgamma{i,numgm+1} = vertcat(acc_addgamma{i,:});
end
acc_addgamma(:,1:end-1) = [];
acc = acc(cellfun(@(x) any(all((x(:,1:2)-x(end,1:2))>0,2)), ...
    acc_addgamma),:);
save('F_optiacc.mat',"acc")
