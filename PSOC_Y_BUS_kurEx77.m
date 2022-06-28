
function [Ybus, yc, n] = PSOC_Y_BUS_kurEx77 %defines a function Y_BUS_55 with outputs yb,yc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function generates 5x5 bus admittance matrix Y_BUS
% $Author: Dr. Rajat Kanti Samal$ $Date: 27-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement: Example 7.7, P272, K. Uma Rao Book, 
%  "Computer Techniques and Models in Power Systems"



clc;
clear all;

n=3;%input('Enter the size of the bus: ');


%Line impedances
zl = [0          0.00+0.10i 0.00+0.20i
      0.00+0.10i 0          0.00+0.20i
      0.00+0.20i 0.00+0.20i 0         ];
  
% line charging admittances
yc = j*[0 0 0 0
        0 0 0 0
        0 0 0 0];
    
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

%Addition of line charging admittances

for r=1:n
    y_sum=0;
    c_sum=0;
    for c=1:n
        y_sum=y_sum+Ybus(r,c);
        c_sum=c_sum+yc(r,c);
    end
    Ybus(r,r)=c_sum-y_sum; %because y_sum is negative
end
