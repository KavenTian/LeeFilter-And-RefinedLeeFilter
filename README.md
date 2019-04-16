# LeeFilter-And-RefinedLeeFilter
## 文件说明
Demon.m				启动脚本  
PreProc_SCRImageFilter.m		主程序  
PreProcessing.m			中间预处理程序  
SCRLeeFilter_matrix.m		Lee滤波子程序  
SCRRefinedLeeFilter_matrix.m		精细Lee滤波子程序  
SCRFilteredResult_whole.m		滤波效果评价函数  
parfor_progress.m			用来在parfor中显示进度条的函数  
  
## 参数及接口说明
ImgPara(1,1)为Opcode，Opcode=1表示采用Lee滤波，Opcode=2表示采用精致Lee滤波  
ImgPara(1,2)=parasNum为输入滤波参数数量  
ImgPara(1,3，……)为滤波算法参数  
ImgPara(1,3)为滤波算法采用的窗长WL，   精致Lee滤波只能使用窗长 WL=3,5,7 ,除此之外都将使用 WL = 3; 
即当ImgPara(1,1)=2时，ImgPara(1,3)的有效输入值为3、5、7，若输入其他值则强制使用ImgPara(1,3)=3  
ImgPara(1,4)设定开启多核并行的核心数量，取 1 不开启cpu并行，最大不能超过当前计算机CPU的总核心数  
ImageIn为输入图像矩阵，为整型  
Paraout(1,1)为运行是否成功标志，1为成功，0为失败  
Paraout(1,2)为输出参数数目，如果为0即为没有其它输出参数  
Paraout(1,3,……)为输出参数  
其中Paraout(1,3)为原始图像的ENL  
Paraout(1,4)为滤波后的ENL  
Paraout(1,5)为ESI， 边缘保持指数，值在0-1之间  
ImageOut为输出，double图像矩阵  
