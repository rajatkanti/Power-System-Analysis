%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program solves economic dispatch problem without losses
% $Author: Dr. Rajat Kanti Samal$ $Date: 27-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement (Refer Example 8.1, P-310, K. Uma Rao Book)
% The fuel costs of two units are given by
% F1 = 1.5 + 20*Pg1 + 0.1 Pg1^2; F2 = 1.9 + 30 Pg2 + 0.1 Pg2^2
% Pg1, Pg2 are in MW. Find the optimal schedule neglecting losses.
% The power demand is 200 MW. 


clc;
clear all;

Pd=200; %demand
n=2; %number of generators

%F=a+bP+cP2
a=[1.5 1.9];
b=[20 30];
c=[0.1 0.1];

tmp=0;tmp2=0;
for i=1:n
    tmp=tmp+(b(i)/(2*c(i))); %Sum(bi/2ci)
    tmp2=tmp2+(1/(2*c(i))); %Sum(1/2ci)
end

% Incremental cost
lambda= (Pd+tmp)/tmp2

Pg=zeros(1,n);F=zeros(1,n);
Tcost=0;
for i=1:n
    Pg(i)=(lambda-b(i))/(2*c(i));
    F(i)=a(i)+b(i)*Pg(i)+c(i)*(Pg(i)^2);
    Tcost=Tcost+F(i);
end

fprintf('Pg         Cost\n');
for i=1:n
    fprintf ('%5.1f      %7.1f \n', Pg(i)', F(i)')
end

% Total cost
Tcost


