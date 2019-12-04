close all;clc;clear;
%% picture 1
origin = imread('fog1.jpg');
subplot(231);imshow(origin);title('fog1');
[h,w,c] = size(origin);
[min_img,dark_img] = getDarkChannel(origin,7);%得到三通道最小值图和暗通道图，
% imshow(dark_img);

subplot(232);imshow(dark_img);title('darkFog1');
[AtmosLight,transmittance] = getParameters(origin,dark_img,0.001,0.95,0.1);%得到大气光值和透射率
subplot(233);imshow(transmittance);title('tranFog1');
for i = 1:c
 origin(:,:,i) = uint8((double(origin(:,:,i))-AtmosLight)./transmittance(:,:)+AtmosLight);%原图像根据公式推导
end
subplot(234);imshow(origin);title('moveFog1');
%% picture 1 guild filt
origin = imread('fog1.jpg');
r = 8; % 窗口大小
eps = 0.2^2; % 正则化参数
transmittance = guidedfilter(double(min_img)/255,transmittance,r,eps);%三通道最小值图片作为guided图，透射率图作为filter图
subplot(236);imshow(transmittance);title('tranGuideFog1');
for i = 1:c
 origin(:,:,i) = uint8((double(origin(:,:,i))-AtmosLight)./transmittance(:,:)+AtmosLight);
end
subplot(235);imshow(origin);title('moveGuideFog1');
%saveas(gcf,'result1','jpg');

%% picture 2
origin = imread('fog2.jpg');
figure;
subplot(241);imshow(origin);title('fog2');
[h,w,c] = size(origin);
[min_img,dark_img] = getDarkChannel(origin,7);
subplot(242);imshow(dark_img);title('darkFog2');
[AtmosLight,transmittance] = getParameters(origin,dark_img,0.001,0.95,0.1);
subplot(243);imshow(transmittance);title('tranFog2');
for i = 1:c
 origin(:,:,i) = uint8((double(origin(:,:,i))-AtmosLight)./transmittance(:,:)+AtmosLight);
end
subplot(245);imshow(origin);title('moveFog2');
%% picture 2 guild filt
origin = imread('fog2.jpg');
r = 8; 
eps = 0.2^2;
transmittance = guidedfilter(double(min_img)/255,transmittance,r,eps);
transmittance_sky = avoidSky(dark_img,AtmosLight,transmittance);
transmittance_sky = guidedfilter(double(min_img)/255,transmittance_sky,r,eps);
subplot(244);imshow(transmittance);title('tranGuideFog2');
%transmittance = imguidedfilter(transmittance,origin);%test
%guidedfilter_color(double(origin(:,:,:))/255.0,transmittance,r,eps);%test

subplot(248);imshow(transmittance_sky);title('tranGuideSkyFog2');
%subplot(236);imshow(transmittance);title('tranGuideFog2');
for i = 1:c
    origin1(:,:,i) = uint8((double(origin(:,:,i))-AtmosLight)./transmittance(:,:)+AtmosLight);
    origin2(:,:,i) = uint8((double(origin(:,:,i))-AtmosLight)./transmittance_sky(:,:)+AtmosLight);
end
%origin = imfilter(origin,fspecial('gaussian'));
subplot(246);imshow(origin1);title('moveGuideFog2');
subplot(247);imshow(origin2);title('moveGuideSkyFog2');
%saveas(gcf,'result2','jpg');