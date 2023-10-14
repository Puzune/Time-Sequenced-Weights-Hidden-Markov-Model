function B = observation_prob(O, mu, sigma)
%   计算观测值的概率密度函数值
%   O：元组，每组形式为Tk*D方便合并数据，D为特征数，Tk为长度
%   mu：D*N，N为隐状态数
%   sigma：D*D*N
%   B{k}(i,t)=bi(ot(k))

% 特征数
D = size(mu,1);
% 隐状态数
N = size(mu,2);

% 计算协方差矩阵的行列式和逆
detsigma = zeros(N,1);
invsigma = zeros(D,D,N);
for k = 1:N
    tempsigma = sigma(:,:,k);
    while rcond(tempsigma)<1e-6
        tempsigma = tempsigma+0.001*eye(D);
    end
    tempdetsigma = det(tempsigma);
    detsigma(k) = tempdetsigma;
    tempinvsigma = inv(tempsigma);
    invsigma(:,:,k) = tempinvsigma; 
end

% invsigma = pageinv(sigma);

% 判断输入O是否为元组
if ~iscell(O)
    Observationdata{1} = O;
else
    Observationdata = O;
end

% 组数
numgroups = length(Observationdata);
% 统计每组数据长度
Olengthsets = zeros(numgroups,1);
for k = 1:numgroups
    Olengthsets(k) = size(Observationdata{k},1);
end

% 合并数据
mergedata = cell2mat(Observationdata)';
numdata = size(mergedata,2);

% 计算每一列观测值的高斯函数值
mergeB = zeros(N,numdata);
for j = 1:N
    tempmu = mu(:,j);
    tempdetsigma = detsigma(j);
    tempinvsigma = invsigma(:,:,j);
    x = mergedata - tempmu;
    Mdistance = sum(tempinvsigma * x .* x);
    lnGaussian_pro = ...
        -0.5*D*log(2*pi) - 0.5*log(tempdetsigma) - 0.5*Mdistance;
    Gaussian_pro = exp(lnGaussian_pro)+eps;
    mergeB(j,:) = Gaussian_pro;
end

% 重新划分mergeB
B = cell(numgroups,1);
inipoint = 1;
for k = 1:numgroups
    dataT = Olengthsets(k);
    B{k} = mergeB(:,inipoint:inipoint+dataT-1);
    inipoint = inipoint+dataT;
end


end