clear
tic

ImgPara=[1,2,3,1];   %ImgPara(1,4)�趨�������������ȡ 1 ������cpu����,ͼ��ߴ��С��ȡ 1
                     %��� PreProc_SCRImageFilter.m �е�Э��˵��
                   
ImageIn=imread('C:\Users\Tianchao\Desktop\fogremove\2.bmp');

[Paraout,ImageOut]=PreProc_SCRImageFilter(ImgPara,ImageIn);

imshow(ImageOut,[]);
% imwrite(uint8(ImageOut),'C:\Users\Tianchao\Desktop\Cout.tif');
toc