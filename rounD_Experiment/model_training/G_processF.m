clc;clear
load A_rounDdata3.mat
load C_lambda.mat
load F_optiacc.mat
traindata{1} = lcdata;
traindata{2} = lkdata;

gammasets = 0.9:0.0001:1;
numgamma = length(gammasets);
[numt,numclasses,numn] = size(lambda);
numcombi = height(acc);
acc_addgamma = cell(numcombi,numgamma);
gpuDevice(1)
for n = 1:numcombi
    tic
    localgammasets = gammasets;
    ns = [acc.n1(n),acc.n2(n)];
    tw = acc.tw(n);
    for i = 1:numgamma
        gamma = localgammasets(i);
        acc_addgamma{n,i} = G_computeAcc_round(traindata,lambda, ...
            ns,tw,gamma);
    end
    reset(gpuDevice(1))
    disp(n)
    toc
end
save('G_acc.mat',"acc_addgamma")