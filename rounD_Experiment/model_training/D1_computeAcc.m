clc;clear
load A_rounDdata3.mat
load C_lambda.mat
[numt,numclasses,numn] = size(lambda);
traindata{1,1} = lcdata;
traindata{2,1} = lkdata;
numNs = round(numn.^numclasses);
Nsets = zeros(numNs,numclasses);
i = 1;
for n1 = 1:numn
    for n2 = 1:numn
        Nsets(i,:) = [n1,n2];
        i = i + 1;
    end
end
if exist('D_acc.mat','file')==2
    load D_acc.mat
    try
        isempty(acc{numt,numNs});
    catch
        acc{numt,numNs} = [];
    end
else
    acc = cell(numt,numNs);
end
for t = 1:numt
    tic
    if isempty([lambda{t,:,:}])
        toc
        disp(t)
        continue
    end
    if isempty([acc{t,:}])
        tdata = datasplitbytw0(traindata,t);
        templambda = cell(numclasses,numn);
        for c = 1:numclasses
            [templambda{c,:}] = lambda{t,c,:};
        end
        parfor n = 1:numn
            if isempty([lambda{t,:,n}])
                continue
            end
            lcp{n} = computeLogp1(tdata,templambda,1,n);
            lkp{n} = computeLogp1(tdata,templambda,2,n);
        end
        parfor n = 1:numNs
            locallambda = lambda;
            [n1,n2] = assignN(Nsets,n);
            if isempty(locallambda{t,1,n1})||isempty(locallambda{t,2,n2})
                continue
            end
            acc{t,n} = computeacc_round(lcp,lkp,n1,n2,t);
        end
        save('D_rounD_acc.mat',"acc")
    end
    toc
    disp(t)
end