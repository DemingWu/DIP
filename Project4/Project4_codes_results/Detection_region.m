function  path=Detection_region(origin)
%%在easy_Detection基础上，对每次切割的图片在一定基础上进行区域处理，
%%每次切割的图片上下左右分别扩展，然后进行区域直方图统计，找到边界
I=origin;
I1=rgb2gray(I);
[h,w]=size(I1);
I2=im2bw(I1,0.3);
I3=imfill(I2,'hole');
se=strel('rectangle',[15 15]);
I4=imerode(I3,se);%图像闭操作，填充图像
I5=bwareaopen(I4,2000);%去除聚团灰度值小于2000的部分
%subplot(235);imshow(I5);title('去除一部分结果');
[indexa,indexb]=his(I5);
[~,x]=size(indexa);
[~,y]= size(indexb);
flag=0;
tempb=50;
tempa=90;
path='region/';
mkdir('region/');
for i = 1:x-1%%每次切割的图片上下左右分别扩展，然后进行区域直方图统计，找到边界，原理同easy_Detection
    if indexa(i)<tempb
        tempstart=indexa(i);
        tempend=indexa(i+1)+tempb;
    elseif indexa(i+1)+tempb>w
        tempstart=indexa(i)-tempb;
        tempend=w;
    else
        tempstart=indexa(i)-tempb;
        tempend=indexa(i+1)+tempb;
    end
    for j= 1:y-1
        flag = flag+1;
        filename= ['region/',num2str(flag, '%d'),'.jpg'];
        %img = I(indexb(j):indexb(j+1),indexa(i):indexa(i+1),:);
        if indexb(j)<tempa
            img2 = I5(indexb(j):indexb(j+1)+tempa,tempstart:tempend);
            img = I(indexb(j):indexb(j+1)+tempa,tempstart:tempend,:);
        elseif indexb(j+1)+tempa>h
            img2 = I5(indexb(j)-tempa:h,tempstart:tempend);
            img = I(indexb(j)-tempa:h,tempstart:tempend,:);
        else
            img2 = I5(indexb(j)-tempa:indexb(j+1)+tempa,tempstart:tempend);
            img = I(indexb(j)-tempa:indexb(j+1)+tempa,tempstart:tempend,:);
        end
        [tempinda,tempindb]=his(img2);
        [~,a]=size(tempinda);
        [~,b]=size(tempindb);
        img = img(tempindb(1):tempindb(2),tempinda(1):tempinda(2),:);
        imwrite(img,filename);
    end
end
end
