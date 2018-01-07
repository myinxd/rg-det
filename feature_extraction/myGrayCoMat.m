function [GLCM,GLCM_pos,ASM,IDM,ENT,COR]=myGrayCoMat(img,r_s,c_s,level)
% [GLCM,ASM,IDM,ENT,COR]=myGrayCoMat(I,a,b,level)
% Generate the GLCM matrix as well as four mathematical statistics.
% Inputs
% img: the raw image
% r_s, c_s: row and column pixels in a local neighborhood
% level: levels of binned gray bins.
% Ouputs
% GLCM: gray level cocurrence matrix
% ASM: angular squared momentum
% IDM: inverse different moment 
% ENT: entropy 
% COR: correlation
%
% Version: 2.0
% Date: 2018/01/07
% Copyright (C) 2018 Zhixian MA <zx@mazhixian.me>

img = double(img);
[rows,cols]=size(img);
% Init
GLCM = zeros(level);
g_row = zeros(rows-r_s,cols-c_s);         % gray co-occurance pairs row
g_col = zeros(rows-r_s,cols-c_s);         % gray co-occurance paris col
img_norm = myGrayNormLevel(img,level);    % Normalization
ASM=0; IDM=0; ENT=0; COR=0;
%% calculate co-occurance pairs
for i = 1 : rows-r_s
    for j = 1 : cols-c_s
        g_row(i,j) = img_norm(i,j);
        g_col(i,j) = img_norm(i+r_s,j+c_s);
    end
end
%% GLCM
for i = 1 : rows-r_s    
    for j = 1 : cols-c_s
        GLCM(g_row(i,j),g_col(i,j)) = GLCM(g_row(i,j),g_col(i,j)) + 1;
    end
end
GLCM_pos = GLCM / ((rows-r_s)*(cols-c_s));           % Probability
%% ASM,IDM
for i=1:level
    for j=1:level
        ASM=ASM+GLCM(i,j)^2;
        IDM=IDM+(GLCM(i,j)^2)/(1+((i-j)^2));
    end
end
%% ENT
for i=1:level
    for j=1:level
        ENT=ENT-GLCM_pos(i,j)*log(GLCM_pos(i,j)+1e-5)/log(2);
    end
end
%% COR
Ui=zeros(1,level);Uj=zeros(1,level);
Si=zeros(1,level);Sj=zeros(1,level);
for i=1:level
    for j=1:level
        Ui(i)=Ui(i)+i*GLCM_pos(i,j);
    end
end
for i=1:level
    for j=1:level
        Si(i)=Si(i)+GLCM_pos(i,j)*((i-Ui(i))^2);
    end
end
Uj=Ui;Sj=Si;
for i=1:level
      COR=COR+(i^2*GLCM_pos(i,i)-Ui(i)*Uj(i))/(sqrt(Si(i)*Sj(j)));
end       