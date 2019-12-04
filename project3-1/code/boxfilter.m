function imDst = boxfilter(imSrc, r)
%   ���㴰��������֮��
%   imSrc�������������
%   r�����ڰ뾶

[h, w] = size(imSrc);
imDst = zeros(size(imSrc));

%y���ϵ��ۼưٷֱ�
imCum = cumsum(imSrc, 1);
%x���ϵĲ���
imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
imDst(r+2:h-r, :) = imCum(2*r+2:h, :) - imCum(1:h-2*r-1, :);
imDst(h-r+1:h, :) = repmat(imCum(h, :), [r, 1]) - imCum(h-2*r:h-r-1, :);%�ظ�����
%x���ϵ��ۼưٷֱ�
imCum = cumsum(imDst, 2);
%x���ϵĲ���
imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
imDst(:, r+2:w-r) = imCum(:, 2*r+2:w) - imCum(:, 1:w-2*r-1);
imDst(:, w-r+1:w) = repmat(imCum(:, w), [1, r]) - imCum(:, w-2*r:w-r-1);

end

