function [indexa,indexb ] = his( I5 )
a=sum(I5,1);%�����
b=sum(I5,2); %���������������
b=b.';
[~,x]=size(a);
[~,y]=size(b);
[~,indexa] = sort(a,'ascend');%���򲢼�¼λ��
for i = 2:x
    if abs(indexa(i-1)-indexa(i))<300
        indexa(i)=indexa(i-1);
    else
        flag = 0;
        for j=1:i-1
          if abs(indexa(j)-indexa(i))<300
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
for i = 2:y
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


end

