function [salpha, sbeta, logp] = fbward(INISTATE, TR, B)
%   计算缩放后的前向后向概率。
%   salpha：缩放后的前向概率，salpha{k}(i,t)
%   sbeta：缩放后的后向概率，sbeta{k}(i,t)
%   c：缩放因子，c{k}(t)

%   INISTATE：初始概率分布，N*1
%   TR：状态转移矩阵，N*N
%   B：观测值的概率密度函数值，B{k}(i,t)=bi(ot(k))

% 状态数
N = length(INISTATE);
% 组数
if iscell(B)
    numgroups = length(B);
else
    numgroups = 1;
end

salpha = cell(numgroups,1);
sbeta = cell(numgroups,1);
c = cell(numgroups,1);

for k = 1:numgroups
    if iscell(B)
        tempB = B{k};
    else
        tempB = B;
    end
    Tk = size(tempB,2);
    tempsalpha = zeros(N,Tk);
    tempsbeta = ones(N,Tk);
    tempc = zeros(Tk,1);

    % 计算前向概率alpha和缩放因子c
    tempsalpha(:,1) = INISTATE .* tempB(:,1);
    if sum(tempsalpha(:,1))==0
        disp('fb alpha is 0!')
        keyboard
    end
    tempc(1) = 1./sum(tempsalpha(:,1));
    tempsalpha(:,1) = tempsalpha(:,1)*tempc(1);
    for t = 2:Tk
        tempsalpha(:,t) = TR' * tempsalpha(:,t-1) .* tempB(:,t);
        tempc(t) = 1./sum(tempsalpha(:,t));
        tempsalpha(:,t) = tempsalpha(:,t)*tempc(t);
%         if anynan(tempsalpha)
%             disp('fb alpha is nan!')
%             keyboard
%         end
    end
    salpha{k} = tempsalpha;
    c{k} = tempc;

    % 计算后向概率
    if iscell(B)
        tempsbeta(:,Tk) = tempsbeta(:,Tk) * tempc(Tk);
        for t = Tk-1:-1:1
            tempsbeta(:,t) = TR * (tempB(:,t+1).*tempsbeta(:,t+1));
            tempsbeta(:,t) = tempsbeta(:,t)*tempc(t);
        end
        sbeta{k} = tempsbeta;
    end
end

% 计算p(O|lamda)
logpk = zeros(numgroups,1);
for k = 1:numgroups
    tempc = c{k};
    logpk(k) = -sum(log(tempc));
end
logp = sum(logpk);

if isinf(logp)
    disp('fb logp is inf!')
    keyboard
end

end