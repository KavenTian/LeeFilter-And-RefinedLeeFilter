function [Paraout,ImageOut]=PreProcessing(ImgPara,ImageIn)

Opcode = ImgPara(1,1);
paraNum = ImgPara(1,2);
if size(ImageIn,3)==3
    ImageIn=rgb2gray(ImageIn);
end
try
    if Opcode==1 && paraNum==2%LeeËã·¨
        ImageOut=SCRLeeFilter_matrix(ImgPara(1,3),ImageIn);
        Paraout(1,1)=1;
        Paraout(1,2)=3;
    elseif Opcode==2 && paraNum==2%¾«ÖÂLeeËã·¨
        ImageOut=SCRRefinedLeeFilter_matrix(ImgPara(1,3),ImageIn);
        Paraout(1,1)=1;
        Paraout(1,2)=3;
    else
        ImageOut=0;
        Paraout(1,1)=0;
        Paraout(1,2)=0;
    end
catch err
    ImageOut=0;
    Paraout(1,1)=0;
    Paraout(1,2)=0;
end