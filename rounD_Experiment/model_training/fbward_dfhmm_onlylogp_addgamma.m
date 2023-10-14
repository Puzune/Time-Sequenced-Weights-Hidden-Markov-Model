function logps = fbward_dfhmm_onlylogp_addgamma(INISTATE,TR,B,gamma,gpu)

[N,numK,tw] = size(B);

if gpu==1
    salpha = zeros(N,numK,tw,'gpuArray');
    c = zeros(tw,numK,'gpuArray');
else
    salpha = zeros(N,numK,tw);
    c = zeros(tw,numK);
end

% 计算前向概率
% tempalpha1 = INISTATE .* B(:,:,1);
tempalpha1 = (INISTATE .* B(:,:,1)).^(gamma.^(tw-1));
tempalpha1(:,sum(tempalpha1)==0) = eps;
c(1,:) = 1./sum(tempalpha1,1);
% if any(isnan(c),"all")
%     disp('前向概率初值为0')
%     keyboard
% end
salpha(:,:,1) = tempalpha1.*c(1,:);
for t = 2:tw
    tempalphat = (TR').^(gamma.^(tw-t)) * salpha(:,:,t-1) .* ...
        (B(:,:,t)).^(gamma.^(tw-t));
    tempalphat(:,sum(tempalphat)==0) = eps;
    c(t,:) = 1./sum(tempalphat,1);
    % if any(isnan(c),'all')
    %     disp('前向概率出现0')
    % end
    salpha(:,:,t) = tempalphat.*c(t,:);
end

logps = -sum(log(c),1);