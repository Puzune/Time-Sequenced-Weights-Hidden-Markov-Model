function logps = fbward_dfhmm_onlylogp(INISTATE,TR,B)

[N,numK,tw] = size(B);

salpha = zeros(N,numK,tw);
sbeta = ones(N,numK,tw);
c = zeros(tw,numK);

% 计算前向概率
tempalpha1 = INISTATE .* B(:,:,1);
tempalpha1(:,sum(tempalpha1)==0) = eps;
c(1,:) = 1./sum(tempalpha1,1);
if any(isnan(c),"all")
    disp('前向概率初值为0')
    keyboard
end
salpha(:,:,1) = tempalpha1.*c(1,:);
for t = 2:tw
    tempalphat = TR' * salpha(:,:,t-1) .* B(:,:,t);
    tempalphat(:,sum(tempalphat)==0) = eps;
    c(t,:) = 1./sum(tempalphat,1);
    if any(isnan(c),'all')
        disp('前向概率出现0')
    end
    salpha(:,:,t) = tempalphat.*c(t,:);
end

logps = -sum(log(c),1);