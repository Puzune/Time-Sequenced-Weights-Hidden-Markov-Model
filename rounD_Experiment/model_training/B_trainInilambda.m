clc;clear
load A_rounDdata3.mat
minn = 1;
maxn = 25;
numclasses = 2;
data{1} = lcdata;
data{2} = lkdata;
if exist('B_inilambda.mat','file')==2
    load B_inilambda.mat
else
    inilambdas = cell(numclasses,maxn);
end
for n = minn:maxn
    tic
    for c = 1:numclasses
        try
            isempty(inilambdas{c,n});
        catch
            inilambdas{c,n} = generateInitialPara(data{c},n,c);
        end
        if isempty(inilambdas{c,n})
            inilambdas{c,n} = generateInitialPara(data{c},n,c);
        end
        save('B_inilambda.mat',"inilambdas")
    end
    toc
    disp(n)
end