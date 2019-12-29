function path=Dec_commbine_region(origin)
%%����̬ѧ�����е���ͨ���������ȡ������������
img = origin;
%figure(1); imshow(img); title('origin image');
[height, width, channel] = size(img);
path='combine/';
%% Ԥ����
I = rgb2gray(img);
%figure(2); imshow(I); title('gray img');
I1 = im2bw(I);%��ֵ��
%figure(3); imshow(I_B); title('PRE img');

I2 = imfill(I1,'hole');
%figure(4); imshow(I_full); title('holefull img');
SE = strel('arbitrary',eye(8));
% I_D = imdilate(I_full,SE); %����
% figure(5); imshow(I_D); title('dilate img');
%SE = strel('arbitrary',eye(4));
I3 = imerode(I2,SE); %��ʴ
%figure(2); imshow(I3); title('eroded img');

%% �ҵ����ӵ��򲢼���ÿ�����ģ�����ͱ߽�
%��������һ����Χ�ڣ��������img�зָ���
img_lb = logical(I3); 
ctl_lb = regionprops(img_lb, 'centroid');  % ÿ����ͨ�����������λ��
area_lb = regionprops(img_lb, 'area');    % ÿ����ͨ������
[bdry_lb,L] = bwboundaries(img_lb);     %ÿ����ͨ��ı߽�
%figure(3);imshow(L)%��ʾͼ��
%hold on
flag = 0;
mkdir('combine/');
for k = 1 : length(ctl_lb)
    boundary_k = bdry_lb{k};
    %num_bdpxl = size(boundary_k); %�ߵĸ���
    area_k = area_lb(k).Area; % ���
    %%�����������ĳ������꣬����������һ�㣬������5
    license{k}(1, 1) = min(boundary_k(:,1))-5; 
    license{k}(1, 2) = max(boundary_k(:,1))+5;
    license{k}(2, 1) = min(boundary_k(:,2))-5; 
    license{k}(2, 2) = max(boundary_k(:,2))+5; 
    dif_width = license{k}(1, 2) - license{k}(1, 1);
    %dif_height = license{k}(2, 2) - license{k}(2, 1);
    
    %%�۲�Ԥ�����ͼ����ֱ�����ͨ����
    if (area_k>25000 && area_k<110000)%�������������İ������
        if (dif_width>300)%̫������Ҫ����
            %�ϰ벿�ֳ���
            midd = round((license{k}(1,1)+license{k}(1,2))/2);      
            clip_img = img(license{k}(1,1):midd, license{k}(2,1):license{k}(2,2), :);
            %subplot(6,6,flag); imshow(clip_img);
        
            flag = flag + 1;
            filename= ['combine/',num2str(flag, '%d'),'.jpg'];
            imwrite(clip_img,filename);
            % �°벿�ֳ���
            clip_img = img(midd:license{k}(1,2), license{k}(2,1):license{k}(2,2), :);
            %subplot(6,6,flag); imshow(clip_img);
            flag = flag + 1;
            filename= ['combine/',num2str(flag, '%d'),'.jpg'];
            imwrite(clip_img,filename);
        else
           %��������һ������
            clip_img = img(license{k}(1,1):license{k}(1,2), license{k}(2,1):license{k}(2,2), :);
            %subplot(6,6,flag); imshow(clip_img);
            flag = flag + 1;
            filename= ['combine/',num2str(flag, '%d'),'.jpg'];
            imwrite(clip_img,filename);
        end
    elseif (area_k>110000 && area_k<200000)%�����п��������������ص���    
        mid = round((license{k}(2,1)+license{k}(2,2))/2);
       %��߳���
        clip_img = img(license{k}(1,1):license{k}(1,2), license{k}(2,1):mid, :);
        %subplot(6,6,flag); imshow(clip_img);
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
        % �ұ߳���
        clip_img = img(license{k}(1,1):license{k}(1,2), mid:license{k}(2,2),:);
       % subplot(6,6,flag); imshow(clip_img);
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
    elseif (area_k>200000)%�ܶ೵���ص���һ�𣬹��ɵ���ͨ������ܴ�
        one_third = round((license{k}(2,2)+2*license{k}(2,1))/3);
        two_thirds = round((2*license{k}(2,2)+license{k}(2,1))/3);
        % �ϱ߳���
        clip_img = img(license{k}(1,1):license{k}(1,2), license{k}(2,1):one_third, :);
       % subplot(6,6,flag); imshow(clip_img); 
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
        % �м䳵��
        clip_img = img(license{k}(1,1):license{k}(1,2), one_third:two_thirds, :);
        %subplot(6,6,flag); imshow(clip_img);
        flag = flag + 1;
        filename= ['combine/',num2str(flag, '%d'),'.jpg'];
        imwrite(clip_img,filename);
        % �±߳���
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