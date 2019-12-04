function [min_img,dark_img] = getDarkChannel(img,r)
%getDarkChannel ��ȡͼ��ͨ��
%   img��ԭʼͼ��
%   r�����ڰ뾶
[h,w,c] = size(img);
min_img = zeros(h,w);
dark_img = zeros(h,w);
if c==3
    for i = 1:h
        for j = 1:w
           min_img(i,j) = min(img(i,j,:));%r��g��b��ͨ��ѡ����Сֵ
        end
    end
else 
    warning = warndlg('ѡ��rgbͼ��','image style error');
end
newimg = ones(h+2*r,w+2*r)*255; %���䷽�㴦��
newimg(r+1:h+r,r+1:w+r) = min_img(:,:);
win = 2*r+1;
for i = 1:h
    for j = 1:w
        list = reshape(newimg(i:i+win-1,j:j+win-1),1,win*win);
        temp = min(list(:)); 
        dark_img(i,j) = temp;   %�Ҵ�������Сֵ
    end
end
% kernel = ones(r*2+1);
% dark_img = imerode(dark_img, kernel);%��Сֵ�˲����õ���ǰ�����е���Сֵ���õ���ͨ��ͼ��
min_img = uint8(min_img);
dark_img = uint8(dark_img);
end