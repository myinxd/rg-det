function [result,fgabor]=myGaborFeature(img,r_g,c_g,u,v,kmax,f)
% [result,fgabor]=myGaborFeature(img,u,v,kmax,f)
% Extract features from Gabor convolved images
% Inputs
% img: the raw image
% r_g, c_g: size of the Gabor kernel
% u: rotation list, e.g., [0, pi/4, pi/3, pi/2, pi]
% v: scale list, e.g., [2, 4, 8]
% kmax, f ??
% Outputs
% result: convolved images
% fgabor: gabor feature
% 
% Version: 2.0
% Date: 2018/01/07
% Copyright (C) 2018 Zhixian MA<zx@mazhixian.me>

% Init
[rows,cols]=size(img);
if isa(img,'double')~=1
    img = double(img);
end

Rotations = size(u,2); 
Scales = size(v,2);
% Convolved images
result=zeros(rows,cols,Rotations * Scales);
% Feature vector
fgabor=zeros(1, 2*Rotations*Scales);

for i=1:Rotations
    for j=1:Scales
        gkernel = myGenGabor(r_g,c_g,u(i),v(j),kmax,f);
        p = (i-1) * Scales + j;
        result(:,:,p) = imfilter(img, gkernel, 'circular');
        fgabor(p*2-1:p*2) = [std2(result(:,:,p)),mean2(result(:,:,p))]; 
    end
end            