function [ENL_o,ENL_L,ESI_L]=SCRFilteredResult_whole(IMAGE,IMAGE_filtered)
%�˲��������
%WLΪ����
%ENL(Equivalent Number of Looks����Ч����
%ENL_oԭʼͼ���ENL
%ENL_L�˲����ENL
%һ����ΪENL_L-ENL_oԽ��Խ�ã���ENLԽ��Խ��
%ESI ��Ե����ָ����ֵ��0-1֮�䣬Խ�ӽ�1��ʾ��Ե���ֵ�Խ��
[m,n]=size(IMAGE);
[y,x]=size(IMAGE_filtered);
IMAGE=double(IMAGE);
u_o=mean(mean(IMAGE));%ԭʼͼ���ֵ
var_o=std2(IMAGE)*std2(IMAGE);%ԭʼͼ�񷽲�
u_L=mean(mean(IMAGE_filtered));%Lee�˲���ͼ���ֵ
var_L=std2(IMAGE_filtered)*std2(IMAGE_filtered);%Lee�˲���ͼ�񷽲�
ENL_o=u_o^2/var_o;%ԭʼͼ���Ч����
ENL_L=u_L^2/var_L;%�˲���ͼ���Ч����

sum_o = sum(sum(abs(IMAGE(:,1:n-1)-IMAGE(:,2:n)))) + sum(sum(abs(IMAGE(1:m-1,:)-IMAGE(2:m,:))));
sum_L = sum(sum(abs(IMAGE_filtered(:,1:x-1)-IMAGE_filtered(:,2:x)))) + sum(sum(abs(IMAGE_filtered(1:y-1,:)-IMAGE_filtered(2:y,:))));

ESI_L=sum_L/sum_o;%�˲���ͼ��ı�Ե����ָ��
