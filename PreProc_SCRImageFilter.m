function [Paraout,ANS]=PreProc_SCRImageFilter(ImgPara,ImageIn)
%SCR图像滤波
%ImgPara(1,1)为Opcode，Opcode=1表示采用Lee滤波，Opcode=2表示采用精致Lee滤波。
%ImgPara(1,2)=parasNum为输入滤波参数数量
%ImgPara(1,3，……)为滤波算法参数
%ImgPara(1,3)为滤波算法采用的窗长WL，   精致Lee滤波只能使用窗长 WL=3,5,7 ,除此之外都将使用 WL = 3; 
%即当ImgPara(1,1)=2时，ImgPara(1,3)的有效输入值为3、5、7，若输入其他值则强制使用ImgPara(1,3)=3
%ImgPara(1,4)设定开启多核并行的核心数量，取 1 不开启cpu并行，最大不能超过当前计算机CPU的总核心数
%ImageIn为输入图像矩阵，为整型

%Paraout(1,1)为运行是否成功标志，1为成功，0为失败
%Paraout(1,2)为输出参数数目，如果为0即为没有其它输出参数
%Paraout(1,3,……)为输出参数
%其中Paraout(1,3)为原始图像的ENL
%Paraout(1,4)为滤波后的ENL
%Paraout(1,5)为ESI， 边缘保持指数，值在0-1之间
%ImageOut为输出，double图像矩阵
%%  计算图像分块大小
Q=ImgPara(1,4);
f = floor(ImgPara(1,3)/2);
w = 500;                                                                   %分块大小宽度初值
[M,N,C] = size(ImageIn);
if C == 3
    ImageIn = rgb2gray(ImageIn);
end
k = floor(N/w);                                                            %每行窗口数量
if k == 0                                                                  %图像过小 不分块
    k=1;
    w=N;
    Q=1;
end
D = N-w*k;
while D > k
    w = w+1;                                                               %迭代窗口宽度，使图像均分
    D = N-w*k;
end
v = floor(M/k);                                                            %计算窗口高度
ImageIn = ImageIn(1:v*k,1:w*k);                                            %舍弃边缘，使能够整除
Image = [zeros(v*k,2*f-1),ImageIn,zeros(v*k,1)];
Image = [zeros(2*f-1,2*f+w*k);Image;zeros(1,2*f+w*k)];                     %补零，补偿边缘
N = k*k;                                                                   %图像块总数
%%  分割处理图像
switch Q
    case 1
        I=zeros(v+2*f,w+2*f,N);
        Po=zeros(N,2);
        IF=zeros(v+f,w+f,N);
        h = waitbar(0,'图像分块处理中！');
        for i=1:N                                                          %不使用多核加速
            str = ['图像分块处理中！...',num2str(roundn(i/(N)*100,-1)),'%'];
            waitbar(i/(N),h,str);
            p = ceil(i/k);
            q = i - (p-1)*k;
            I(:,:,i) = Image(v*(p-1)+1:v*p+2*f,w*(q-1)+1:w*q+2*f);         %重叠选取边缘，补偿处理中的丢失
            [Po(i,:),IF(:,:,i)]=PreProcessing(ImgPara,I(:,:,i));           %Po中存储着各子块数据
        end
        close(h);
    otherwise
        pool=parpool(Q);
        Image = parallel.pool.Constant(Image);
        parfor_progress(N);                                                %进度条函数
        parfor i=1:N
            p = ceil(i/k);
            q = i - (p-1)*k;
            I(:,:,i) = Image.Value(v*(p-1)+1:v*p+2*f,w*(q-1)+1:w*q+2*f);   %重叠选取边缘，补偿处理中的丢失
            [Po(i,:),IF(:,:,i)]=PreProcessing(ImgPara,I(:,:,i));           %Po中存储着各子块数据
            parfor_progress;
        end
        parfor_progress(0);
        delete(pool);
end
IF = IF(2:v+1,2:w+1,:);                                                    %裁剪各子块结果边缘的0
%%  重新拼接图像
h = waitbar(0,'图像生成中！');
ANS = zeros(k*v,k*w);
for i=1:N
   str = ['图像生成中！...',num2str(roundn(i/(N)*100,-1)),'%'];
   waitbar(i/(N),h,str);
   p = ceil(i/k);
   q = i - (p-1)*k;
   ANS(v*(p-1)+1:v*p,w*(q-1)+1:w*q) = IF(:,:,i);                           %重组图像
end
ANS=ANS(2*f:k*v-1,2*f:k*w-1);                                              %去除多余边缘
close(h);
%%  输出参数
Paraout = zeros(1,5);
Paraout(1,1) = min(Po(:,1));                                               %整体成功标志，各子标志相与
Paraout(1,2) = max(Po(:,2));
if Paraout(1,1)~=1
    ANS = 0;                                                               %处理失败
    Paraout(1,2) = 0;
else
    try
        [Paraout(1,3),Paraout(1,4),Paraout(1,5)]=SCRFilteredResult_whole(ImageIn,ANS);  %整体计算各指标
    catch err
        Paraout(1,1) = 0;
        Paraout(1,2) = 0;
    end
end
