function  path=Detection_region(origin)
%%��easy_Detection�����ϣ���ÿ���и��ͼƬ��һ�������Ͻ���������
%%ÿ���и��ͼƬ�������ҷֱ���չ��Ȼ���������ֱ��ͼͳ�ƣ��ҵ��߽�
I=origin;
I1=rgb2gray(I);
[h,w]=size(I1);
I2=im2bw(I1,0.3);
I3=imfill(I2,'hole');
se=strel('rectangle',[15 15]);
I4=imerode(I3,se);%ͼ��ղ��������ͼ��
I5=bwareaopen(I4,2000);%ȥ�����ŻҶ�ֵС��2000�Ĳ���
%subplot(235);imshow(I5);title('ȥ��һ���ֽ��');
[indexa,indexb]=his(I5);
[~,x]=size(indexa);
[~,y]= size(indexb);
flag=0;
tempb=50;
tempa=90;
path='region/';
mkdir('region/');
for i = 1:x-1%%ÿ���и��ͼƬ�������ҷֱ���չ��Ȼ���������ֱ��ͼͳ�ƣ��ҵ��߽磬ԭ��ͬeasy_Detection
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
