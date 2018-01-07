function img_norm = myGrayNormLevel(img,level)
% [I_norm]=GrayNormLevel(I,level)
% Image normalization for generating gray level binned image.
% Input
% img: img matrix
% level: gray levels to be binned
%
% Output
% img_norm: normalized and binned image
% 
% Version: 2.0
% Date: 2018/01/06
% Copyright (C) 2018 Zhixian MA

if nargin < 2
    level = 8;
end
% Init
[rows, cols]=size(img);
img_norm=zeros(rows,cols);

% Normalization
I_min=min(img(:)); 
I_max=max(img(:));
I_block=floor((I_max-I_min)/level);
for i=1:rows
    for j=1:cols
        img_norm(i,j)=floor(((img(i,j)-I_min)/(I_block+1)))+1;
    end
end

end