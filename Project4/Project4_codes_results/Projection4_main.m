clc;close all;clear;
img=imread('Data/License_plates.jpg');
%�����и���ر���ͼƬ��·��
%path=easy_Detection(img);%�����ָ�
path=Dec_commbine_region(img);%������ͨ
%path=Detection_region(img);%���ڱ����ָ�ľֲ�ϸ��
strnam = dir([path,'/*.jpg']);%��ȡ�ָ��˶��ٳ���
[m,~]=size(strnam);
temppath='Data/model/';%ģ��·��
for i=1:m
    filename=[path,num2str(i, '%d'),'.jpg'];
    %%���Ʒָʶ��recognition����������ָ��ʶ��Ϊ�˲������㽫�ָ��ʶ�����һ�������
    %segmentation����ʵ��radon��hough�任
    Recognition(filename,temppath,'radon');
end