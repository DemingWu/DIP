clc;close all;clear;
img=imread('Data/License_plates.jpg');
%车牌切割，返回保存图片的路径
%path=easy_Detection(img);%暴力分割
path=Dec_commbine_region(img);%区域连通
%path=Detection_region(img);%基于暴力分割的局部细化
strnam = dir([path,'/*.jpg']);%读取分割了多少车牌
[m,~]=size(strnam);
temppath='Data/model/';%模板路径
for i=1:m
    filename=[path,num2str(i, '%d'),'.jpg'];
    %%车牌分割并识别，recognition函数里包含分割和识别，为了操作方便将分割和识别放在一个函数里，
    %segmentation函数实现radon和hough变换
    Recognition(filename,temppath,'radon');
end