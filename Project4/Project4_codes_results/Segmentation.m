 function [img] = Segmentation( I,method )
%% ����hough�任ʵ�ֳ���ͼ�����бУ��
[h,w,k]=size(I);
img=zeros(h,w,k);
if strcmp(method,'hough')==1
%I = imread('region/22.jpg');  % read image into workspace
%figure;
%subplot(131), imshow(I); 
I1 = rgb2gray(I);  % ��ԭʼͼ��ת��Ϊ�Ҷ�ͼ��
I2 = wiener2(I1, [5, 5]);  % �ԻҶ�ͼ�����ά���˲�
I3 = edge(I2, 'canny');  % ��Ե���
%subplot(132), imshow(I3); 
[m, n] = size(I3);  % compute the size of the image
rho = round(sqrt(m^2 + n^2)); % ��ȡ�ѵ����ֵ���˴�rho=282
theta = 180; % ��ȡ�ȵ����ֵ
r = zeros(rho, theta);  % ������ֵΪ0�ļ�������
for i = 1 : m
   for j = 1 : n
      if I3(i,j) == 1  % I3�Ǳ�Ե���õ���ͼ��
          for k = 1 : theta
             ru = round(abs(i*cosd(k) + j*sind(k)));
             r(ru+1, k) = r(ru+1, k) + 1; % �Ծ������ 
          end
      end
   end
end
r_max = r(1,1); 
for i = 1 : rho
   for j = 1 : theta
       if r(i,j) > r_max
          r_max = r(i,j); 
          c = j; % �Ѿ���Ԫ�����ֵ����Ӧ���������͸�c
       end
   end
end
if c <= 90
   rot_theta = -c;  % ȷ����ת�Ƕ�
else
    rot_theta = 180 - c; 
end
img = imrotate(I, rot_theta, 'crop');  % ��ͼ�������ת��У��ͼ��
%subplot(133), imshow(img);
% set(0, 'defaultFigurePosition', [100, 100, 1200, 450]); % �޸�ͼ��λ�õ�Ĭ������
% set(0, 'defaultFigureColor', [1, 1, 1]); % �޸�ͼ�񱳾���ɫ������
%% ����Radon�任ʵ�ֳ���ͼ�����бУ��
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

