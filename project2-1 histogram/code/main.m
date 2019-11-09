close all;clc;clear;
%% read
origin = imread('astronaut.jpg');
subplot(221);imshow(origin);title('origin');

%% histogram equalization
% TO DO
img_1 = HE(origin);
% END OF YOUR CODE
subplot(222);imshow(img_1);title('HE');

%% Adaptive histgram equalization
% TO DO
img_2 = AHE(origin,64,32);
% END OF YOUR CODE
subplot(223);imshow(img_2);title('AHE');

%% Contrast Limited Adaptive histgram equalization
% TO DO
img_3 = CLAHE(origin,64,400);
% END OF YOUR CODE
subplot(224);imshow(img_3);title('CLAHE');
%saveas(gcf,'result_1','jpg');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % %  rock.jpg  % % % % % % % % % % % % % % % % % % %
% %% read
origin1 = imread('rock.jpg');
figure;subplot(221);imshow(origin1);title('origin');

%% histogram equalization
% TO DO
img_1_1 = HE(origin1);
% END OF YOUR CODE
subplot(222);imshow(img_1_1);title('HE');

%% Adaptive histgram equalization
% TO DO
img_2_1 = AHE(origin1,64,32);
% END OF YOUR CODE
subplot(223);imshow(img_2_1);title('AHE');

%% Contrast Limited Adaptive histgram equalization
% TO DO
img_3_1 = CLAHE(origin1,64,400);
% END OF YOUR CODE
subplot(224);imshow(img_3_1);title('CLAHE');
%saveas(gcf,'result_2','jpg');



%RGB to HSI
% figure; subplot(221);imshow(origin);title('origin');
% [h,w,c] = size(origin);
% origin = double (origin);
figure; subplot(221);imshow(origin1);title('origin');
[h,w,c] = size(origin1);
origin = double (origin1);
H = zeros(h,w);
S = zeros(h,w);
I = zeros(h,w);
for j = 1:h
    for k = 1:w
        %计算H
        value = 1/2*( (origin(j,k,1)-origin(j,k,2)) +(origin(j,k,1)-origin(j,k,3)) )/ ((origin(j,k,1)-origin(j,k,2))^2+(origin(j,k,1)-origin(j,k,3))*(origin(j,k,2)-origin(j,k,3)))^(1/2);
        theta = acosd(value);
        if origin(j,k,2)>=origin(j,k,3)
            H(j,k) = theta;
        else
            H(j,k) = 360-theta;
        end
        %计算S和I
        S(j,k) = 1- 3/(origin(j,k,2)+origin(j,k,3)+origin(j,k,1))*min(origin(j,k,:));
        I(j,k) = (origin(j,k,2)+origin(j,k,3)+origin(j,k,1))/3;
    end
end
%两种特殊情况设置
for j = 1:h
    for k = 1:w
        if S(j,k)==0
            H(j,k) = 0;
        end
        if I(j,k) == 0
            S(j,k) = 0;
            H(j,k) = 0;
        end
    end
end
I = uint8(I);

%三种不同的直方图处理方法
img_I(:,:,1) = HE(I);
img_I(:,:,2) = AHE(I,64,32);
img_I(:,:,3) = CLAHE(I,64,400);
image_hsi = zeros(h,w,c);
for ii = 1:3
%     I= double (I);
    I = double(img_I(:,:,ii));
    for i = 1:h
        for j = 1:w
            %对不同角度分情况处理，将hsi模型转换成rgb模型
            if H(i,j)<120
                image_hsi(i,j,3) = I(i,j)*(1-S(i,j));
                image_hsi(i,j,1) = I(i,j)*(1+S(i,j)*cosd(H(i,j))/cosd(60-H(i,j)));
                image_hsi(i,j,2) = 3*I(i,j)-(image_hsi(i,j,3)+image_hsi(i,j,1));
            elseif H(i,j)>=120&&H(i,j)<240
                image_hsi(i,j,1) = I(i,j)*(1-S(i,j));
                image_hsi(i,j,2) = I(i,j)*(1+S(i,j)*cosd(H(i,j)-120)/cosd(180-H(i,j)));
                image_hsi(i,j,3) = 3*I(i,j)-(image_hsi(i,j,2)+image_hsi(i,j,1));
            else
                image_hsi(i,j,2) = I(i,j)*(1-S(i,j));
                image_hsi(i,j,3) = I(i,j)*(1+S(i,j)*cosd(H(i,j)-240)/cosd(300-H(i,j)));
                image_hsi(i,j,1) = 3*I(i,j)-(image_hsi(i,j,2)+image_hsi(i,j,3));
            end
        end
    end
    %展示处理后的图片
    image_hsi = uint8(image_hsi);
    if ii == 1
        subplot(222);imshow(image_hsi);title('HE');
    elseif ii == 2
        subplot(223);imshow(image_hsi);title('AHE');
    elseif ii == 3
        subplot(224);imshow(image_hsi);title('CLAHE');
    end
    
end
%saveas(gcf,'result_4','jpg');






