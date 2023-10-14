function mergexi = compute_xi_dfhmm(TR,B, ...
    salpha,sbeta)

[N,numK,~] = size(salpha);

mergesalpha = reshape(permute(salpha,[1 3 2]),N,[]);
Bsbeta = B.*sbeta;
Bsbeta = Bsbeta(:,:,2:end);

offsetBsbeta = cat(3,Bsbeta,ones(N,numK,1));
mergeBsbeta = reshape(permute(offsetBsbeta,[1 3 2]),N,[]);

numdata = size(mergesalpha,2);

a = reshape(mergesalpha,[N,1,numdata]);
b = reshape(mergeBsbeta,[1,N,numdata]);
mergexi= a.*b;

mergexi = mergexi .* TR;