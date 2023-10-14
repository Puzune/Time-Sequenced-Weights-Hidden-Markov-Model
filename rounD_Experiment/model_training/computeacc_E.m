function acc = computeacc_E(lcp,lkp)

% 统计长度
Olength = cell(2,1);
for j = 1:2
    n = length(lcp{j});
    temp = zeros(n,1);
    for k = 1:n
        temp(k) = size(lcp{j}{k},1);
    end
    Olength{j} = temp;
end
% 求acc
tempaccsets = zeros(1,2);
for j = 1:2
    temp1 = lcp{j};
    temp2 = lkp{j};
    mergetemp = cell2mat([temp1,temp2]);
    [~,maxindex] = max(mergetemp,[],2);
    acclogi = (maxindex==j);
    templength = Olength{j};
    acccell = mat2cell(acclogi,templength,1);
    for k = 1:length(acccell)
        if all(acccell{k}==1)
            acccell{k} = 1;
        else
            acccell{k} = 0;
        end
    end
    acccell = cell2mat(acccell);
    tempaccsets(j) = sum(acccell)./numel(acccell);
end
acc = tempaccsets;