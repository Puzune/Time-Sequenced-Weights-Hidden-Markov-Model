function [B,Tidx] = observation_prob_dfhmm(data,mu,sigma,df, ...
    numgroups,tw,D)

% 隐状态数
N = size(mu,2);
% 计算协方差矩阵的行列式和逆
detsigma = zeros(N,1);
invsigma = zeros(D,D,N);
for k = 1:N
    tempsigma = sigma(:,:,k);
    % while rcond(tempsigma)<1e-6
    %     tempsigma = tempsigma+0.001*eye(D);
    %     keyboard
    % end
    tempdetsigma = det(tempsigma);
    detsigma(k) = tempdetsigma;
    tempinvsigma = inv(tempsigma);
    % if isnan(rcond(tempsigma))
    %     keyboard
    % end
    invsigma(:,:,k) = tempinvsigma;
end

Tidx = repmat((tw-1:-1:0)',1,numgroups);
Tidx = Tidx(:)';
dfsequences = df.^Tidx;

mergeB = zeros(N,size(data,2));
for n = 1:N
    tempmu = mu(:,n);
    tempdetsigma = detsigma(n);
    tempinvsigma = invsigma(:,:,n);
    x = data-tempmu;
    Mdistance = sum(tempinvsigma * x .* x);
    DFMdistance = dfsequences.*Mdistance;
    lnGaussian_pro = ...
        -0.5*D*log(2*pi)-0.5*log(tempdetsigma)+ ...
        0.5*D*Tidx*log(df) - 0.5*DFMdistance;
    Gaussian_pro = exp(lnGaussian_pro)+eps;
    mergeB(n,:) = Gaussian_pro;
end

B = reshape(mergeB,N,tw,numgroups);
B = permute(B,[1 3 2]);