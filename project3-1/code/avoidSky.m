function  transmittance  = avoidSky( img , Atmos, transmittance)
%避免天空过曝的尝试
[h,w] = size(img);
k=35;
N = boxfilter(ones(h, w), 5); % 计算每个窗口中数据的个数，用全是1的数组代替，边缘窗口数据会少
mean_img = boxfilter(transmittance, 5) ./ N;%计算图像每个窗口均值
for i=1:h
    for j=1:w
        if mean_img(i,j)<0.2
        transmittance(i,j)=transmittance(i,j)+0.25;
        end
    end
end
% for i = 1:h
%     for j = 1:w
%        transmittance(i,j) = min(max(1,k/abs(double(img(i,j))-Atmos))*transmittance(i,j) ,0.7);        
%     end
% end

end

