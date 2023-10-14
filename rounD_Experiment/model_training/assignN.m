function [n1,n2,n3] = assignN(Nsets,i)

numclasses = size(Nsets,2);
n1 = Nsets(i,1);
n2 = Nsets(i,2);
if numclasses==3
    n3 = Nsets(i,3);
else
    n3 = [];
end