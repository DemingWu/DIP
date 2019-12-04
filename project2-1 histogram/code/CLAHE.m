function result = CLAHE(img,W,T)
% CLAHE - Contrast Limited Adaptive histgram equalization
% img: input image
% W: window size W*W
% T: histogram threshold
% result: output image
%% clip
%%
% TO DO
[h,w,c] = size(img);
[h1,w1,c1] = size(img);
if W>h||W>w||W<0||T<0
    warning = warndlg('CLAHE需要合理参数','CLAHE_warning');
    return;
end
result = zeros(h,w,c);
%padding镜像填充
num1 = fix(h/W);
num2 = fix(w/W);
need = W-(h-num1*W);
img = [img;img(h-need+1:h,:,:)];
need = W-(w-num2*W);
img = [img,img(:,w-need+1:w,:)];
%padding end
num1 = num1+1;
num2 = num2+1;
[h,w,c] = size(img);
probability = zeros(256,num1*num2,3);
%统计全部直方图并找到映射关系
for i = 1:c
    for j = 1:num1
        for k = 1:num2
            probability(:,(j-1)*num2+k,i) = GetClipHist(img(W*(j-1)+1:W*j,W*(k-1)+1:W*k,i),T,W);
        end
    end
end
% END OF YOUR CODE
%% interpolation
% TO DO
temp = round(W/2);
% red area
for i = 1:c
    for j = 1:temp
        for k =1:temp
            %红色区域左上角
            result(j,k,i) = probability(img(j,k,i)+1,1,i);
            %红色区域右上角
            result(j,w-k+1,i) = probability(img(j,w-k+1,i)+1,num2,i);
            %红色区域左下角
            result(h-j+1,k,i) = probability(img(h-j+1,k,i)+1,num2*(num1-1)+1,i);
            %红色区域右下角
            result(h-j+1,w-k+1,i) = probability(img(h-j+1,w-k+1,i)+1,num2*num1,i);
        end
    end
end
%red end
%green area
%绿色区域上下横着区域
for i = 1:c
    for j = 1:temp
        for k = 1:num2-1
            for l = 0:temp
                %找到该像素点在相邻区域的映射值并双线性插值
                %上方
                result(j,(k-1)*W+temp+l+1,i) = (W-l)/W*probability(img(j,(k-1)*W+temp+l+1,i)+1,k,i)+l/W*probability(img(j,(k-1)*W+temp+l+1,i)+1,k+1,i);
                result(j,k*W+l,i) = (temp-l)/W*probability(img(j,k*W+l,i)+1,k,i)+(W-temp+l)/W*probability(img(j,k*W+l,i)+1,k+1,i);
                %下方
                result(h-j+1,(k-1)*W+temp+l+1,i) = (W-l)/W*probability(img(h-j+1,(k-1)*W+temp+l+1,i)+1,(num1-1)*num2+k,i)+l/W*probability(img(h-j+1,(k-1)*W+temp+l+1,i)+1,(num1-1)*num2+k+1,i);
                result(h-j+1,k*W+l,i) = (temp-l)/W*probability(img(h-j+1,k*W+l,i)+1,(num1-1)*num2+k,i)+(W-temp+l)/W*probability(img(h-j+1,k*W+l,i)+1,(num1-1)*num2+k+1,i);
            end
        end
    end
end
%竖着
for i = 1:c
    for k = 1:temp
        for j = 1:num1-1
            for l = 0:temp
                result((j-1)*W+temp+l+1,k,i) = (W-l)/W*probability(img((j-1)*W+temp+l+1,k,i)+1,num2*(j-1)+1,i)+l/W*probability(img((j-1)*W+temp+l+1,k,i)+1,num2*j+1,i);
                result(j*W+l,k,i) = (temp-l)/W*probability(img(j*W+l,k,i)+1,num2*(j-1)+1,i)+(W-temp+l)/W*probability(img(j*W+l,k,i)+1,num2*j+1,i);
                result((j-1)*W+temp+l+1,w-k+1,i) = (W-l)/W*probability(img((j-1)*W+temp+l+1,w-k+1,i)+1,num2*j,i)+l/W*probability(img((j-1)*W+temp+l+1,w-k+1,i)+1,num2*(j+1),i);
                result(j*W+l,w-k+1,i) = (temp-l)/W*probability(img(j*W+l,w-k+1,i)+1,num2*j,i)+(W-temp+l)/W*probability(img(j*W+l,w-k+1,i)+1,num2*(j+1),i);
            end
        end
    end
end
%green end
%blue area
for i = 1:c
    for j = 1:num1-1
        for k = 1:num2-1
            %相邻直方图的映射关系
            UL = probability(:,(j-1)*num2+k,i);
            UR = probability(:,(j-1)*num2+k+1,i);
            BL = probability(:,j*num2+k,i);
            BR = probability(:,j*num2+k+1,i);
            for jj = 0:W
                for kk = 0:W
                    %双线性插值得到新值并赋值
                    t = img(temp+(j-1)*W+jj+1,temp+(k-1)*W+kk+1,i)+1;
                    result(temp+(j-1)*W+jj+1,temp+(k-1)*W+kk+1,i) = (1-kk/W)*((1-jj/W)*UL(t)+jj/W*BL(t))+kk/W*(UR(t)*(1-jj/W)+jj/W*BR(t));
                end
                
            end
        end
    end
end
%ble end



result = uint8(result(1:h1,1:w1,:));
% END OF YOUR CODE
end

% You can write other functions here and comment them:
function probability=GetClipHist(img,T,W)
% GetClipHist - get the image histogram
% img:input image
% T:histogram threshold
%W :windows size
% count:count the number of grayscale
%%
count = zeros(256,1);
% TO DO
[Height,Width] = size(img);
sum = 0;
%统计直方图
for ii = (1:Height)
    for jj = (1:Width)
        count(img(ii,jj)+1) = count(img(ii,jj)+1)+1;
    end
end
%将大于阈值的数平分到各直方图上
recall = 0;
for i = 1:256
    if count(i)>T
        sum = sum+count(i)-T;
        count(i) = T;
    end
end
recall = sum-256*fix(sum/256);
sum = fix(sum/256);
for i = 1:256
    count(i) = count(i)+sum;
end

while sum~=0
    sum = recall;
    for i = 1:256
        if count(i)>T
            sum = sum+count(i)-T;
            count(i) = T;
        end
    end
    recall = sum-256*fix(sum/256)
    sum = fix(sum/256);
    for i = 1:256
        count(i) = count(i)+sum;
    end
end



probability = count/(W*W);
sum = 0;
%找到映射关系
for r =1:256
    sum = sum + probability(r,1);
    probability(r,1) = round(sum*255);
end
probability = uint8(probability);
% END OF YOUR CODE
end
