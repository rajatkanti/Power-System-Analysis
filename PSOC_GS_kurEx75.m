%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program performs Gauss-Siedel Load Flow for a five-bus system
% Bus 3 is PV bus
% $Author: Dr. Rajat Kanti Samal$ $Date: 27-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement: Example 7.5, P252, K. Uma Rao Book. 

clc;
clear all;
d2r=2*pi/360;
w=2*50*pi;

%The Ybus Matrix
[Ybus, yc, n]=PSOC_Y_BUS_kurEx75;

%Bus parameters and initial conditions; Bus1 is slack bus
p=[0;-0.6;1.0;-0.4;-0.6]; %real power at bus in pu (Pg-Pd)
q=[0;-0.3;0;-0.1;-0.2]; %imaginary power at bus in pu (Qg-Qd)
vspec=[1.02+0i;1+0i;1.04+0i;1+0i;1+0i];
v=[vspec(1); vspec(2); vspec(3); vspec(4); vspec(5)];
Ybusreal=real(Ybus); %array containing real part of Ybus
Ybusimag=imag(Ybus); %array contraining imaginary part of Ybus

%n=input('Please enter the size of the bus again: ');
vc=3; %input('Enter the voltage controlled bus number: ');

%Power flow equation iterations
e=1;iter=0;itermax=00; %this examples asks for voltages after one iteration
while e>1e-4
    
    vPrev=v;
    for i=2:n
        if (i ~= vc) %checks for PQ buses
            tmp1=(p(i)-1i*q(i))/conj(v(i));
            tmp2=0;
            for k=1:n
                if (i==k)
                    tmp2=tmp2+0;
                else
                    tmp2=tmp2+Ybus(i,k)*v(k);
                end
            end

            v(i)=(tmp1-tmp2)/Ybus(i,i);  %Eq 7.19, p247 KUR    
            vabs=abs(v); %magnitude of bus voltage
            vangle=angle(v); %angle of bus voltage in radians
 
        else %if voltage controlled bus
            for k=1:n
                %the following code segment can be used for debugging
                %purposes
%                if (k==2)
%                'k', k
%                'q(vc)', q(vc)
%                'vabs(vc)', vabs(vc)
%                'vabs(k)', vabs(k)
%                'Ybusreal(vc,k)', Ybusreal(vc,k)
%                'Ybusimag(vc,k)', Ybusimag(vc,k)
%                vangtmp=vangle(vc)-vangle(k);
%                'vangtmp', vangtmp
%                'sinangle', sin(vangle(vc)-vangle(k))
%                'cosangle', cos(vangle(vc)-vangle(k))
%                end
            
            tmp3 = (vabs(vc)*vabs(k)*(Ybusreal(vc,k)*sin(vangle(vc)-vangle(k))-Ybusimag(vc,k)*cos(vangle(vc)-vangle(k))));
            %'tmp3', tmp3, pause
            q(vc)=q(vc)+tmp3; % Eq7.9b, p239, KUR
            end
            %'Reactive power at voltage controlled bus', q(vc)
            %the following code segment is same as PQ bus after
            %substituting the new value of q
            tmp1=(p(i)-1i*q(i))/conj(v(i));
            tmp2=0;
            for k=1:n
                if (i==k)
                    tmp2=tmp2+0;
                else
                    tmp2=tmp2+Ybus(i,k)*v(k);
                end
            end

            v(i)=(tmp1-tmp2)/Ybus(i,i);
            v(i)= abs(vspec(i))*(cos(angle(v(i)))+j*sin(angle(v(i))));
            
            vabs=abs(v);
            vangle=angle(v);
            
        end %Voltage controlled bus calculation ends
    end
    
    error=abs(v-vPrev);
    e=max(error);
    
    iter=iter+1;
    if (iter>itermax) 
        break;
    end
end

'Number of iterations: ', iter
'Bus voltage magnitudes in pu: ',abs(v)'
'Bus voltage angles in degrees: ', angle(v)'/d2r
