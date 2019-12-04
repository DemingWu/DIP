function transmittance_guide = guidedfilter(img, transmittance, r, eps)
%   引导滤波，将透射率平滑，用最小二乘法解决参数
%    img ：guilder 图，选min_img
%    transmittance ：待filter的透射率
%    r：窗口半径
%    eps：正则化参数

[h, w] = size(img);
N = boxfilter(ones(h, w), r); % 计算每个窗口中数据的个数，用全是1的数组代替，边缘窗口数据会少

mean_img = boxfilter(img, r) ./ N;%计算图像每个窗口均值
mean_transmittance = boxfilter(transmittance, r) ./ N;%计算透射率每个窗口均值
mean_it = boxfilter(img.*transmittance, r) ./ N;%计算直接衰减值的每个窗口均值，直接衰减值=I*t
cov_it = mean_it - mean_img .* mean_transmittance; % 每个窗口的直接衰减值的协方差

mean_img_b = boxfilter(img.*img, r) ./ N;%计算图像数据平方每个窗口均值
var_img = mean_img_b - mean_img .* mean_img;%计算每个窗口方差
%线性模拟参数估计
a = cov_it ./ (var_img + eps); % 估算a值
b = mean_transmittance - a .* mean_img; % 估计b值
mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

transmittance_guide = mean_a .* img + mean_b; % Eqn. (8) in the paper;
end