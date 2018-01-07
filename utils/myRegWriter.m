function myRegWriter(RegName,PSlist,Mode)
% myRegWriter(RegName,PSlist,Mode)
% This code save the region files according to the region mode
% RegName: name of the region file
% PSlist: list of point sources
% Mode: mode of the region, 'cir' is circle, 'elp' is ellipse and 'box' is
% box
% Version:1.0
% Date: 2016/01/07
% Author: Zhixian Ma

if nargin < 4
    BoxWidth = 10;
end

L = length(PSlist(:,1)); % length of PS list
fp = fopen(RegName,'wt');
fprintf(fp,'%s\n','global color=red dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1');
fprintf(fp,'%s\n','image');

switch Mode
    case 'box'
        for i = 1 : L
            PString = ['rotbox(',num2str(PSlist(i,1)),',',num2str(PSlist(i,2)),',',num2str(BoxWidth),',',num2str(BoxWidth),',4.0840969e-11)'];
            fprintf(fp,'%s\n',PString);
        end
    case 'cir'
        for i = 1 : L
            PString = ['circle(',num2str(PSlist(i,1)),',',num2str(PSlist(i,2)),',',num2str(PSlist(i,3)),')'];
            fprintf(fp,'%s\n',PString);
        end
    case 'elp'
        for i = 1 : L
            PString = ['ellipse(',num2str(PSlist(i,1)),',',num2str(PSlist(i,2)),',',num2str(PSlist(i,3)),',',num2str(PSlist(i,4)),',',num2str(PSlist(i,5)),')'];
            fprintf(fp,'%s\n',PString);
        end
end

fclose(fp);
