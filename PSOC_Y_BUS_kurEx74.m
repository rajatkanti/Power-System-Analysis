
function [Ybus, yc] = Y_BUS_kurEx74 %defines a function Y_BUS with outputs yb,yc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function generates bus admittance matrix Y_BUS
% $Author: Dr. Rajat Kanti Samal$ $Date: 27-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement (Refer Example 7.6.4, P-250, K. Uma Rao)
%  Consider a two bus system. The transmission line impedance is j0.5 pu.
%  Load demand at bus 2 is 0.5+j1.0 pu and power injected = j1.0 pu. 
%  Compute the Ybus matrix. 

clc;
clear all;

n=input('Enter the size of the bus: ');

%disp('Line Impedance Data (Make changes, if any, directly inside the program)')

zl = [0    0.5i
      0.5i 0];

%disp('Line Charging Admittance (Make changes, if any, directly inside the program)')


% line charging admittances
yc = 1i*[0 0
        0 0];
    
% Bus admittance matrix Y_BUS
for r=1:n
    for c=1:n
        if zl(r, c) == 0
            Ybus(r,c)=0;
        else
            Ybus(r,c)=-1/zl(r,c);
        end
    end
end

%Bus admittance matrix with transmission line data

for r=1:n
    y_sum=0;
    c_sum=0;
    for c=1:n
        y_sum=y_sum+Ybus(r,c);
        c_sum=c_sum+yc(r,c);
    end
    Ybus(r,r)=c_sum-y_sum; %because y_sum is negative
end
Ybus





