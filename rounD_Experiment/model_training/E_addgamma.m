clc;clear
load E_testdata.mat lcdata lkdata
load C_lambda.mat
load D2_processacc.mat
traindata{1} = lcdata;
traindata{2} = lkdata;
gammasets = 0.90:0.001:1;
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
save('E_acc.mat',"acc_addgamma")