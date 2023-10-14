clc;clear;close all
load G_acc.mat
[numgroup,numgm] = size(acc_addgamma);
for i = 1:numgroup
    j = mod(i,12);
    if j==0
        j=12;
    end
    subplot(2,3,j)
    temp = acc_addgamma(i,:);
    temp = vertcat(temp{:});
    plot(temp(:,end),temp(:,1:3))
    ylim([0.80 0.92])
    fig = gcf;
    fig.Units = "normalized";
    fig.Position = [-0.0001    0.0370    1.0001    0.8907];
    tstring = ['n1=',num2str(temp(1,4)),', n2=',num2str(temp(1,5)), ...
        ', tw=',num2str(temp(1,6))];
    t = title(tstring);
    t.FontName = 'Times New Roman';
    if mod(i,12)==0
        disp(i)

    end
end
keyboard
clc;clear
ns = [20 24];
tw = 50;
load A_rounDdata3.mat
load C_lambda.mat
traindata{1} = lcdata;
traindata{2} = lkdata;
gammasets = 0.9:0.0001:1;
numgamma = length(gammasets);
bestparas_acc_addgamma = zeros(numgamma,7);
for i = 1:numgamma
    tic
    gamma = gammasets(i);
    bestparas_acc_addgamma(i,:) = G_computeAcc_round(traindata, ...
        lambda,ns,tw,gamma);
    toc
    disp(gamma)
end