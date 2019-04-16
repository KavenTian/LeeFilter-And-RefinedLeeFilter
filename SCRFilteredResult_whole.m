function [ENL_o,ENL_L,ESI_L]=SCRFilteredResult_whole(IMAGE,IMAGE_filtered)
%滤波结果评价
%WL为窗长
%ENL(Equivalent Number of Looks）等效视数
%ENL_o原始图像的ENL
%ENL_L滤波后的ENL
%一般认为ENL_L-ENL_o越大越好，即ENL越大越好
%ESI 边缘保持指数，值在0-1之间，越接近1表示边缘保持的越好
[m,n]=size(IMAGE);
[y,x]=size(IMAGE_filtered);
IMAGE=double(IMAGE);
u_o=mean(mean(IMAGE));%原始图像均值
var_o=std2(IMAGE)*std2(IMAGE);%原始图像方差
u_L=mean(mean(IMAGE_filtered));%Lee滤波后图像均值
var_L=std2(IMAGE_filtered)*std2(IMAGE_filtered);%Lee滤波后图像方差
ENL_o=u_o^2/var_o;%原始图像等效视数
ENL_L=u_L^2/var_L;%滤波后图像等效视数

sum_o = sum(sum(abs(IMAGE(:,1:n-1)-IMAGE(:,2:n)))) + sum(sum(abs(IMAGE(1:m-1,:)-IMAGE(2:m,:))));
sum_L = sum(sum(abs(IMAGE_filtered(:,1:x-1)-IMAGE_filtered(:,2:x)))) + sum(sum(abs(IMAGE_filtered(1:y-1,:)-IMAGE_filtered(2:y,:))));

ESI_L=sum_L/sum_o;%滤波后图像的边缘保持指数
