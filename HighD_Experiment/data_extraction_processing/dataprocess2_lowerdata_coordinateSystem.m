function lowerdata = dataprocess2_lowerdata_coordinateSystem(lowerdata, ...
    recordingMetaData)

%% 将坐标系移动至左下角的左上角
lowerdata.x = lowerdata.x-min(lowerdata.x);
LaneMarkings = str2num(recordingMetaData.lowerLaneMarkings{1});
lowerdata.y = lowerdata.y-LaneMarkings(1);

%% 计算\Delta y
LaneMarkings = LaneMarkings-min(LaneMarkings);
centerlane = diff(LaneMarkings)/2 + LaneMarkings(1:end-1);
lowerdata.deltay = lowerdata.y-centerlane(lowerdata.laneId-5);