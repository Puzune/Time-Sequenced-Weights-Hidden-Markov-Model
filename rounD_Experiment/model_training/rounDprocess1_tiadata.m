function [LCdata,LKdata] = rounDprocess1_tiadata(data,metadata,info)
[c,r,EEtheta,sangle] = findcircle(info,data);
%% 排除非car类
data(ismember(data.trackId, ...
    metadata.trackId(~strcmp(metadata.class,'car'))),:) = [];
%% 排除未进入环岛的车辆
data = data(ismember(data.trackId, ...
    table2array(unique(data(sqrt((data.xCenter-c(1)).^2+ ...
    (data.yCenter-c(2)).^2)<r,"trackId")))),:);
%% 掐头去尾
data(ismember(data.trackId,data.trackId(data.frame==min(data.frame)| ...
    data.frame==max(data.frame))),:) = [];
%% 计算每个时间步上车辆所在位置的theta
data.theta = cartesianToPolarAngle(data.xCenter-c(1),data.yCenter-c(2));
%% 计算每个时间步上车辆所在位置的rho
data.rho = sqrt((data.xCenter-c(1)).^2+(data.yCenter-c(2)).^2);
%% 给定标签并提取数据
label_angle = EEtheta(1:2:end);
caridsets = unique(data.trackId)';
n = length(caridsets);
LCdata = cell(n,1);
LKdata = cell(n,1);
for i = 1:n
    id = caridsets(i);
    tempdata = data(data.trackId==id,:);
    % 跳过开头即在环岛内的数据
    if tempdata.rho(1)<r
        continue
    end
    % 去除不在环岛内的数据
    tempdata(tempdata.rho>r,:) = [];
    
    ep2langle = abs(tempdata.theta(end)-label_angle);
    ep2langle(ep2langle>180) = 360-ep2langle(ep2langle>180);
    [~,Exitid] = min(ep2langle);
    tempdata.Exitid = ones(height(tempdata),1)*Exitid;
    if Exitid==1
        startid = 4;
    else
        startid = Exitid-1;
    end
    startangle = sangle(startid);
    deltaAngle = abs(tempdata.theta-startangle);
    if all(deltaAngle>180)
        deltaAngle = 360-deltaAngle;
    end
    [~,startindex] = min(deltaAngle);
    if startindex<50
        continue
    end
    if ((height(tempdata)-startindex+1)<25)|| ...
        ((height(tempdata)-startindex+1)>100)
        continue
    end
    % if ((height(tempdata)-startindex+1)<77)|| ...
    %     ((height(tempdata)-startindex+1)>85)
    %     continue
    % end
    tempLCdata = tempdata(1:end,:);
    % tempLCdata = tempdata(startindex-50:end,:);
    LCdata{i} = tempLCdata;
    tempLKdata = tempdata(1:startindex-1,:);
    if isempty(tempLKdata)
        continue
    end
    LKdata{i} = tempLKdata;
end
LCdata = LCdata(~cellfun('isempty',LCdata));
LKdata = LKdata(~cellfun('isempty',LKdata));