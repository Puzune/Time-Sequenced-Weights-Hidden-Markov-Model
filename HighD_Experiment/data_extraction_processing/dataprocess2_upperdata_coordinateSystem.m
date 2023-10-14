function upperdata = dataprocess2_upperdata_coordinateSystem(upperdata, ...
    recordingMetaData)

%% 将坐标系移动至右下角
upperdata.x = max(upperdata.x)-upperdata.x;
LaneMarkings = str2num(recordingMetaData.upperLaneMarkings{1});
upperdata.y = LaneMarkings(end)-upperdata.y;
upperdata.xVelocity = -upperdata.xVelocity;
upperdata.yVelocity = -upperdata.yVelocity;
upperdata.xAcceleration = -upperdata.xAcceleration;
upperdata.yAcceleration = -upperdata.yAcceleration;

%% 计算\Delta y
LaneMarkings = max(LaneMarkings)-LaneMarkings;
centerlane = diff(LaneMarkings)/2 + LaneMarkings(1:end-1);
upperdata.deltay = upperdata.y-centerlane(upperdata.laneId-1);