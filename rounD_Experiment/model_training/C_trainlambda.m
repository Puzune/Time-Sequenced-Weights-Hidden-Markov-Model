clc;clear
load A_rounDdata3.mat
load B_inilambda.mat

traindata{1} = lcdata;
traindata{2} = lkdata;

[numclasses,numn] = size(inilambdas);
twsets = 40:5:75;
numt = length(twsets);
maxiter = 30;
tol = 1e-03;

if exist('C_lambda.mat','file')==2
    load C_lambda.mat
else
    lambda = cell(max(twsets),numclasses,numn);
end

reset(gpuDevice(1))
gpuDevice(1)
for i = 1:numt
    tic
    t = twsets(i);
    tdata = datasplitbytw0(traindata,t);
    for c = 1:numclasses
        tdata{c,2} = vertcat(tdata{c}{:});
    end
    tdata(:,1) = [];
    for n = 1:numn
        if isempty([inilambdas{:,n}])
            continue
        end
        for c = 1:numclasses
            try
                isempty(lambda{t,c,n});
            catch
                lambda{t,c,n} = emdfhmm_opti(tdata{c}, ...
                    inilambdas{c,n},maxiter,tol,1);
            end
            if isempty(lambda{t,c,n})
                lambda{t,c,n} = emdfhmm_opti(tdata{c}, ...
                    inilambdas{c,n},maxiter,tol,1);
            end
            reset(gpuDevice(1))
        end
    end
    save('C_lambda.mat',"lambda","twsets")
    toc
    disp(t)
end