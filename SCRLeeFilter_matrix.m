function IMAGE_filtered=SCRLeeFilter_matrix(WL,IMAGE)

%Lee滤波器
%WL为窗长
[m,n]=size(IMAGE);
IMAGE=double(IMAGE);
k=WL*WL;                        %产生矩阵总数
f=floor(WL/2);
IMAGE_filtered=zeros(m-f,n-f);

A=zeros(m-WL+1,n-WL+1,k);
for i=1:WL
    for j=1:WL
       A(:,:,(i-1)*WL+j)=IMAGE(i:i+m-WL,j:j+n-WL);  %产生矩阵
    end
end
U_Y = mean(A,3);                    %存储均值
VAR_Y = var(A,0,3);                 %存储方差
VAR_X = (VAR_Y-U_Y.^2)./2;
B = VAR_X./VAR_Y;
image = IMAGE(f+1:m-f, f+1:n-f);      %大小为 m-2*f     
image_end = uint8(U_Y)+uint8(B.*double(uint8(image-U_Y)));      % 最终结果

IMAGE_filtered(2:m-2*f+1,2:n-2*f+1)=image_end;