function acc = computeacc(lclp,lcrp,lkp,n1,n2,n3,tw)

logp1 = lclp{n1};
logp2 = lcrp{n2};
logp3 = lkp{n3};

%% 统计长度
Olength = cell(3,1);
for i = 1:3
    n = length(logp1{i});
    templength = zeros(n,1);
    for j = 1:n
        templength(j) = size(logp1{i}{j},1);
    end
    Olength{i} = templength;
end
%% 求acc
accsets = zeros(3,1);
for i = 1:3
    temp1 = logp1{i};
    temp2 = logp2{i};
    temp3 = logp3{i};
    mergetemp = cell2mat([temp1,temp2,temp3]);
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
% acc = mean(accsets)-0.5*abs(accsets(1)-accsets(2));
% acc = mean(accsets)-std(accsets)*0.1-abs(accsets(1)-accsets(2))*0.2;
acc = [accsets',mean(accsets),n1,n2,n3,tw];