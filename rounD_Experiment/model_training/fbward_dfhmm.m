function [salpha, sbeta, logp] = fbward_dfhmm(INISTATE,TR,B)

[N,numK,tw] = size(B);

% salpha = zeros(N,numK,tw);
% sbeta = zeros(N,numK,tw);
% c = zeros(tw,numK);

% gpu化
salpha = zeros(N,numK,tw,'gpuArray');
sbeta = zeros(N,numK,tw,'gpuArray');
c = zeros(tw,numK,'gpuArray');

sbeta(:,:,tw) = 1;

% 计算前向概率
tempalpha1 = INISTATE .* B(:,:,1);
tempalpha1(:,sum(tempalpha1,1)==0) = eps;
c(1,:) = 1./sum(tempalpha1,1);
if any(isnan(c),"all")
    disp('前向概率初值为0')
    keyboard
end
salpha(:,:,1) = tempalpha1.*c(1,:);
for t = 2:tw
    tempalphat = TR' * salpha(:,:,t-1) .* B(:,:,t);
    tempalphat(:,sum(tempalphat,1)==0) = eps;
    c(t,:) = 1./sum(tempalphat,1);
    % if any(isnan(c),'all')
    %     disp('前向概率出现0')
    % end
    salpha(:,:,t) = tempalphat.*c(t,:);
end
% 计算后向概率
sbeta(:,:,tw) = sbeta(:,:,tw) .* c(tw,:);
for t = tw-1:-1:1
    tempbetat = TR * (B(:,:,t+1) .* sbeta(:,:,t+1));
    tempbetat(:,sum(tempbetat,1)==0) = eps;
    sbeta(:,:,t) = tempbetat .* c(t,:);
end
logp = -sum(log(c),"all");
