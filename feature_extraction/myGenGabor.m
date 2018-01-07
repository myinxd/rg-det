function mygabor=myGenGabor(rows,cols,u,v,kmax,f)
% [mygabor]=MyGaborGen(m,n,v,u)
% Generate Gabor wavelet w.r.t. scale v and direction u 
% 
% Inputs
% rows,cols: shape of the gabor kernel
% v,u: scale and rotation of the gabor kernel
% kmax: amplitude? 
% f: frequency?
% Output
% mygabor: Gabor kernel
%
% Version: 1.0
% Date: 2018/01/07
% Copyright (C) 2018 Zhixian MA <zx@mazhixian.me>

if nargin < 5
    kmax = pi/2;
    f = sqrt(2); 
elseif nargin < 6
    f = sqrt(2);
end

% Init
mygabor=zeros(rows+1,cols+1);
% Mesh grid
xs=-fix(rows/2) : fix(rows/2);
ys=-fix(cols/2) : fix(cols/2);

% Get the kernel
kv=kmax/(f^v);
k=[kv*cos(u), kv*sin(u)];
sigma=2*pi;
kmod=sqrt(dot(k,k));

for p=1:rows+1
    for q=1:cols+1
        x = xs(p);
        y = ys(q);
        z=[x,y]';
        zmod=sqrt(dot(z,z));
        gker=kmod^2/sigma^2*exp(-(kmod^2*zmod^2)/(2*sigma^2))*(exp(j*k*z)-exp(-(sigma^2)/2));
        mygabor(p,q)=real(gker);
    end
end

    