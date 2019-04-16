clear
tic

ImgPara=[1,2,3,1];   %ImgPara(1,4)设定开启多核数量，取 1 不开启cpu并行,图像尺寸较小可取 1
                     %详见 PreProc_SCRImageFilter.m 中的协议说明
                   
ImageIn=imread('C:\Users\Tianchao\Desktop\fogremove\2.bmp');

[Paraout,ImageOut]=PreProc_SCRImageFilter(ImgPara,ImageIn);

imshow(ImageOut,[]);
% imwrite(uint8(ImageOut),'C:\Users\Tianchao\Desktop\Cout.tif');
toc