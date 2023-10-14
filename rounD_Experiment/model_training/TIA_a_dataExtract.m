clc;clear
load info.mat
recordingMetaRoute = dir(['C:\Sensors_resubmit\rounD\' ...
    'drone-dataset-tools\data\*recordingMeta.csv']);
tracksRoute = dir(['C:\Sensors_resubmit\rounD\' ...
    'drone-dataset-tools\data\*tracks.csv']);
tracksMetaRoute = dir(['C:\Sensors_resubmit\rounD\' ...
    'drone-dataset-tools\data\*tracksMeta.csv']);
numRecordings = length(recordingMetaRoute);

LCtiadata = [];
for i = 1:numRecordings
    tic
    recordingMeta = readtable(strcat(recordingMetaRoute(i).folder,'\',...
        recordingMetaRoute(i).name));
    if recordingMeta.locationId~=0
        continue
    end
    tracks = readtable(strcat(tracksRoute(i).folder,'\',...
        tracksRoute(i).name));
    tracksMeta = readtable(strcat(tracksMetaRoute(i).folder,'\',...
        tracksMetaRoute(i).name));
    tempLCdata = rounDprocess1_tiadata(tracks,tracksMeta, ...
        info{recordingMeta.recordingId});
    LCtiadata = [LCtiadata;tempLCdata];
    toc
    disp(i)
end
save("TIA_a_data.mat","LCtiadata")