function LKdata = dataprocess3_LK(data,recordingMetaData,tracksMetaData)

lkid = tracksMetaData.id(tracksMetaData.numLaneChanges==0);
numlk = length(lkid);
flag = 3;

LKdata = cell(numlk,2);
for i =1:5:numlk
    id = lkid(i);
    % 剔除卡车
    carclass = tracksMetaData.class(tracksMetaData.id==id);
    if ~strcmp(carclass{1},'Car')
        continue
    end
    cardata = data(data.id==id,:);
    if isempty(cardata)
        continue
    end
    % 剔除片头片尾车辆
    if (cardata.x(1)>10)||(cardata.x(end)<390)
        continue
    end
    % 计算航向角
    tempx = cardata.x;
    tempy = cardata.y;
    [f,fangle] = HeadingAngle(tempx,tempy);
    cardata.fity = f;
    cardata.HeadingAngle = fangle;
    %   截取中间30%的数据
    inipoint = floor(0.35*height(cardata));
    endpoint = ceil(0.65*height(cardata));
    cardata = cardata(inipoint:endpoint,:);
    % 标记LK
    cardata.DrivingBehavior = ones(height(cardata),1)*flag;
    %   计算本车道危险系数
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
    LKdata{i,1} = cardata;
    LKdata{i,2} = flag;
end
LKdata = LKdata(~cellfun('isempty',LKdata(:,1)),:);