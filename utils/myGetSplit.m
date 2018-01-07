function subimages = myGetSplit(img,window,overlap)
% subimages = myGetSplit(img, window, overlap)
% Split the large image into small parts, which are overlapped with pixels
% 
% inputs
% img: 2D image
% window: shape of the subimage
% overlap: overlaps between two subimages, default as zero
%
% Ouput
% subimages: subimage cube
%
% Version: 1.0
% Author: Zhixian MA
% Date: 2018/01/06

if nargin < 3
    overlap = [0,0];
end

[rows, cols] = size(img);
if length(window) == 1
    r_w = window;
    c_w = window;
else
    r_w = window(1);
    c_w = window(2);
end
if length(overlap) == 1
    r_o = overlap;
    c_o = overlap;
else
    r_o = overlap(1);
    c_o = overlap(2);
end

% subimages
num_row = round((rows-r_w-1)/(r_w-r_o)) + 1;
num_col = round((cols-c_w-1)/(c_w-c_o)) + 1;
subimages = zeros(r_w,c_w,num_row*num_col);

for i = 1 : num_row
    for j = 1 : num_col
        id = (i-1)*num_row+j;
        subimages(:,:,id) = img((i-1)*(r_w-r_o)+1:(i-1)*(r_w-r_o)+r_w, ...
                                (j-1)*(c_w-c_o)+1:(j-1)*(c_w-c_o)+c_w);
    end
end