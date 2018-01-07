function [PSF,ElpPara] = myGaussEllipse(GaussPara,WinSize)
% [PSF] = myGaussEllipse(GaussPara,WinSize)
% This code generates the Gauss Filter kernel based on the formula from
% wiki
% In the future work, we may still use the equations that defined by
% ourselves.
% The url: https://en.wikipedia.org/wiki/Gaussian_function
% GaussPara, the parameters of Gauss Ellipse
% In this work, we take advantage that the plane set of a two Gaussian
% function is ellipse, which helps us to match the elliptical point
% sources.
% GaussPara = [A,SigmaX,SigmaY,theta]
% WinSize: window size of the PSF, half of the Window

% Init
A = GaussPara(1); SigmaX = GaussPara(2);
SigmaY = GaussPara(3); theta = GaussPara(4);
PSF = zeros(2*WinSize+1,2*WinSize+1);

% Get a,b,c
a = (cos(theta))^2/(2*SigmaX^2) + (sin(theta))^2/(2*SigmaY^2);
b = -(sin(2*theta)/(4*SigmaX^2))+sin(2*theta)/(4*SigmaY^2);
c = (sin(theta))^2/(2*SigmaX^2) + (cos(theta))^2/(2*SigmaY^2);

% Generate the PSF
[X,Y] = meshgrid(-WinSize:WinSize,-WinSize:WinSize);
PSF = A * exp(-(a*X.^2 - 2*b*X.*Y + c*Y.^2));

% Save the parameters of the plane set,i.e. the ellipse's parameters.
ElpPara = [round(4.29193*SigmaX/2),round(4.29193*SigmaY/2),theta];


        