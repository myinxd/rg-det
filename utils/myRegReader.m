function [ImgReg,RegPara] = myRegReader(ImgFile,RegFile)
% function [ImgReg,RegPara] = myRegReader(ImgFile,RegFile)
% This code reads the raw X-ray astronomical image and locate the regions
% with the RegFile.
% ImgFile: file name of the raw image
% RegFile: region file of the raw image
% ImgReg: the output image
% Version 1.0
% Date: 2016/01/07
% Author: Zhixian Ma

Img = fitsread(ImgFile);

% Region Parameters, the region structure is box
RegStr = textread(RegFile,'%s');
RegStr = RegStr{end};
Index = isletter(RegStr); RegStr(find(Index == 1)) = [];
RegStr(find(RegStr == '(' | RegStr == ')')) = [];
RegPara = str2num(RegStr);
%RegPara = [404,91,120,120];

RowCtr = RegPara(2); RowWidth = round(RegPara(4)/2);
ColCtr = RegPara(1); ColWidth = round(RegPara(3)/2);

ImgReg = Img(RowCtr-RowWidth+1:RowCtr+RowWidth,ColCtr-ColWidth+1:ColCtr+ColWidth);







