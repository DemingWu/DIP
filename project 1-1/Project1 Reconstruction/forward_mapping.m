clc
clear all 
close all
load ('Data/FrameData.mat');
load ('Data/GpsData.mat');
load ('Data/CalibrationPoints.mat');
% 
% for n = (1:694)
%     plot3(gpsData(1,:,n),gpsData(2,:,n),gpsData(3,:,n),'-');
%     hold on;
% end
for n =(1:4)
    gpsdata(:,n) = [calibrationPoints(:,n,1)',1];
end
transformation = calibrationPoints(:,:,2) / gpsdata;
% %º∆À„gpsData µΩ sceneData
% for n =(1:694)
%     for m =(1:4)
%     gpsdata(:,m) = [gpsData(:,m,n)',1];
%     end
%     scenedata(:,:,n) = transformation*gpsdata;
%     plot3(scenedata(1,:,n),scenedata(2,:,n),scenedata(3,:,n)) ;
%     hold on;
% end

% for n =(1:4)
%     gpsdata(:,n) = [scenedata(:,n,1)',1];
% end
% location=[1,1,240,240;1,320,320,1;1,1,1,1];
% transformation = location / gpsdata;

for n =(1:694)
    frame = frameData{n};
    for m =(1:320)
        for k = (1:240)
            locationfram = [k;m;n;1];
            location = transformation*locationfram;
            k1=round(location(1));
            m1=round(location(2));
            n1=round(location(3));
            if n1<1
                n1=1;
            end
             if m1<1
                m1=1;
             end
             if k1<1
                k1=1;
             end            
            reconstratedata(k1,m1,n1) = frame(k,m);
        end
    end
end





