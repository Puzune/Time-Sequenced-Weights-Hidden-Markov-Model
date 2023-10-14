function rho = dataprocess3_LC_rho(cardata,data,direction)

if strcmp(direction,'left')
    flag = 1;
elseif strcmp(direction,'right')
    flag = -1;
else
    disp('方向输入不正确！')
    return
end

numframes = height(cardata);
rho = zeros(numframes,1);
for k = 1:numframes
    currentframe = cardata.frame(k);
    egocarX = cardata.x(k);
    Xrange = [egocarX-80,egocarX+80]; % 传感器探测范围
    egocarVx = cardata.xVelocity(k);
    othercardata = data(data.frame==currentframe,:);
    othercardata(othercardata.laneId~=((cardata.laneId(1)<5)* ...
        (cardata.laneId(1)+flag)+(cardata.laneId(1)>5)* ...
        (cardata.laneId(1)-flag)),:) = [];
    othercardata = othercardata((othercardata.x>=Xrange(1))& ...
        (othercardata.x<=Xrange(2)),:);
    if isempty(othercardata)
        cardata.rho_leftlane(k) = 0;
        continue
    end
    temprho = (egocarVx-othercardata.xVelocity)./(othercardata.x-egocarX);
    temprho(temprho<0) = 0;
    temprho = min(sum(temprho),1);
    rho(k) = temprho;
end