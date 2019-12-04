function  transmittance  = avoidSky( img , Atmos, transmittance)
%±ÜÃâÌì¿Õ¹ıÆØµÄ³¢ÊÔ
[h,w] = size(img);
k=35;
for i = 1:h
    for j = 1:w
       transmittance(i,j) = min(max(1,k/abs(double(img(i,j))-Atmos))*transmittance(i,j) ,0.7);        
    end
end

end

