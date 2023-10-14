function logs = computeLogp1(tdata,alllambda,flag,n)

lambda = alllambda{flag,n};
lambda.discountFactor = 1;
for i = 1:3
    for j = 1:length(tdata{i})
        logs{i,1}{j,1} = computelogps(tdata{i}{j},lambda);
    end
end
