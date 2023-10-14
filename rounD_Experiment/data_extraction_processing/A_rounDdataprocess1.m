clc;clear
load info.mat
recordingMetaRoute = dir('drone-dataset-tools\data\*recordingMeta.csv');
tracksRoute = dir('drone-dataset-tools\data\*tracks.csv');
tracksMetaRoute = dir('drone-dataset-tools\data\*tracksMeta.csv');
numRecordings = length(recordingMetaRoute);

LCdata = [];
LKdata = [];
for i = 1:numRecordings
    recordingMeta = readtable(strcat(recordingMetaRoute(i).folder,'\',...
        recordingMetaRoute(i).name));
    if recordingMeta.locationId~=0
        continue
    end
    tracks = readtable(strcat(tracksRoute(i).folder,'\',...
        tracksRoute(i).name));
    tracksMeta = readtable(strcat(tracksMetaRoute(i).folder,'\',...
        tracksMetaRoute(i).name));
    [tempLCdata,tempLKdata] = rounDprocess1(tracks,tracksMeta, ...
        info{recordingMeta.recordingId});
    LCdata = [LCdata;tempLCdata];
    LKdata = [LKdata;tempLKdata];
end
save('A_rounDdata1.mat',"LCdata","LKdata")