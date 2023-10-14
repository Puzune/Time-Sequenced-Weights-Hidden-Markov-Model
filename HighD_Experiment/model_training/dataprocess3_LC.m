function LCdata = dataprocess3_LC(data,recordingMetaData,tracksMetaData)

lcid = tracksMetaData.id(tracksMetaData.numLaneChanges==1);
numlc = length(lcid);

LCdata = cell(numlc,2);
for i = 1:numlc
    id = lcid(i);
    cardata = data(data.id==id,:);
    % 剔除过短数据
    if height(cardata)<=50
        continue
    end
    % 计算航向角
    tempx = cardata.x;
    tempy = cardata.y;
    [f,fangle] = HeadingAngle(tempx,tempy);
    cardata.fity = f;
    cardata.HeadingAngle = fangle;
    % 舍弃越过车道线后的数据
    cardata = cardata(1:find(cardata.laneId==cardata.laneId(1),1, ...
        'last'),:);
    if height(cardata)<20
        continue
    end
    % 舍弃换道前数据，以航向角=0为换道起始点
    templogic = (cardata.HeadingAngle>0);
    LCinipoint = find(templogic~=templogic(end),1,'last')+1;
    if isempty(LCinipoint)
        LCinipoint = 1;
    end
    cardata = cardata(LCinipoint:end,:);
    % 判断换道方向
    if all(cardata.HeadingAngle<0)
        flag = 1;
    elseif all(cardata.HeadingAngle>0)
        flag = 2;
    else
        disp('换道方向错误！')
        keyboard
    end
    cardata.DrivingBehavior = ones(height(cardata),1)*flag;
    % 计算本车道危险系数
    cardata.ttc(cardata.ttc<0) = 0;
    rho_currentlane = 1./cardata.ttc;
    rho_currentlane(rho_currentlane==inf) = 0;
    rho_currentlane(rho_currentlane>1) = 1;
    cardata.rho_currentlane = rho_currentlane;
    cardata = removevars(cardata,"ttc");
    % 计算左右两侧车道危险系数
    if (cardata.laneId(1)==4)||(cardata.laneId(1)==6)
        cardata.rho_leftlane = ones(height(cardata),1);
        cardata.rho_rightlane = dataprocess3_LC_rho(cardata,data,'right');
    elseif (cardata.laneId(1)==2)||(cardata.laneId(1)==8)
        cardata.rho_leftlane = dataprocess3_LC_rho(cardata,data,'left');
        cardata.rho_rightlane = ones(height(cardata),1);
    elseif (cardata.laneId(1)==3)||(cardata.laneId(1)==7)
        cardata.rho_leftlane = dataprocess3_LC_rho(cardata,data,'left');
        cardata.rho_rightlane = dataprocess3_LC_rho(cardata,data,'right');
    end
    % 保存
    LCdata{i,1} = cardata;
    LCdata{i,2} = flag;
end
LCdata = LCdata(~cellfun('isempty',LCdata(:,1)),:);