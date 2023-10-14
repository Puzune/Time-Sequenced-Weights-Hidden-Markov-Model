function mergexi = compute_xi_dfhmm(TR,B, ...
    salpha,sbeta)

[N,numK,~] = size(salpha);

mergesalpha = reshape(permute(salpha,[1 3 2]),N,[]);
Bsbeta = B.*sbeta;

% Bsbeta2 = Bsbeta;

% way2
Bsbeta = Bsbeta(:,:,2:end);

% % way1
% tic
% Bsbeta2(:,:,1) = [];
% toc


offsetBsbeta = cat(3,Bsbeta,ones(N,numK,1));
mergeBsbeta = reshape(permute(offsetBsbeta,[1 3 2]),N,[]);

numdata = size(mergesalpha,2);

a = reshape(mergesalpha,[N,1,numdata]);
b = reshape(mergeBsbeta,[1,N,numdata]);
mergexi= a.*b;

mergexi = mergexi .* TR;
% if any(isnan(mergexi),"all")
%     disp('已暂停')
%     keyboard
% end