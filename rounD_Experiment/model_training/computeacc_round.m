function acc = computeacc_round(lcp,lkp,n1,n2,tw)

logp1 = lcp{n1};
logp2 = lkp{n2};

%% 统计长度
Olength = cell(2,1);
for i = 1:2
    n = length(logp1{i});
    templength = zeros(n,1);
    for j = 1:n
        templength(j) = size(logp1{i}{j},1);
    end
    Olength{i} = templength;
end
%% 求acc
accsets = zeros(2,1);
for i = 1:2
    temp1 = logp1{i};
    temp2 = logp2{i};
    mergetemp = cell2mat([temp1,temp2]);
    [~,maxindex] = max(mergetemp,[],2);
    acclogi = (maxindex==i);
    templength = Olength{i};
    acccell = mat2cell(acclogi,templength,1);
    for j = 1:length(acccell)
        if all(acccell{j}==1)
            acccell{j} = 1;
        else
            acccell{j} = 0;
        end
    end
    acccell = cell2mat(acccell);
    accsets(i) = sum(acccell)./numel(acccell);
end
% accsets = accsets .* [1.5-0.5*lkportion; 1.5-0.5*lkportion; lkportion];
% acc = mean(accsets)-std(accsets)*0.5;
acc = [accsets'*100,mean(accsets)*100,n1,n2,tw];