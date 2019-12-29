function path=Dec_commbine_region(origin)
%%用形态学操作中的连通区域操作获取牌照所在区域
img = origin;
%figure(1); imshow(img); title('origin image');
[height, width, channel] = size(img);
path='combine/';
%% 预处理
I = rgb2gray(img);
%figure(2); imshow(I); title('gray img');
I1 = im2bw(I);%二值化
%figure(3); imshow(I_B); title('PRE img');

I2 = imfill(I1,'hole');
%figure(4); imshow(I_full); title('holefull img');
SE = strel('arbitrary',eye(8));
% I_D = imdilate(I_full,SE); %膨胀
% figure(5); imshow(I_D); title('dilate img');
%SE = strel('arbitrary',eye(4));
I3 = imerode(I2,SE); %腐蚀
%figure(2); imshow(I3); title('eroded img');

%% 找到连接的域并计算每个质心，面积和边界
%如果面积在一定范围内，则从输入img中分割域
img_lb = logical(I3); 
ctl_lb = regionprops(img_lb, 'centroid');  % 每个连通域的中心所在位置
area_lb = regionprops(img_lb, 'area');    % 每个连通域的面积
[bdry_lb,L] = bwboundaries(img_lb);     %每个连通域的边界
%figure(3);imshow(L)%显示图像
%hold on
flag = 0;
mkdir('combine/');
for k = 1 : length(ctl_lb)
    boundary_k = bdry_lb{k};
    %num_bdpxl = size(boundary_k); %边的个数
    area_k = area_lb(k).Area; % 面积
    %%牌照所在区的长宽坐标，并往外扩大一点，这里用5
    license{k}(1, 1) = min(boundary_k(:,1))-5; 
    license{k}(1, 2) = max(boundary_k(:,1))+5;
    license{k}(2, 1) = min(boundary_k(:,2))-5; 
    license{k}(2, 2) = max(boundary_k(:,2))+5; 
    dif_width = license{k}(1, 2) - license{k}(1, 1);
    %dif_height = license{k}(2, 2) - license{k}(2, 1);
    
    %%观察预处理的图像处理分别处理连通区域
    if (area_k>25000 && area_k<110000)%区域中是两个的半个车牌
        if (dif_width>300)%太宽了需要处理
            %上半部分车牌
            midd = round((license{k}(1,1)+license{k}(1,2))/2);      
            clip_img = img(license{k}(1,1):midd, license{k}(2,1):license{k}(2,2), :);
            %subplot(6,6,flag); imshow(clip_img);
        
            flag = flag + 1;
            filename= ['combine/',num2str(flag, '%d'),'.jpg'];
            imwrite(clip_img,filename);
            % 下半部分车牌
            clip_img = img(midd:license{k}(1,2), license{k}(2,1):license{k}(2,2), :);
            %subplot(6,6,flag); imshow(clip_img);
            flag = flag + 1;
            filename= ['combine/',num2str(flag, '%d'),'.jpg'];
            imwrite(clip_img,filename);
        else
           %区域中是一个车牌
            clip_img = img(license{k}(1,1):license{k}(1,2), license{k}(2,1):license{k}(2,2), :);
            %subplot(6,6,flag); imshow(clip_img);
            flag = flag + 1;
            filename= ['combine/',num2str(flag, '%d'),'.jpg'];
            imwrite(clip_img,filename);
        end
    elseif (area_k>110000 && area_k<200000)%区域中可能有两个车牌重叠了    
        mid = round((license{k}(2,1)+license{k}(2,2))/2);
       %左边车牌
        clip_img = img(license{k}(1,1):license{k}(1,2), license{k}(2,1):mid, :);
        %subplot(6,6,flag); imshow(clip_img);
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
        % 右边车牌
        clip_img = img(license{k}(1,1):license{k}(1,2), mid:license{k}(2,2),:);
       % subplot(6,6,flag); imshow(clip_img);
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
    elseif (area_k>200000)%很多车牌重叠在一起，构成的连通区域个很大
        one_third = round((license{k}(2,2)+2*license{k}(2,1))/3);
        two_thirds = round((2*license{k}(2,2)+license{k}(2,1))/3);
        % 上边车牌
        clip_img = img(license{k}(1,1):license{k}(1,2), license{k}(2,1):one_third, :);
       % subplot(6,6,flag); imshow(clip_img); 
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
        % 中间车牌
        clip_img = img(license{k}(1,1):license{k}(1,2), one_third:two_thirds, :);
        %subplot(6,6,flag); imshow(clip_img);
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
        % 下边车牌
        clip_img = img(license{k}(1,1):license{k}(1,2), two_thirds:license{k}(2,2), :);
       % subplot(6,6,flag); imshow(clip_img);
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
        %plot(boundary_k(:,2), boundary_k(:,1), 'g', 'LineWidth', 2)
    end
    %img = img(tempindb(1):tempindb(2),tempinda(1):tempinda(2),:);
    
end
end