function Recognition(filename,temppath,method)
%%车牌分割并识别
%%一系列形态学操作，为了使车牌上的数字能够成为一个连通区域，好为了识别出车牌所在位置
I = imread(filename);
num=length(filename);
filename=filename(1:num-4);
mkdir([filename,'/']);
i=Segmentation( I,method );
i1=rgb2gray(i);
%t=graythresh(i1);
i2=im2bw(i1,0.4);
% [~,w]=size(i2);
% i2=[i2;zeros(16,w)];
%i3=medfilt2(i2);
SE=strel('rectangle',[3,3]);
i4=imdilate(i2,SE);
i5=imerode(i2,SE);
i6=imsubtract(i4,i5);
i7=imclearborder(i6);
i8=imfill(i7,'holes');
i9=bwareaopen(i8,1000);
i10=bwmorph(i9,'thin');
%i11=imerode(i10,SE);
%i11=bwareaopen(i10,800);%去除聚团灰度值小于2000的部分
% figure;
%imshow(i5);
st = regionprops(i10, 'BoundingBox');
%SubBw2=zeros(20,40);
error2=zeros(1,36);
error3=zeros(1,36);
liccode=char(['0':'9' 'A':'Z']); %建立自动识别字符代码表
%mkdir(strcat(filename,));
for k = 1 : length(st)
    rename=[filename,'/'];    
    %segname=strcat(filename,'/Segmentation/');
    BB = st(k).BoundingBox;
    if 20<BB(3)&&BB(3)<80&& 80<BB(4)&&BB(4)<160%防止框出来的车牌数字太小或者太大
        %rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor','g','LineWidth',2 );%画出来框的
        SegBw1=i5(BB(2):(BB(2)+BB(4)),(BB(1)):(BB(1)+BB(3)));  %截取数字图像所在区域   
        SegBw2 = imresize(SegBw1,[40,20]);%变换为40行*20列标准子图
        for k2=1:36
            fname=[temppath,'字符模板',liccode(k2),'.jpg'];
            
            SamBw2 = imread(fname);
            SamBw2 =SamBw2(:,:,1);
            %SamBw2=rgb2gray(SamBw2);
            SamBw2=im2bw(SamBw2);
            % SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
            SubBw2 = SamBw2-SegBw2;%为了比较字符与哪个模板匹配
            SubBw3 = ~SamBw2-SegBw2;%分别与白底黑字和黑底白字的模板匹配
%             D2max=0;
%             D3max=0;
            D2max=length(find(SubBw2 ==0));
            D3max=length(find(SubBw3 ==0));%等于0说明匹配
%             for k1=1:40%bi'jiao
%                 for l1=1:20                 
%                     if ( SubBw2(k1,l1) ==0 )
%                         D2max=D2max+1;
%                     end
%                     if ( SubBw3(k1,l1) ==0 )
%                         D3max=D3max+1;
%                     end
%                 end
%             end
            error2(k2)=D2max;
            error3(k2)=D3max;
        end
        minerror2=max(error2);%查找最小误差的图像
        minerror3=max(error3);
        if minerror3>minerror2
            findstation=find(error3==minerror3);%查找最小误差的图像位置
            rename=strcat(rename,liccode(findstation(1)),'.jpg');
        else
            findstation=find(error2==minerror2);%查找最小误差的图像
            rename=strcat(rename,liccode(findstation(1)),'.jpg');%保存路径
        end
        imwrite(SegBw1,rename);
        
    end
end
end



