function IniLamda = generateInitialPara(O,numstates,c)

data = cell2mat(O);

% % 合并连续数据
% cdata = cell2mat(O(:,1));
% % 合并离散数据
% ddata = cell2mat(O(:,2));
% 合并数据
% mergeDC = cell2mat(O);
% 连续数据
% data = mergeDC(:,1:end-1);
% % 离散数据
% ddata = mergeDC(:,end);
% % 观测数
% M = length(unique(ddata));
% 特征变量数
D = size(data,2);

% 删除并行池
delete(gcp('nocreate'));
% gpu设置
numWorkers = gpuDeviceCount;
parpool("Processes",numWorkers);
% gpuDevice(2);
gpudata = gpuArray(data);

options = statset('UseParallel',true);
% options = statset('UseParallel',false);
idx = kmeans(gpudata,numstates,'Options',options,...
    'MaxIter',1e+04,'Replicates',80,'Display','off');
idxnum = sum(idx==1:numstates);
while sum(idxnum==1)~=0
    disp('kmeans聚类出现奇点，正在重新计算')
    tbl = tabulate(idx);
    gpudata(ismember(idx,tbl(tbl(:,2)==1,1)),:) = [];
    idx = kmeans(gpudata,numstates,'Options',options,...
        'MaxIter',1e+04,'Replicates',80,'Display','off');
    idxnum = sum(idx==1:numstates);
end
idx = gather(idx);
% 清除不再需要的 GPU 数组
clear gpudata;
% 删除并行池
delete(gcp('nocreate'));
% % 清空显存
for i = 1:numWorkers
    reset(gpuDevice(i));
end
% reset(gpuDevice(2));

mu = zeros(D,numstates);
sigma = zeros(D,D,numstates);

for i = 1:numstates
    tempdata = data(idx==i,:);
    mu(:,i) = mean(tempdata)';
    tempsigma = cov(tempdata);
    lastwarn('')
    inv(tempsigma);
    while (~isempty(lastwarn))
        tempsigma = tempsigma + eye(size(tempsigma,1))*0.01;
        lastwarn('')
        inv(tempsigma);
    end
    sigma(:,:,i) = tempsigma;
end

% TR = triu(ones(numstates),1);
% TR = TR + diag(ones(numstates,1));
% TR = TR ./ sum(TR,2);


IniLamda.guessTR = ones(numstates)/numstates;
IniLamda.guessINISTATE = ones(numstates,1)/numstates;
% IniLamda.guessBM = ones(numstates,M)/M;
IniLamda.guessMU = mu;
IniLamda.guessSIGMA = sigma;
IniLamda.label = c;
IniLamda.numN = numstates;
