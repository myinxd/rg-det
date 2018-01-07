function [ImgNorm] = myNormalizer(ImgIn)
% [ImgNorm] = myNormalizer(ImgIn)
% This program normalize the input image
% The region is c[0,1]

ImgNorm = (ImgIn - min(ImgIn(:)))/(max(ImgIn(:))-min(ImgIn(:)));


