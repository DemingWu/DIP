function result = HE(img)
% HE - histogram equalization
% img: input image
% result: output image
%%
% TO DO 
[h,w,c] = size(img);
result = uint8(zeros(h,w,c));
for i = 1:c
    %统计直方图
    count = GetHist(img(:,:,i));
    %计算每个频率的概率分布
    probability = count/(h*w);
    sum = 0;
    for r =1:256
        %得到每一个像素值图像的累计函数分布并计算该像素值所对应的改变之后的值，及找到映射关系
        sum = sum + probability(r,1);        
        probability(r,1) = round(sum*255);
    end
    probability = uint8(probability);
    for j = 1:h
        for k =1:w
            %根据映射关系找到映射值
           result(j,k,i) = probability(img(j,k,i)+1); 
        end
    end   
end

% END OF YOUR CODE 
end
