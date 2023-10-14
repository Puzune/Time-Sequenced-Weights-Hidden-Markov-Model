function [f,fangle] = HeadingAngle(tempx,tempy)
%   计算轨迹(x,y)的拟合轨迹f，航向角fangle，单位度

% 确定拟合多项式的最高次数
n = floor(sqrt(length(tempx)))+1;
% 用标准化多项式拟合轨迹
warning('off','MATLAB:polyfit:RepeatedPoints')
flag = 1;
while (~isempty(lastwarn))||(flag)
    flag = 0;
    lastwarn('')
    n = n-1;
    [p,~,mu] = polyfit(tempx,tempy,n);

end
% 多项式轨迹
f = polyval(p,tempx,[],mu);
% 多项式微分
k = polyder(p)/mu(2);
% 微分公式曲线，即多项式轨迹各点斜率
fslope = polyval(k,tempx,[],mu);
% 将斜率转为弧度
frad = atan(fslope);
% 将弧度转为角度
fangle = frad*180/pi;