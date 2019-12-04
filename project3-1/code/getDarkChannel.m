function [min_img,dark_img] = getDarkChannel(img,r)
%getDarkChannel 获取图像暗通道
%   img：原始图像
%   r：窗口半径
[h,w,c] = size(img);
min_img = zeros(h,w);
dark_img = zeros(h,w);
if c==3
    for i = 1:h
        for j = 1:w
           min_img(i,j) = min(img(i,j,:));%r、g、b三通道选择最小值
        end
    end
else 
    warning = warndlg('选择rgb图像','image style error');
end
newimg = ones(h+2*r,w+2*r)*255; %扩充方便处理
newimg(r+1:h+r,r+1:w+r) = min_img(:,:);
win = 2*r+1;
for i = 1:h
    for j = 1:w
        list = reshape(newimg(i:i+win-1,j:j+win-1),1,win*win);
        temp = min(list(:)); 
        dark_img(i,j) = temp;   %找窗口中最小值
    end
end
% kernel = ones(r*2+1);
% dark_img = imerode(dark_img, kernel);%最小值滤波，得到当前窗口中的最小值，得到暗通道图像
min_img = uint8(min_img);
dark_img = uint8(dark_img);
end