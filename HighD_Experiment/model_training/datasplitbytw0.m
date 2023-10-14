function tdata = datasplitbytw0(testdata,t)

numclasses = length(testdata);
tdata = cell(numclasses,1);
for i = 1:numclasses
    tdata{i} = datasplitbytw1(testdata{i},t);
end