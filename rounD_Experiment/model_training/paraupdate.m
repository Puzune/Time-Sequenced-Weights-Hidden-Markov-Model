function lamda = paraupdate(mergexi, Oinipoint, Oendpoint, O)
%   更新HMM参数lamda
%   xi{k}(i,j,t)=p(st=i,st+1=j|O(k),lamda)，N*N*Tk
%   inistate: N*1
%   A: N*N
%   mu: D*N
%   sigma: D*D*N

% 判断输入O是否为元组
if ~iscell(O)
    Observationdata{1} = O;
else
    Observationdata = O;
end
% 组数
numgroups = length(Oinipoint);
% 隐状态数
N = size(mergexi,1);
% 特征数
D = size(Observationdata{1}',1);

%% 新方法
% inistate
if N>1
    sumjmergexi = squeeze(sum(mergexi,2));
else
    sumjmergexi = squeeze(mergexi)';
end
guessINISTATE = sum(sumjmergexi(:,Oinipoint),2)/numgroups;
% tr
sumtmergexi = sum(mergexi,3);
upAminus = sum(mergexi(:,:,Oendpoint),3);
upA = sumtmergexi-upAminus;
upA(upA<0) = 0;
% guessTR = normalize(upA,2,"range");
guessTR = upA./sum(upA,2);
% 合并O，计算mu,sigma
mergeO = cell2mat(Observationdata)';
% mu
upmu = mergeO*sumjmergexi';
sumjtmergexi = sum(sumtmergexi,2);
guessMU = upmu./sumjtmergexi';
% sigma
guessSIGMA = zeros(D,D,N);
for i = 1:N
    x = mergeO-guessMU(:,i);
    ithsumjmergexi = sumjmergexi(i,:);
    upsigma = (x.*ithsumjmergexi)*x';
    downsigma = sumjtmergexi(i);
    tempsigma = upsigma/downsigma;
%     % 修正奇异矩阵
%     lastwarn('')
%     flag = 1;
%     while flag || ~isempty(lastwarn)
%         if flag==0
%             tempsigma = tempsigma + 1e-02*eye(D);
%         end
%         flag = 0;
%         inv(tempsigma);
%     end
    guessSIGMA(:,:,i) = tempsigma;
end

% % 组数
% numgroups = length(mergexi);
% % 隐状态数
% N = size(mergexi{1},1);
% % 特征数
% D = size(Observationdata{1}',1);
% %% 新方法
% % 计算inistate,tr
% upinistate = zeros(N,numgroups);
% upA = zeros(N,N,numgroups);
% for k = 1:numgroups
%     % inistate
%     upinistate(:,k) = sum(mergexi{k}(:,:,1),2);
%     % tr
%     tempA = mergexi{k};
%     upA(:,:,k) = sum(tempA,3)-tempA(:,:,end);
% end
% guessINISTATE = sum(upinistate,2)/numgroups;
% guessTR = sum(upA,3)./repmat(sum(upA,[2 3]),1,N);
% % 合并xi，O，计算mu,sigma
% mergeO = cell2mat(Observationdata)';
% mergexi = zeros(N,N,size(mergeO,2));
% inipoint = 1;
% for k = 1:numgroups
%     tempxi = mergexi{k};
%     tempT = size(tempxi,3);
%     mergexi(:,:,inipoint:inipoint+tempT-1) = tempxi;
%     inipoint = inipoint+tempT;
% end
% % mu
% sumjmergexi = squeeze(sum(mergexi,2))';
% upmu = mergeO * sumjmergexi;
% downmu = sum(mergexi,[2 3]);
% guessMU = upmu./downmu';
% % sigma
% guessSIGMA = zeros(D,D,N);
% for i = 1:N
%     x = mergeO - guessMU(:,i);
%     ithsumjmergexi = sumjmergexi(:,i)';
%     upsigma = (x.*ithsumjmergexi)*x';
%     downsigma = downmu(i);
%     tempsigma = upsigma/downsigma;
%     % 修正奇异矩阵
%     lastwarn('')
%     flag = 1;
%     while flag || ~isempty(lastwarn)
%         if flag==0
%             tempsigma = tempsigma + 1e-03*eye(D);
%         end
%         flag = 0;
%         inv(tempsigma);
%     end
%     guessSIGMA(:,:,i) = tempsigma;
% end
% 
% 
% % %% 老方法
% % upinistate = zeros(N,numgroups);
% % upA = zeros(N,N,numgroups);
% % upmu = zeros(D,N,numgroups);
% % downmu = zeros(N,numgroups);
% % 
% % for k = 1:numgroups
% %     % inistate
% %     upinistate(:,k) = sum(xi{k}(:,:,1),2);
% % 
% %     % A
% %     tempA = xi{k};
% %     upA(:,:,k) = sum(tempA,3)-tempA(:,:,end);
% % 
% %     % mu
% %     upmu(:,:,k) = Observationdata{k}' * permute(sum(xi{k},2),[1 3 2])';
% %     downmu(:,k) = sum(xi{k},[2 3]);
% % end
% % 
% % guessINISTATE = sum(upinistate,2)/numgroups;
% % guessTR = sum(upA,3)./repmat(sum(upA,[2 3]),1,N);
% % guessMU = sum(upmu,3)./repmat(sum(downmu,2)',D,1);
% % 
% % upsigma = zeros(D,D,N,numgroups);
% % for k = 1:numgroups
% %     localguessMU = guessMU;
% %     a = xi{k};
% %     b = sum(a,2);
% %     c = squeeze(b);
% %     % sigma
% %     for i = 1:N
% %         x = Observationdata{k}'-localguessMU(:,i);
% % %         a = xi{k};
% %         tempxi = c(i,:);
% % %         tempxi = permute(c,[1 3 2]);
% % %         tempxi = permute(sum(xi{k}(i,:,:),2),[1 3 2]);
% %         upsigma(:,:,i,k) = (x.*repmat(tempxi,D,1)) * x';
% %     end
% % end
% % guessSIGMA = sum(upsigma,4)./permute(repmat(sum(downmu,2),1,D,D),[2 3 1]);
% %% 
% for i = 1:N
%     tempsigma = guessSIGMA(:,:,i);
%     d = eig(tempsigma);
%     tempdetsigma = det(tempsigma);
%     while ~all(d>0) || (rcond(tempsigma)<1e-12) || (tempdetsigma<=0)
%         tempsigma = tempsigma + 1e-04*eye(D,D);
%         d = eig(tempsigma);
%         tempdetsigma = det(tempsigma);
%     end
%     guessSIGMA(:,:,i) = tempsigma;
% end

lamda.guessINISTATE = guessINISTATE;
lamda.guessTR = guessTR;
lamda.guessMU = guessMU;
lamda.guessSIGMA = guessSIGMA;
end