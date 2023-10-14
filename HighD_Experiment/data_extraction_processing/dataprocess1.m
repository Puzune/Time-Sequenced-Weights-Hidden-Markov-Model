function LCKtable = dataprocess1(recordingMetaData,tracksData,tracksMetaData)

%% 先进行可以对所有车辆进行的操作
% 将坐标中心从车辆左上角移动至车辆中心
tracksData.x = tracksData.x + 0.5 * tracksData.width;
tracksData.y = tracksData.y + 0.5 * tracksData.height;
%   删除不需要变量，方便查看数据
tracksData = removevars(tracksData,["frontSightDistance", ...
    "backSightDistance","dhw","thw","precedingXVelocity", ...
    "precedingId","followingId","leftPrecedingId","leftAlongsideId", ...
    "leftFollowingId","rightPrecedingId","rightAlongsideId", ...
    "rightFollowingId"]);

%% 将数据划分为上车道和下车道两类
upperdata = tracksData(ismember(tracksData.id, ...
    tracksMetaData.id(tracksMetaData.drivingDirection==1)),:);
lowerdata = tracksData(ismember(tracksData.id, ...
    tracksMetaData.id(tracksMetaData.drivingDirection==2)),:);
%% 分别处理上下车道数据--调整坐标系，并添加deltay
upperdata = dataprocess2_upperdata_coordinateSystem(upperdata, ...
    recordingMetaData);
lowerdata = dataprocess2_lowerdata_coordinateSystem(lowerdata, ...
    recordingMetaData);
%% 开始提取换道数据
upperLCdata = dataprocess3_LC(upperdata,recordingMetaData,tracksMetaData);
lowerLCdata = dataprocess3_LC(lowerdata,recordingMetaData,tracksMetaData);
LCdata = [upperLCdata;lowerLCdata];
%% 开始提取直行数据
upperLKdata = dataprocess3_LK(upperdata,recordingMetaData,tracksMetaData);
lowerLKdata = dataprocess3_LK(lowerdata,recordingMetaData,tracksMetaData);
LKdata = [upperLKdata;lowerLKdata];
%% 合并LC,LK为表格
LCKdata = [LCdata;LKdata];
LCKtable = cell2table(LCKdata,"VariableNames",{'Samples','Label'});