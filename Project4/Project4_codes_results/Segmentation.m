 function [img] = Segmentation( I,method )
%% 利用hough变换实现车牌图像的倾斜校正
[h,w,k]=size(I);
img=zeros(h,w,k);
if strcmp(method,'hough')==1
%I = imread('region/22.jpg');  % read image into workspace
%figure;
%subplot(131), imshow(I); 
I1 = rgb2gray(I);  % 将原始图像转换为灰度图像
I2 = wiener2(I1, [5, 5]);  % 对灰度图像进行维纳滤波
I3 = edge(I2, 'canny');  % 边缘检测
%subplot(132), imshow(I3); 
[m, n] = size(I3);  % compute the size of the image
rho = round(sqrt(m^2 + n^2)); % 获取ρ的最大值，此处rho=282
theta = 180; % 获取θ的最大值
r = zeros(rho, theta);  % 产生初值为0的计数矩阵
for i = 1 : m
   for j = 1 : n
      if I3(i,j) == 1  % I3是边缘检测得到的图像
          for k = 1 : theta
             ru = round(abs(i*cosd(k) + j*sind(k)));
             r(ru+1, k) = r(ru+1, k) + 1; % 对矩阵计数 
          end
      end
   end
end
r_max = r(1,1); 
for i = 1 : rho
   for j = 1 : theta
       if r(i,j) > r_max
          r_max = r(i,j); 
          c = j; % 把矩阵元素最大值所对应的列坐标送给c
       end
   end
end
if c <= 90
   rot_theta = -c;  % 确定旋转角度
else
    rot_theta = 180 - c; 
end
img = imrotate(I, rot_theta, 'crop');  % 对图像进行旋转，校正图像
%subplot(133), imshow(img);
% set(0, 'defaultFigurePosition', [100, 100, 1200, 450]); % 修改图像位置的默认设置
% set(0, 'defaultFigureColor', [1, 1, 1]); % 修改图像背景颜色的设置
%% 利用Radon变换实现车牌图像的倾斜校正
elseif strcmp(method,'radon')==1
%I = imread('region/36.jpg'); 
%subplot(131), imshow(I);
I1 = rgb2gray(I); 
I2 = wiener2(I1, [5, 5]); 
I3 = edge(I2, 'canny'); 
%subplot(132), imshow(I3); 
theta = 0 : 179;
r = radon(I3, theta); 
[m, n] = size(r); 
c = 1; 
for i = 1 : m
   for j = 1 : n
      if r(1,1) < r(i,j)
         r(1,1) = r(i,j);
         c = j;
      end
   end
end
rot_theta = 90 - c; 
img = imrotate(I, rot_theta, 'crop');
%subplot(133), imshow(img); 
end

