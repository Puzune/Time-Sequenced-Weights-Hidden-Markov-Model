function [mergexi,Oinipoint,Oendpoint] = compute_xi(TR, B, salpha, sbeta)
%   计算ksi，xi{k}(i,j,t)=p(st=i,st+1=j|O(k),lamda)，N*N*Tk
%   salpha：缩放后的前向概率，salpha{k}(i,t)
%   sbeta：缩放后的后向概率，sbeta{k}(i,t)
%   TR：状态转移矩阵，N*N
%   B{k}(i,t)=bi(ot(k))
%   假设bi(oTk+1(k))=1，sbeta{k}(i,Tk+1)=1

% 组数
numgroups = length(B);
% 隐状态数
N = size(TR,1);
% %% 老办法
% xi = cell(numgroups,1);
% for k = 1:numgroups
%     tempB = B{k};
%     Tk = size(tempB,2);
%     tempsalpha = salpha{k};
%     tempsbeta = sbeta{k};
% 
%     tempxi = ones(N,N,Tk);
%     Bbeta = tempB .* tempsbeta;
%     neededBbeta = Bbeta(:,2:end);
%     fixedBbeta = [neededBbeta, ones(N,1)];
% 
%     for t = 1:Tk
%         a = tempsalpha(:,t);
%         b = fixedBbeta(:,t);
%         c = a*b';
%         tempxi(:,:,t) = c.*TR;
%     end
%     xi{k} = tempxi;
% end
%% 新办法
% 统计序列长度，同时调整Bbeta,salpha
Oinipoint = zeros(numgroups,1);
Oendpoint = zeros(numgroups,1);
inipoint = 1;
endpoint = 0;
Bbetacell = cell(numgroups,1);
for k = 1:numgroups
    tempB = B{k};
    tempsbeta = sbeta{k};
    Tk = size(tempB,2);
    Oinipoint(k) = inipoint;
    inipoint = inipoint+Tk;
    endpoint = endpoint+Tk;
    Oendpoint(k) = endpoint;

    Bsbeta = tempB.*tempsbeta;
    neededBbeta = Bsbeta(:,2:end);
    fixedBbeta = [neededBbeta, ones(N,1)]';
    Bbetacell{k} = fixedBbeta;

    salpha{k} = salpha{k}';
end
% 合并salpha,Bsbeta
mergesalpha = cell2mat(salpha)';
mergeBsbeta = cell2mat(Bbetacell)';
% 计算mergexi
numdata = size(mergesalpha,2);
mergexi = zeros(N,N,numdata);
for n = 1:numdata
    tempsalpha = mergesalpha(:,n);
    tempBsbeta = mergeBsbeta(:,n);
    mergexi(:,:,n) = tempsalpha*tempBsbeta';
end
mergexi = mergexi .* TR;

end