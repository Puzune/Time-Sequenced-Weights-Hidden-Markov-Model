function logs = computeLogp1_addgamma(tdata,alllambda,flag,n,gamma)

lambda = alllambda{flag,n};
lambda.discountFactor = 1;
numclasses = size(alllambda,1);
logs = cell(numclasses,1);
for i = 1:numclasses
    for j = 1:length(tdata{i})
        logs{i,1}{j,1} = computelogps_addgamma(tdata{i}{j}, ...
            lambda,gamma);
    end
end
