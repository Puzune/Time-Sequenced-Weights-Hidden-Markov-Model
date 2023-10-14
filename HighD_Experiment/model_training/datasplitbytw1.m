function data = datasplitbytw1(rowdata,t)

n = length(rowdata);

% data = [];
% for i = 1:n
%     data = [data;datasplitbytw2(rowdata{i},t)];
% end
data = cell(n,1);
for i = 1:n
    data{i} = datasplitbytw2(rowdata{i},t);
end
data(cellfun('isempty',data)) = [];