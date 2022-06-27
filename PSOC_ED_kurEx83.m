%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program solves economic dispatch problem without losses
% $Author: Dr. Rajat Kanti Samal$ $Date: 27-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement (Refer Example 8.3, P-312, K. Uma Rao, 
%  Book: Computer Techniques and Models in Power Systems
%  The fuel costs of two units are given by
%  F1 = 350 + 7.2*Pg1 + 0.004 Pg1^2; F2 = 500 + 7.3*Pg2 + 0.0025 Pg2^2
%  F3 = 600 + 6.74*Pg3 + 0.003 Pg3^2
%  Pg1, Pg2, Pg3 are in MW. Find the optimal schedule neglecting losses.
%  The power demand is (i) 450 MW (ii) 800 MW  

clc;
clear all;

Pd=800; %change Pd as required

%cost curve of the generators a+bPg+cPg2
a=[350 500 600];
b=[7.2 7.3 6.74];
c=[0.004 0.0025 0.003];


% Refer equations for lambda
tmp=0;tmp2=0;
for i=1:3
    tmp=tmp+(b(i)/(2*c(i)));
    tmp2=tmp2+(1/(2*c(i)));
end

% Incremental cost
lambda= (Pd+tmp)/tmp2

Pg=zeros(1,3);F=zeros(1,3);
Tcost=0;
for i=1:3
    Pg(i)=(lambda-b(i))/(2*c(i));
    F(i)=a(i)+b(i)*Pg(i)+c(i)*(Pg(i)^2);
    Tcost=Tcost+F(i);
end

fprintf('Pg         Cost\n');
for i=1:3
    fprintf ('%5.1f      %7.1f \n', Pg(i)', F(i)')
end

% Total cost
Tcost


