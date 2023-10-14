function [c,r,Entrance_Exit_theta,start_angle] = findcircle(info,data)

%% 计算c,r
n = size(info,1);
points = zeros(n,2);
for i = 1:n
    framedata = data(data.frame==info(i,1)&data.trackId==info(i,2),:);
    points(i,:) = [framedata.xCenter,framedata.yCenter];
end
[c,r] = findOptimalPointWithMean(points);
%% 计算进出口角度
relaxy = points-c;
Entrance_Exit_theta = cartesianToPolarAngle(relaxy(:,1),relaxy(:,2));
%% 计算起始角度
start_angle = zeros(4,1);
for i = 1:4
    if abs(Entrance_Exit_theta(2*i-1)-Entrance_Exit_theta(2*i))>180
        start_angle(i) = ...
        sum(Entrance_Exit_theta(2*i-1:2*i))/2+180;
        continue
    end
    start_angle(i) = sum(Entrance_Exit_theta(2*i-1:2*i))/2;
end