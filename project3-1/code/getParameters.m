function [AtmosLight,transmittance]= getParameters(img,dark_img,percent,omega,transmittance_min)
%getAtmosLight����ȡ��ǰͼƬ�Ĵ�����ֵ��͸����
%   img��ԭʼͼƬ
%   dark_img����ͨ��ͼƬ
%   percent��ȡǰ�ٷ�֮������ֵ
%   omega��ȥ�������̶�
%   transmittance_min��͸������Сֵ
[h,w,c] = size(img);
imglist = reshape(dark_img,1,h*w);%����ͨ�����½ṹ��1*��h*w)���飬��������
[imglist,index] = sort(imglist,'descend');%���򲢼�¼λ��
%AtmosLight = mean(imglist(1:ceil(percent*h*w)));%ѡ��ǰpercent������ƽ��ֵ��Ϊ������ֵ
sumall = 0;
for i = 1:ceil(percent*h*w)
    sumall = sumall + sum(double(img(floor(index(i)/w)+1,mod(index(i),w),:)));%������ͨ��������������
end
AtmosLight  = sumall/(ceil(percent*h*w)*3);%�����ͨ��������ֵ
transmittance = 1-omega*double(dark_img)/AtmosLight;%���͸����
for i = 1:h
    for j = 1:w
        transmittance(i,j) = max(transmittance_min ,transmittance(i,j));%ȷ�������ʲ�Ҫ̫С
    end
end
end