clc;clear
load TIA_b.mat tia
tia = cellfun(@(x) [x(end) max(x)],tia,'UniformOutput',false);
tia = cell2mat(tia);
tia = [tia,tia(:,2)-tia(:,1)];