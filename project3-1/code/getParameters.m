function [AtmosLight,transmittance]= getParameters(img,dark_img,percent,omega,transmittance_min)
%getAtmosLight：获取当前图片的大气光值和透射率
%   img：原始图片
%   dark_img：暗通道图片
%   percent：取前百分之几做均值
%   omega：去除的雾化程度
%   transmittance_min：透射率最小值
[h,w,c] = size(img);
imglist = reshape(dark_img,1,h*w);%将暗通道重新结构成1*（h*w)数组，方便排序
[imglist,index] = sort(imglist,'descend');%排序并记录位置
%AtmosLight = mean(imglist(1:ceil(percent*h*w)));%选出前percent数据求平均值作为大气光值
sumall = 0;
for i = 1:ceil(percent*h*w)
    sumall = sumall + sum(double(img(floor(index(i)/w)+1,mod(index(i),w),:)));%计算三通道的所有最亮点
end
AtmosLight  = sumall/(ceil(percent*h*w)*3);%计算各通道大气光值
transmittance = 1-omega*double(dark_img)/AtmosLight;%算出透射率
for i = 1:h
    for j = 1:w
        transmittance(i,j) = max(transmittance_min ,transmittance(i,j));%确保折射率不要太小
    end
end
end