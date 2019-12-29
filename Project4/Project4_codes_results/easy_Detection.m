function easy_Detection(origin)
%%进行简单的照片分割；横竖切割；
%%利用横竖投影统计区分车牌边界
I=origin;
I1=rgb2gray(I);
%I2=edge(I1,'roberts',0.18,'both');
I2=im2bw(I1,0.05);%二值化
gausFilter = fspecial('gaussian',[10 10],1.6);      %matlab 自带高斯模板滤波
I2=imfilter(I2,gausFilter,'conv');
I3=imfill(I2,'hole');%空洞填充

se=strel('rectangle',[15,15]);%操作元
I4=imerode(I3,se);%图像闭操作，填充图像
%I4=imclose(I4,se);%图像闭操作，填充图像
I5=bwareaopen(I4,3000);%去除聚团灰度值小于2000的部分

% subplot(231);imshow(I1);title('灰度图');
% subplot(232);imshow(I2);title('二值化');
% subplot(233);imshow(I3);title('孔洞填充');
% subplot(234);imshow(I4);title('闭操作');
% subplot(235);imshow(I5);title('去除一部分结果');

a=sum(I5,1);%列求和
% figure;
%  x=1:2923;
% %绘制散点图
% plot(x,a,'.');
%  
% % % 增加坐标说明和图像标题
% xlabel('station');ylabel('nums');title('histogram');
b=sum(I5,2); %对整个矩阵按行求和
b=b.';
% figure;
%  x=1:1729;
% %绘制散点图
% plot(x,b,'.');
% %增加坐标说明和图像标题
% xlabel('station');ylabel('nums');title('histogram');
[~,x]=size(a);
[~,y]=size(b);
[~,indexa] = sort(a,'ascend');%排序并记录位置
for i = 2:x%找到横最小值，并保证最小值之间的位置差距在一定范围内，这里用350
    if abs(indexa(i-1)-indexa(i))<350
        indexa(i)=indexa(i-1);
    else
        flag = 0;
        for j=1:i-1
          if abs(indexa(j)-indexa(i))<350
              flag = flag+1;
          end           
        end 
        if flag >= 1;
            indexa(i)=indexa(i-1); 
        end
    end
end
indexa=unique(indexa);

[~,indexb] = sort(b,'ascend');%排序并记录位置
for i = 2:y%找到竖最小值，并保证最小值之间的位置差距在一定范围内，这里用350
    if abs(indexb(i-1)-indexb(i))<200
        indexb(i)=indexb(i-1);
    else
        flag = 0;
        for j=1:i-1
          if abs(indexb(j)-indexb(i))<200
              flag = flag+1;
          end           
        end 
        if flag >= 1;
            indexb(i)=indexb(i-1); 
        end
    end
end
indexb=unique(indexb);
[~,x]=size(indexa);%横竖方向的最小值所在位置
[~,y]= size(indexb);
flag=0;
mkdir('easy_dec/');
for i = 1:x-1%%横竖切割
    for j= 1:y-1
        flag = flag+1;
        filename= ['easy_dec/',num2str(flag, '%d'),'.jpg'];
        img = I(indexb(j):indexb(j+1),indexa(i):indexa(i+1),:);
        imwrite(img,filename);        
    end
end
end