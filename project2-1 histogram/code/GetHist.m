function count=GetHist(img)
% GetHist - get the image histogram
% img:input image
% count:count the number of grayscale
%%
count = zeros(256,1);
% TO DO 
[Height,Width] = size(img);
for ii = (1:Height)
    for jj = (1:Width)
       count(img(ii,jj)+1) = count(img(ii,jj)+1)+1;    
    end
end
% END OF YOUR CODE 
end