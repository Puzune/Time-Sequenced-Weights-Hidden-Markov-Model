function data = datasplitbytw2(doubledata,t)

n = size(doubledata,1)-t+1;
if n<1
    % data{1} = doubledata;
    data = [];
else
    data = cell(n,1);
    for i = 1:n
        temp = doubledata(i:i+t-1,:);
        data{i} = temp;
    end
end