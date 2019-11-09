clc
clear all 
close all
load ('Data/FrameData.mat');
load ('Data/GpsData.mat');
load ('Data/CalibrationPoints.mat');
for n =(1:4)
    gpsdata(:,n) = [calibrationPoints(:,n,1)',1];
end
transformation = calibrationPoints(:,:,2) / gpsdata;
for n =(1:694)
    for m =(1:4)
    gpsdata(:,m) = [gpsData(:,m,n)',1];
    end
    scenedata(:,:,n) = transformation*gpsdata;
%     plot3(scenedata(1,:,n),scenedata(2,:,n),scenedata(3,:,n)) ;
%     hold on;
end