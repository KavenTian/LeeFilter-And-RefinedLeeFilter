function IMAGE_filtered_RL=SCRRefinedLeeFilter_matrix(WL,IMAGE)

%RefinedLee滤波器 ,WL=3
[m,n]=size(IMAGE);

IMAGE = double(IMAGE);
k=WL*WL;                        %产生矩阵总数
f=floor(WL/2);
IMAGE_filtered_RL=zeros(m-f,n-f);

G1=reshape([-1 0 1;-1 0 1;-1 0 1]',1,1,9).*ones(m-WL+1,n-WL+1,9);                   %垂直模板
G2=reshape([0 1 1;-1 0 1;-1 -1 0]',1,1,9).*ones(m-WL+1,n-WL+1,9);                   %135度模板
G3=reshape([1 1 1;0,0,0;-1 -1 -1]',1,1,9).*ones(m-WL+1,n-WL+1,9);                   %水平模板
G4=reshape([1 1 0;1 0 -1;0 -1 -1]',1,1,9).*ones(m-WL+1,n-WL+1,9);                   %45度模板

A=zeros(m-WL+1,n-WL+1,k);
for i=1:WL
    for j=1:WL
       A(:,:,(i-1)*WL+j)=IMAGE(i:i+m-WL,j:j+n-WL);  %错位产生矩阵
    end
end

B= [4,5,6;3,5,7;2,5,8;1,5,9];%建立比较抽取矩阵，对应 case

M = zeros(m-WL+1,n-WL+1,9);
switch WL
    case 5
        M1=A(:,:,[1:3,6:8,11:13]);
        M2=A(:,:,[2:4,7:9,12:14]);
        M3=A(:,:,[3:5,8:10,13:15]);
        M4=A(:,:,[6:8,11:13,16:18]);
        M5=A(:,:,[7:9,12:14,17:19]);
        M6=A(:,:,[8:10,13:15,18:20]);
        M7=A(:,:,[11:13,16:18,21:23]);
        M8=A(:,:,[12:14,17:19,22:24]);
        M9=A(:,:,[13:15,18:20,23:25]);
        M(:,:,1)=mean(M1,3);
        M(:,:,2)=mean(M2,3);
        M(:,:,3)=mean(M3,3);
        M(:,:,4)=mean(M4,3);
        M(:,:,5)=mean(M5,3);
        M(:,:,6)=mean(M6,3);
        M(:,:,7)=mean(M7,3);
        M(:,:,8)=mean(M8,3);
        M(:,:,9)=mean(M9,3);
        c1=reshape([1:3,6:8,11:13,16:18,21:23],1,1,15);
        c2=reshape([3:5,8:10,13:15,18:20,23:25],1,1,15);
        c3=reshape([1,6:7,11:13,16:19,21:25],1,1,15);
        c4=reshape([1:5,7:10,13:15,19:20,25],1,1,15);
        c5=reshape(11:25,1,1,15);
        c6=reshape(1:15,1,1,15);
        c7=reshape([1:5,6:9,11:13,16:17,21],1,1,15);
        c8=reshape([5,9:10,13:15,17:20,21:25],1,1,15);
        len=15;
    case 7
        M1=A(:,:,[1:3,6:8,11:13]);
        M2=A(:,:,[3:5,10:12,17:19]);
        M3=A(:,:,[5:7,12:14,19:21]);
        M4=A(:,:,[15:17,22:24,29:31]);
        M5=A(:,:,[17:19,24:26,31:33]);
        M6=A(:,:,[19:21,26:28,33:35]);
        M7=A(:,:,[29:31,36:38,43:45]);
        M8=A(:,:,[31:33,38:40,45:47]);
        M9=A(:,:,[33:35,40:42,47:49]);
        M(:,:,1)=mean(M1,3);
        M(:,:,2)=mean(M2,3);
        M(:,:,3)=mean(M3,3);
        M(:,:,4)=mean(M4,3);
        M(:,:,5)=mean(M5,3);
        M(:,:,6)=mean(M6,3);
        M(:,:,7)=mean(M7,3);
        M(:,:,8)=mean(M8,3);
        M(:,:,9)=mean(M9,3);
        c1=reshape([1:4,8:11,15:18,22:25,29:32,36:39,43:46],1,1,28);
        c2=reshape([4:7,11:14,18:21,25:28,32:35,39:42,46:49],1,1,28);
        c3=reshape([1,8:9,15:17,22:25,29:33,36:41,43:49],1,1,28);
        c4=reshape([1:7,9:14,17:21,25:28,33:35,41:42,49],1,1,28);
        c5=reshape(22:49,1,1,28);
        c6=reshape(1:28,1,1,28);
        c7=reshape([1:7,8:13,15:19,22:25,29:31,36:37,43],1,1,28);
        c8=reshape([7,13:14,19:21,25:28,31:35,37:42,43:49],1,1,28);
        len=28;
    otherwise
        M = A;
        c1=reshape([1 2 4 5 7 8],1,1,6);
        c2=reshape([2 3 5 6 8 9],1,1,6);
        c3=reshape([1 2 3 5 6 9],1,1,6);
        c4=reshape([1 4 5 7 8 9],1,1,6);
        c5=reshape([4 5 6 7 8 9],1,1,6);
        c6=reshape([1 2 3 4 5 6],1,1,6);
        c7=reshape([1 2 3 4 5 7],1,1,6);
        c8=reshape([3 5 6 7 8 9],1,1,6);
        len=6;
end

GV(:,:,1)=sum(G1.*M,3);
GV(:,:,2)=sum(G2.*M,3);
GV(:,:,3)=sum(G3.*M,3);
GV(:,:,4)=sum(G4.*M,3);
[~,GC]=max(GV,[],3);                %返回每个滑窗内的边缘检测结果 1~4

BA=reshape(B(GC,:),m-WL+1,n-WL+1,3);       %用以选取比较单元
comp1=zeros(m-WL+1,n-WL+1,3);
for i=1:m-WL+1
    for j=1:n-WL+1
        a=M(i,j,:);
        comp1(i,j,:)=a(BA(i,j,:));
    end
end
comp2=double(abs(comp1(:,:,1)-comp1(:,:,2))-abs(comp1(:,:,3)-comp1(:,:,2))>0)+ones(m-WL+1,n-WL+1);

%% 选取 WindowPart 并计算
C=[c1,c2;c3,c4;c5,c6;c7,c8];
P=zeros(m-WL+1,n-WL+1,len);
for i=1:m-WL+1
    for j=1:n-WL+1
        P(i,j,:)=C(GC(i,j),comp2(i,j),:);           %检索矩阵，选取 WindowPart
    end
end

WP=zeros(m-WL+1,n-WL+1,len);
for i=1:m-WL+1
    for j=1:n-WL+1
        a=A(i,j,:);
        WP(i,j,:)=a(P(i,j,:));
    end
end

U_Y = mean(WP,3);
VAR_Y = var(WP,0,3);
VAR_X = (VAR_Y-U_Y.^2)./2;
b = VAR_X./VAR_Y;
image = IMAGE(f+1:m-f, f+1:n-f);

image_end = uint8(U_Y)+uint8(b.*double(uint8(image-U_Y)));
IMAGE_filtered_RL(2:m-2*f+1,2:n-2*f+1)=image_end;