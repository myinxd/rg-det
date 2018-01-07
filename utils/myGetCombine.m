function img = myGetCombine(subimages,imgshape,window,overlap)
% img = myGetCombine(subimages, window, overlap)
% Combine the subimages into a complete large image.
% 
% inputs
% subimages: 2D subimages, (rows,cols,number)
% window: shape of the subimage
% overlap: overlaps between two subimages, default as zero
%
% Ouput
% img: combined image
%
% Version: 1.0
% Author: Zhixian MA
% Date: 2018/01/06

if nargin < 4
    overlap = [0,0];
end

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
if length(imgshape) == 1
    rows = imgshape;
    cols = imgshape;
else
    rows = imgshape(1);
    cols = imgshape(2);
end

% subimages
num_row = round((rows-r_w-1)/(r_w-r_o)) + 1;
num_col = round((cols-c_w-1)/(c_w-c_o)) + 1;
img = zeros(rows, cols);


for i = 1 : num_row
    for j = 1 : num_col
        id = (i-1)*num_row+j;
        img((i-1)*(r_w-r_o)+1:(i-1)*(r_w-r_o)+r_w,(j-1)*(c_w-c_o)+1:(j-1)*(c_w-c_o)+c_w) = ...
            subimages(:,:,id);
    end
end