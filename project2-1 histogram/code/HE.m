function result = HE(img)
% HE - histogram equalization
% img: input image
% result: output image
%%
% TO DO 
[h,w,c] = size(img);
result = uint8(zeros(h,w,c));
for i = 1:c
    %ͳ��ֱ��ͼ
    count = GetHist(img(:,:,i));
    %����ÿ��Ƶ�ʵĸ��ʷֲ�
    probability = count/(h*w);
    sum = 0;
    for r =1:256
        %�õ�ÿһ������ֵͼ����ۼƺ����ֲ������������ֵ����Ӧ�ĸı�֮���ֵ�����ҵ�ӳ���ϵ
        sum = sum + probability(r,1);        
        probability(r,1) = round(sum*255);
    end
    probability = uint8(probability);
    for j = 1:h
        for k =1:w
            %����ӳ���ϵ�ҵ�ӳ��ֵ
           result(j,k,i) = probability(img(j,k,i)+1); 
        end
    end   
end

% END OF YOUR CODE 
end
