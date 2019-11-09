clc
clear all 
close all
load ('Data/FrameData.mat');
load ('Data/GpsData.mat');
load ('Data/CalibrationPoints.mat');
for n = 1:694
    stackbystack(:,:,n)=frameData{n};
end
isosurface(stackbystack);

