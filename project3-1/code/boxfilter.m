function imDst = boxfilter(imSrc, r)
%   计算窗口内数据之和
%   imSrc：待求积分数据
%   r：窗口半径

[h, w] = size(imSrc);
imDst = zeros(size(imSrc));

%y轴上的累计百分比
imCum = cumsum(imSrc, 1);
%x轴上的差异
imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
imDst(r+2:h-r, :) = imCum(2*r+2:h, :) - imCum(1:h-2*r-1, :);
imDst(h-r+1:h, :) = repmat(imCum(h, :), [r, 1]) - imCum(h-2*r:h-r-1, :);%重复数组
%x轴上的累计百分比
imCum = cumsum(imDst, 2);
%x轴上的差异
imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
imDst(:, r+2:w-r) = imCum(:, 2*r+2:w) - imCum(:, 1:w-2*r-1);
imDst(:, w-r+1:w) = repmat(imCum(:, w), [1, r]) - imCum(:, w-2*r:w-r-1);

end

