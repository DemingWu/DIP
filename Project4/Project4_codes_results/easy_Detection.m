function easy_Detection(origin)
%%���м򵥵���Ƭ�ָ�����и
%%���ú���ͶӰͳ�����ֳ��Ʊ߽�
I=origin;
I1=rgb2gray(I);
%I2=edge(I1,'roberts',0.18,'both');
I2=im2bw(I1,0.05);%��ֵ��
gausFilter = fspecial('gaussian',[10 10],1.6);      %matlab �Դ���˹ģ���˲�
I2=imfilter(I2,gausFilter,'conv');
I3=imfill(I2,'hole');%�ն����

se=strel('rectangle',[15,15]);%����Ԫ
I4=imerode(I3,se);%ͼ��ղ��������ͼ��
%I4=imclose(I4,se);%ͼ��ղ��������ͼ��
I5=bwareaopen(I4,3000);%ȥ�����ŻҶ�ֵС��2000�Ĳ���

% subplot(231);imshow(I1);title('�Ҷ�ͼ');
% subplot(232);imshow(I2);title('��ֵ��');
% subplot(233);imshow(I3);title('�׶����');
% subplot(234);imshow(I4);title('�ղ���');
% subplot(235);imshow(I5);title('ȥ��һ���ֽ��');

a=sum(I5,1);%�����
% figure;
%  x=1:2923;
% %����ɢ��ͼ
% plot(x,a,'.');
%  
% % % ��������˵����ͼ�����
% xlabel('station');ylabel('nums');title('histogram');
b=sum(I5,2); %���������������
b=b.';
% figure;
%  x=1:1729;
% %����ɢ��ͼ
% plot(x,b,'.');
% %��������˵����ͼ�����
% xlabel('station');ylabel('nums');title('histogram');
[~,x]=size(a);
[~,y]=size(b);
[~,indexa] = sort(a,'ascend');%���򲢼�¼λ��
for i = 2:x%�ҵ�����Сֵ������֤��Сֵ֮���λ�ò����һ����Χ�ڣ�������350
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

[~,indexb] = sort(b,'ascend');%���򲢼�¼λ��
for i = 2:y%�ҵ�����Сֵ������֤��Сֵ֮���λ�ò����һ����Χ�ڣ�������350
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
[~,x]=size(indexa);%�����������Сֵ����λ��
[~,y]= size(indexb);
flag=0;
mkdir('easy_dec/');
for i = 1:x-1%%�����и�
    for j= 1:y-1
        flag = flag+1;
        filename= ['easy_dec/',num2str(flag, '%d'),'.jpg'];
        img = I(indexb(j):indexb(j+1),indexa(i):indexa(i+1),:);
        imwrite(img,filename);        
    end
end
end