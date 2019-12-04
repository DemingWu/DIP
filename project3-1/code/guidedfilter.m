function transmittance_guide = guidedfilter(img, transmittance, r, eps)
%   �����˲�����͸����ƽ��������С���˷��������
%    img ��guilder ͼ��ѡmin_img
%    transmittance ����filter��͸����
%    r�����ڰ뾶
%    eps�����򻯲���

[h, w] = size(img);
N = boxfilter(ones(h, w), r); % ����ÿ�����������ݵĸ�������ȫ��1��������棬��Ե�������ݻ���

mean_img = boxfilter(img, r) ./ N;%����ͼ��ÿ�����ھ�ֵ
mean_transmittance = boxfilter(transmittance, r) ./ N;%����͸����ÿ�����ھ�ֵ
mean_it = boxfilter(img.*transmittance, r) ./ N;%����ֱ��˥��ֵ��ÿ�����ھ�ֵ��ֱ��˥��ֵ=I*t
cov_it = mean_it - mean_img .* mean_transmittance; % ÿ�����ڵ�ֱ��˥��ֵ��Э����

mean_img_b = boxfilter(img.*img, r) ./ N;%����ͼ������ƽ��ÿ�����ھ�ֵ
var_img = mean_img_b - mean_img .* mean_img;%����ÿ�����ڷ���
%����ģ���������
a = cov_it ./ (var_img + eps); % ����aֵ
b = mean_transmittance - a .* mean_img; % ����bֵ
mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

transmittance_guide = mean_a .* img + mean_b; % Eqn. (8) in the paper;
end