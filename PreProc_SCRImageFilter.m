function [Paraout,ANS]=PreProc_SCRImageFilter(ImgPara,ImageIn)
%SCRͼ���˲�
%ImgPara(1,1)ΪOpcode��Opcode=1��ʾ����Lee�˲���Opcode=2��ʾ���þ���Lee�˲���
%ImgPara(1,2)=parasNumΪ�����˲���������
%ImgPara(1,3������)Ϊ�˲��㷨����
%ImgPara(1,3)Ϊ�˲��㷨���õĴ���WL��   ����Lee�˲�ֻ��ʹ�ô��� WL=3,5,7 ,����֮�ⶼ��ʹ�� WL = 3; 
%����ImgPara(1,1)=2ʱ��ImgPara(1,3)����Ч����ֵΪ3��5��7������������ֵ��ǿ��ʹ��ImgPara(1,3)=3
%ImgPara(1,4)�趨������˲��еĺ���������ȡ 1 ������cpu���У�����ܳ�����ǰ�����CPU���ܺ�����
%ImageInΪ����ͼ�����Ϊ����

%Paraout(1,1)Ϊ�����Ƿ�ɹ���־��1Ϊ�ɹ���0Ϊʧ��
%Paraout(1,2)Ϊ���������Ŀ�����Ϊ0��Ϊû�������������
%Paraout(1,3,����)Ϊ�������
%����Paraout(1,3)Ϊԭʼͼ���ENL
%Paraout(1,4)Ϊ�˲����ENL
%Paraout(1,5)ΪESI�� ��Ե����ָ����ֵ��0-1֮��
%ImageOutΪ�����doubleͼ�����
%%  ����ͼ��ֿ��С
Q=ImgPara(1,4);
f = floor(ImgPara(1,3)/2);
w = 500;                                                                   %�ֿ��С��ȳ�ֵ
[M,N,C] = size(ImageIn);
if C == 3
    ImageIn = rgb2gray(ImageIn);
end
k = floor(N/w);                                                            %ÿ�д�������
if k == 0                                                                  %ͼ���С ���ֿ�
    k=1;
    w=N;
    Q=1;
end
D = N-w*k;
while D > k
    w = w+1;                                                               %�������ڿ�ȣ�ʹͼ�����
    D = N-w*k;
end
v = floor(M/k);                                                            %���㴰�ڸ߶�
ImageIn = ImageIn(1:v*k,1:w*k);                                            %������Ե��ʹ�ܹ�����
Image = [zeros(v*k,2*f-1),ImageIn,zeros(v*k,1)];
Image = [zeros(2*f-1,2*f+w*k);Image;zeros(1,2*f+w*k)];                     %���㣬������Ե
N = k*k;                                                                   %ͼ�������
%%  �ָ��ͼ��
switch Q
    case 1
        I=zeros(v+2*f,w+2*f,N);
        Po=zeros(N,2);
        IF=zeros(v+f,w+f,N);
        h = waitbar(0,'ͼ��ֿ鴦���У�');
        for i=1:N                                                          %��ʹ�ö�˼���
            str = ['ͼ��ֿ鴦���У�...',num2str(roundn(i/(N)*100,-1)),'%'];
            waitbar(i/(N),h,str);
            p = ceil(i/k);
            q = i - (p-1)*k;
            I(:,:,i) = Image(v*(p-1)+1:v*p+2*f,w*(q-1)+1:w*q+2*f);         %�ص�ѡȡ��Ե�����������еĶ�ʧ
            [Po(i,:),IF(:,:,i)]=PreProcessing(ImgPara,I(:,:,i));           %Po�д洢�Ÿ��ӿ�����
        end
        close(h);
    otherwise
        pool=parpool(Q);
        Image = parallel.pool.Constant(Image);
        parfor_progress(N);                                                %����������
        parfor i=1:N
            p = ceil(i/k);
            q = i - (p-1)*k;
            I(:,:,i) = Image.Value(v*(p-1)+1:v*p+2*f,w*(q-1)+1:w*q+2*f);   %�ص�ѡȡ��Ե�����������еĶ�ʧ
            [Po(i,:),IF(:,:,i)]=PreProcessing(ImgPara,I(:,:,i));           %Po�д洢�Ÿ��ӿ�����
            parfor_progress;
        end
        parfor_progress(0);
        delete(pool);
end
IF = IF(2:v+1,2:w+1,:);                                                    %�ü����ӿ�����Ե��0
%%  ����ƴ��ͼ��
h = waitbar(0,'ͼ�������У�');
ANS = zeros(k*v,k*w);
for i=1:N
   str = ['ͼ�������У�...',num2str(roundn(i/(N)*100,-1)),'%'];
   waitbar(i/(N),h,str);
   p = ceil(i/k);
   q = i - (p-1)*k;
   ANS(v*(p-1)+1:v*p,w*(q-1)+1:w*q) = IF(:,:,i);                           %����ͼ��
end
ANS=ANS(2*f:k*v-1,2*f:k*w-1);                                              %ȥ�������Ե
close(h);
%%  �������
Paraout = zeros(1,5);
Paraout(1,1) = min(Po(:,1));                                               %����ɹ���־�����ӱ�־����
Paraout(1,2) = max(Po(:,2));
if Paraout(1,1)~=1
    ANS = 0;                                                               %����ʧ��
    Paraout(1,2) = 0;
else
    try
        [Paraout(1,3),Paraout(1,4),Paraout(1,5)]=SCRFilteredResult_whole(ImageIn,ANS);  %��������ָ��
    catch err
        Paraout(1,1) = 0;
        Paraout(1,2) = 0;
    end
end
