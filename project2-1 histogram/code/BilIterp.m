function result = BilIterp(img)
% interp - Bilinear interpolation
% img: input image
% result: output image
%%
% TO DO
%����û���κβ�������ֵ������Ҫ�õ�ֱ��ͼͳ�Ƶ����ݣ�
%�Ҳ�ֵ�Ƕ�ÿһ�����ص�������ֱ��ͼӳ��Ĳ�ֵ��
%���Բ�ֵȫ����CLAHE�����


% [h,w,c] = size(img);
% temp=0;
% for i =2:h
%     if img(i,1,1)~=0
%         temp = i;
%         break;
%     end
% end
% temp = temp-1;
% num1 = (h-1)/temp;
% num2 = (w-1)/temp;
% for i = 1:c
%     for j = 1:num1
%         for k = 1:num2
%             %��ֵ
%             for jj = 0:temp
%                 for kk = 0:temp
% %                     img(temp*(j-1)+1,temp*(k-1)+1,i)
% %                     img(temp*j+1,temp*(k-1)+1,i)
% %                     img(temp*j+1,temp*k+1,i)
% %                     img(temp*(j-1)+1,temp*k+1,i)
% %                     1-jj/temp
% %                     1-kk/temp
%                     img(temp*(j-1)+jj+1,temp*(k-1)+kk+1,i)=uint8((1-jj/temp)*(1-kk/temp)*img(temp*(j-1)+1,temp*(k-1)+1,i)+jj/temp*(1-kk/temp)*img(temp*j+1,temp*(k-1)+1,i)+kk/temp*(1-jj/temp)*img(temp*(j-1)+1,temp*k+1,i)+kk/temp*jj/temp*img(temp*j+1,temp*k+1,i));
%                 end
%             end
%             
%         end
%     end
% end
result = img;









% end of your code
end

