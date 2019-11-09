function result = AHE(img,W,S)
% AHE - Adaptive histgram equalization
% W : window size W*W
% S : stride
% result: output image
%% AHE
% TO DO
[h,w,c] = size(img);
if W>h||W>w||W<0||S>W||S<0
    warning = warndlg('AHE��Ҫ�������','AHE_warning');
    return;
end
result = uint8(zeros(h,w,c));
%���㳤�Ϳ��ж��ٸ�����W
num1 = fix(h/W);
num2 = fix(w/W);
%�����м��ж��ٸ�����
num3 = ceil((h-2*W)/S);
num4 = ceil((w-2*W)/S);
%�����м䲿����ʼ�������ֵ
temp = round((W+S)/2);
for i = 1:c
  %�����Ϸ����ŵĸ�����ӳ���ϵ��ӳ��ֵ��ͬHE
    for ii = 1:num2
        count = GetHist(img(1:W,((ii-1)*W+1):ii*W,i));
        probability = count/(W*W);
        sum = 0;
        for r =1:256
            sum = sum + probability(r,1);
            probability(r,1) = round(sum*255);
        end
        probability = uint8(probability);
        for j = 1:W
            for k = ((ii-1)*W+1):ii*W
                result(j,k,i) = probability(img(j,k,i)+1);
            
            end
        end
    end
    %�����Ϸ�����ʣ�ಿ��
    for iii = 1:1
        img1 = [img(1:W,num2*W+1:w,i),img(1:W,2*w-num2*W-W+1:w,i)];
        count = GetHist(img1);
        probability = count/(W*W);
        sum = 0;
        for r =1:256
            sum = sum + probability(r,1);
            probability(r,1) = round(sum*255);
        end
        probability = uint8(probability);
        for j = 1:W
            for k = num2*W+1:w
                result(j,k,i) = probability(img(j,k,i)+1);
            end
        end
    end
     %�����·����ŵĸ�����ӳ���ϵ��ӳ��ֵ��ͬHE
    for ii = 1:num2
        count = GetHist(img(h-W:h,(ii-1)*W+1:ii*W,i));
        probability = count/(W*W);
        sum = 0;
        for r =1:256
            sum = sum + probability(r,1);
            probability(r,1) = round(sum*255);
        end
        probability = uint8(probability);
        for j = h-W:h
            for k = (ii-1)*W+1:ii*W
                result(j,k,i) = probability(img(j,k,i)+1);
            end
        end
    end
     %�����·�����ʣ�ಿ��
    for iii = 1:1
        img1 = [img(h-W:h,num2*W+1:w,i),img(h-W:h,2*w-num2*W-W+1:w,i)];
        count = GetHist(img1);
        probability = count/(W*W);
        sum = 0;
        for r =1:256
            sum = sum + probability(r,1);
            probability(r,1) = round(sum*255);
        end
        probability = uint8(probability);
        for j = h-W:h
            for k = num2*W+1:w
                result(j,k,i) = probability(img(j,k,i)+1);
            end
        end
    end
   %���������ŵĸ�����ӳ���ϵ��ӳ��ֵ��ͬHE 
    for ii = 2:num1
        count = GetHist(img((ii-1)*W+1:ii*W,1:W,i));
        probability = count/(W*W);
        sum = 0;
        for r =1:256
            sum = sum + probability(r,1);
            probability(r,1) = round(sum*255);
        end
        probability = uint8(probability);
        for j = (ii-1)*W+1:ii*W
            for k = 1:W
                result(j,k,i) = probability(img(j,k,i)+1);
            end
        end
    end
    %����������ʣ�ಿ��
     for iii = 1:1
%         count = GetHist(img(num1*W+1:h-W,1:W,i));
%         probability = count/(W*W);
%         sum = 0;
%         for r =1:256
%             sum = sum + probability(r,1);
%             probability(r,1) = round(sum*255);
%         end
%         probability = uint8(probability);
%         for j = num2*W+1:w-W
%             for k = 1:W
%                 result(j,k,i) = probability(img(j,k,i)+1);
%             end
%         end
     end
     %�����ҷ����ŵĸ�����ӳ���ϵ��ӳ��ֵ��ͬHE
    for ii = 2:num1
        count = GetHist(img((ii-1)*W+1:ii*W,w-W:w,i));
        probability = count/(W*W);
        sum = 0;
        for r =1:256
            sum = sum + probability(r,1);
            probability(r,1) = round(sum*255);
        end
        probability = uint8(probability);
        for j = (ii-1)*W+1:ii*W
            for k = w-W:w
                result(j,k,i) = probability(img(j,k,i)+1);
            end
        end
    end
    %�����ҷ�����ʣ�ಿ��
     for iii = 1:1
%         count = GetHist(img(num1*W+1:(num1+1)*W,w-W:w,i));
%         probability = count/(W*W);
%         sum = 0;
%         for r =1:256
%             sum = sum + probability(r,1);
%             probability(r,1) = round(sum*255);
%         end
%         probability = uint8(probability);
%         for j = num2*W+1:h-W
%             for k = w-W:w
%                 result(j,k,i) = probability(img(j,k,i)+1);
%             end
%         end
     end 
     %�����м䲿�֣����ڴ�СΪW������Ϊs�����������ӳ���ϵ��ӳ��ֵ��ͬHE
    for ii = 0:num3-1
        for jj =0:num4-1
            count = GetHist(img(temp+ii*S:temp+ii*S+W,temp+jj*S:temp+jj*S+W,i));           
            probability = count/(W*W);
            sum = 0;
            for r =1:256
                sum = sum + probability(r,1);
                probability(r,1) = round(sum*255);
            end
            probability = uint8(probability);
            for j = 1:S
                for k = 1:S
                    result(W+j+S*ii,W+k+S*jj,i) = probability(img(W+j+S*ii,W+k+S*jj,i)+1);               
                end
            end
          
        end
    end
end
% END OF YOUR CODE
end

