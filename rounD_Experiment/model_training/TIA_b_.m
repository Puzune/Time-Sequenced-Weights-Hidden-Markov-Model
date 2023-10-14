clc;clear
load TIA_a_data.mat LCtiadata
load C_lambda.mat lambda
load A_rounDdata3.mat mu s pcacoeff
load D2_processacc.mat
LCtiadata = LCtiadata(1:4:end);
gammasets = 0.9:0.01:1;
numg = length(gammasets);
numacc = height(acc);
tia = cell(numacc,1);
gpuDevice(1)
reset(gpuDevice(1))
for i = 1:numacc
    tic
    ns = [acc.n1(i),acc.n2(i)];
    tw = acc.tw(i);
    temptia = zeros(numg,1);
    for j = 1:numg
        gamma = gammasets(j);
        temptia(j) = tia_hmm_round(lambda,ns,tw,gamma,LCtiadata,mu, ...
            s,pcacoeff);
    end
    tia{i} = temptia;
    reset(gpuDevice(1))
    disp(i)
    toc
end
save('TIA_b.mat',"tia")