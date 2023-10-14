function lambda = paraupdate_dfhmm(TR, B, salpha, sbeta, data, ...
    discountFactor, TS, tw, numK, D)
%   更新HMM参数lamda
%   xi{k}(i,j,t)=p(st=i,st+1=j|O(k),lamda)，N*N*Tk
%   inistate: N*1
%   A: N*N
%   mu: D*N
%   sigma: D*D*N

%%%%%%%%%%%%%%%%%%%%% 先计算xi %%%%%%%%%%%%%%%%%%%%
mergexi = compute_xi_dfhmm(TR, B, salpha, sbeta);
clear TR B salpha sbeta
%%%%%%%%%%%%%%%%%%%%%
N = size(mergexi,1);
if N>1
    sumjmergexi = squeeze(sum(mergexi,2));
else
    sumjmergexi = squeeze(mergexi)';
end
%% inistate
tsumjmergexi = reshape(sumjmergexi,N,tw,[]);
if N>1
    inistate = sum(tsumjmergexi(:,1,:),3)/numK;
else
    inistate = 1;
end
%% tr
tmergexi = reshape(mergexi,N,N,tw,[]);
% % way1
% upA = sum(tmergexi(:,:,1:tw-1,:),[3 4]);
% way2
upA = sum(tmergexi,[3 4])-sum(tmergexi(:,:,end,:),[3 4]);

if tw==1
    tr = 1;
else
    tr = upA./sum(upA,2);
end
%% mu
dfsequence = discountFactor.^TS;
upmu = data.*dfsequence*sumjmergexi';
downmu = sum(dfsequence.*sumjmergexi,2);
mu = upmu./downmu';
%% sigma
sigma = zeros(D,D,N);
sumjtmergexi = sum(sumjmergexi,2);
for i = 1:N
    x = data-mu(:,i);
    ithsumjmergexi = sumjmergexi(i,:);
    upsigma = (x.*ithsumjmergexi.*dfsequence)*x';
    downsigma = sumjtmergexi(i);
    tempsigma = upsigma/downsigma;
    % if any(isnan(tempsigma),"all")
    %     disp('已暂停')
    %     keyboard
    % end
    sigma(:,:,i) = tempsigma;
end

lambda.guessINISTATE = inistate;
lambda.guessTR = tr;
lambda.guessMU = mu;
lambda.guessSIGMA = sigma;
