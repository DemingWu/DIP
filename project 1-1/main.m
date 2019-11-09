clc;
close all;
clear all;

%load US data & read CT data 
US = load('data/US.mat');
USdata = US.US;
CT = imread('data/27.jpg');
clear US;


% select four feature point by hand
%  imshow(USdata,[]);
%  USselect=ginput(4);
%  imshow(CT,[]);
%  CTselect=ginput(4);
%  USselect(:,[1,2])=USselect(:,[2,1]);
%  CTselect(:,[1,2])=CTselect(:,[2,1]);
%  USpoint=CTselect;
%  CTpoint=CTselect;
 %save('data/points.mat','USpoint','CTpoint');

%load  the same feature point of US&CT data if there are exiting
  load('data/points.mat');

%calculate the transformation  matrix from 4  different point, because
%there are  eight unknown parameter
%USpoint=Transformation*CTpoint 
%from tag begin to tag end

CTpoint1(:,:) = CTpoint(:,:);



%1、tag begin   US TO CT
USpoint = USpoint';  %set USpoint fitting the matrix calculation 
%set the CTpoint matrix
CTpoint = [CTpoint(1,1) CTpoint(2,1) CTpoint(3,1) CTpoint(4,1);
           CTpoint(1,2) CTpoint(2,2) CTpoint(3,2) CTpoint(4,2);
           CTpoint(1,1)* CTpoint(1,2) CTpoint(2,1)* CTpoint(2,2) CTpoint(3,1)* CTpoint(3,2) CTpoint(4,1)* CTpoint(4,2);
           1 1 1 1];     
Transformation = USpoint/(CTpoint);   %calculate the transformation matrix    
%1、tag end

%set registration image array
registration= zeros(627,1052);
registration_ct2us=zeros(800,640);

%calculate the location from US to CT
%and assign the value 
for i = 1:627
    for j = 1:1052
        m = Transformation(1,1)*i+Transformation(1,2)*j+Transformation(1,3)*i*j+Transformation(1,4);
        n = Transformation(2,1)*i+Transformation(2,2)*j+Transformation(2,3)*i*j+Transformation(2,4);
        m = round(m);                                                                
        n = round(n);
        % m & n can`t be over the border 
        if( m>=1 && m<=480 && n>=1 && n<=640 ) 
             registration(i,j) = USdata(m,n);
%              registration_ct2us(m,n)=CT(i,j);
        end
        if( m>=1 && m<=800 && n>=1 && n<=640 ) 
%              registration(i,j) = USdata(m,n);
             registration_ct2us(m,n)=CT(i,j);
        end
        registration(i,j) = 0.7*registration(i,j) + 0.3*CT(i,j); 
        
    end
end
 imshow(registration,[]);
 hold on;

% %ct to us
% for i = 1:480
%      for j = 1:640
%         registration_ct2us(i,j)=0.7*registration_ct2us(i,j)+USdata(i,j); 
%      end
% end
% imshow(registration_ct2us,[]);
%  hold on;




%2、tag begin CTpoint=Transformation*USpoint  US TO CT
registration(:,:)=CT(:,:,1);
registration_ct2us2=zeros(800,640);
% imshow(registration,[]);
% hold on;
USpoint = USpoint';  %set USpoint fitting the matrix calculation 
USpoint = [USpoint(1,1) USpoint(2,1) USpoint(3,1) USpoint(4,1);
           USpoint(1,2) USpoint(2,2) USpoint(3,2) USpoint(4,2);
           USpoint(1,1)* USpoint(1,2) USpoint(2,1)* USpoint(2,2) USpoint(3,1)* USpoint(3,2) USpoint(4,1)* USpoint(4,2);
           1 1 1 1];   
Transformation = CTpoint1'/(USpoint);   %calculate the transformation matrix    
%2、tag end

% %ct to us forward
% for i = 1:480
%     for j = 1:640
%         if USdata(i,j)>10
%          m = Transformation(1,1)*i+Transformation(1,2)*j+Transformation(1,3)*i*j+Transformation(1,4);
%          n = Transformation(2,1)*i+Transformation(2,2)*j+Transformation(2,3)*i*j+Transformation(2,4);
%          m = round(m);                                                                
%          n = round(n);
%         % m & n can`t be over the border 
%          if( m>=1 && m<=627 && n>=1 && n<=1052 ) 
%              registration(m,n) = 3*USdata(i,j); 
%          end
%         end
%     end
% end
% imshow(registration,[]);
%  hold on;



%ct to us back
% for i = 1:800
%     for j = 1:640
%          m = Transformation(1,1)*i+Transformation(1,2)*j+Transformation(1,3)*i*j+Transformation(1,4);
%          n = Transformation(2,1)*i+Transformation(2,2)*j+Transformation(2,3)*i*j+Transformation(2,4);
%          m = round(m);                                                                
%          n = round(n);
%        % m & n can`t be over the border 
%          if( m>=1 && m<=627 && n>=1 && n<=1052 ) 
%              registration_ct2us2(i,j) = CT(m,n); 
%          end
%         end
% end
% % imshow(registration_ct2us2,[]);
% %  hold on;
% for i = 1:480
%      for j = 1:640
%         registration_ct2us2(i,j)=0.5*registration_ct2us2(i,j)+0.5*USdata(i,j); 
%      end
% end
% imshow(registration_ct2us2,[]);
%  hold on;




%互信息计算
b=CT(:,:,1);
[Ma,Na] = size(registration);
[Mb,Nb] = size(b);
M=min(Ma,Mb);
N=min(Na,Nb);
%初始化直方图数组
hab = zeros(256,256);
ha = zeros(1,256);
hb = zeros(1,256);
%归一化
imax = max(max(registration));
imin = min(min(registration));
if imax ~= imin
registration = double((registration-imin))/double((imax-imin));
else
registration = zeros(M,N);
end
imax = max(max(b));
imin = min(min(b));
if imax ~= imin
b = double(b-imin)/double((imax-imin));
else
b = zeros(M,N);
end
registration = int16(registration*255)+1;
b = int16(b*255)+1;


%统计直方图
for i=1:M
for j=1:N
indexx = registration(i,j);
indexy = b(i,j) ;
hab(indexx,indexy) = hab(indexx,indexy)+1;%联合直方图
ha(indexx) = ha(indexx)+1;%a图直方图
hb(indexy) = hb(indexy)+1;%b图直方图
end
end
%计算联合信息熵
hsum = sum(sum(hab));
index = find(hab~=0);
p = hab/hsum;
Hab = sum(-p(index).*log(p(index)));
%计算a图信息熵
hsum = sum(sum(ha));
index = find(ha~=0);
p = ha/hsum;
Ha = sum(-p(index).*log(p(index)));
%计算b图信息熵
hsum = sum(sum(hb));
index = find(hb~=0);
p = hb/hsum;
Hb = sum(-p(index).*log(p(index)));
%计算a和b的互信息（越大匹配结果越好）
mi = Ha+Hb-Hab;



