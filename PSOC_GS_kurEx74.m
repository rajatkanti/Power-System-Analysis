%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program performs Gauss-Siedel Load Flow for a two-bus system
% $Author: Dr. Rajat Kanti Samal$ $Date: 27-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement (Refer Example 7.4, P-250, K. Uma Rao)
%  Consider a two bus system. The transmission line impedance is j0.5 pu.
%  Load demand at bus 2 is 0.5+j1.0 pu and power injected = j1.0 pu. 
%  Obtain voltage at bus 2 using G-S method.  

clc;
clear all;
d2r=2*pi/360;
w=2*50*pi;

%The Ybus Matrix
[Ybus, yc]=PSOC_Y_BUS_kurEx74;

%Bus parameters and initial conditions; Bus1 is slack bus
p=[0;-0.5]; %real power at bus in pu
q=[0;0]; %imaginary power at bus in pu
v=[1+0i;1+0i];
n=2;

%Power flow equation iterations
e=1;iter=0;itermax=50;
while e>1e-4
    
    vPrev=v;
    for i=2:n
        tmp1=(p(i)-1i*q(i))/conj(v(i));
        tmp2=0;
        for k=1:2
            if (i==k)
                tmp2=tmp2+0;
            else
                tmp2=tmp2+Ybus(i,k)*v(k);
            end
        end
        
        v(i)=(tmp1-tmp2)/Ybus(i,i);      
    end
    
    error=abs(v-vPrev);
    e=max(error);
    
    iter=iter+1;
    if (iter>itermax) 
        break;
    end
end

'Number of iterations:', iter, pause
'Bus voltage magnitudes:',abs(v)', pause
'Bus voltage angles', angle(v)'/d2r, pause
