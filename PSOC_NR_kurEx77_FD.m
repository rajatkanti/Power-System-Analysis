%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program performs Load Flow using Fast-Decoupled Method
% $Author: Dr. Rajat Kanti Samal$ $Date: 28-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement: Example 7.7, P272, K. Uma Rao Book. 

clc;
clear all;


d2r=2*pi/360;
w=2*50*pi;

%The Ybus Matrix
[Ybus, yc, n]=PSOC_Y_BUS_kurEx77;
Ybusreal=real(Ybus); %array containing real part of Ybus
Ybusimag=imag(Ybus); %array contraining imaginary part of Ybus

%Bus parameters and initial conditions; Bus1 is slack bus
vspec=[1.0+0.0i;1.1+0.0i;1.0+0.0i]; %initial voltages
Psp=[0;5.3217;-3.6392]; %real power at bus in pu (Pg-Pl)
Qsp=[0;0;-0.5339]; %imaginary power at bus in pu (Qg-Qd)
v=[vspec(1); vspec(2); vspec(3)];
vabs=abs(v); %magnitude of bus voltage
vangle=angle(v); %angle of bus voltage in radians
Pcal=[0;0;0]; Qcal=[0;0;0];


%n=input('Please enter the size of the bus again: ');
vc=2; %input('Enter the voltage controlled bus number: ');

%Power flow equation iterations
error=1;iter=1;itermax=5; %itermax=0 calcualtes voltages after one iteration
while error>1e-4
    Pcal=[0;0;0]; Qcal=[0;0;0];
    'iter', iter
    vPrev=v;
    for i=2:n
        
            tmp1=0;tmp2=0;tmp3=0;tmp4=0;            
            if (i ~= vc) %checks for PQ buses
                %P calculation
                for k=1:n
                    tmp1=(Ybusreal(i,k)*cos(vangle(i)-vangle(k)))+(Ybusimag(i,k)*sin(vangle(i)-vangle(k)));
                    tmp2=vabs(i)*vabs(k)*tmp1;
                    Pcal(i)=Pcal(i)+tmp2;                
                end
                %Q calculation
                for k=1:n
                    tmp3=(Ybusreal(i,k)*sin(vangle(i)-vangle(k)))-(Ybusimag(i,k)*cos(vangle(i)-vangle(k)));
                    tmp4=vabs(i)*vabs(k)*tmp3;
                    Qcal(i)=Qcal(i)+tmp4;                
                end
            else %if PV bus, Q must not be calculated for the first iteration(?)
                %P calculation
                for k=1:n
                    tmp1=(Ybusreal(i,k)*cos(vangle(i)-vangle(k)))+(Ybusimag(i,k)*sin(vangle(i)-vangle(k)));
                    tmp2=vabs(i)*vabs(k)*tmp1;
                    Pcal(i)=Pcal(i)+tmp2;                
                end
            end
            
            if (i==vc && iter>1)
                for k=1:n
                    tmp3=(Ybusreal(i,k)*sin(vangle(i)-vangle(k)))-(Ybusimag(i,k)*cos(vangle(i)-vangle(k)));
                    tmp4=vabs(i)*vabs(k)*tmp3;
                    Qcal(i)=Qcal(i)+tmp4;                
                end
            end            
    end %Power calculation ends for all the buses i=1:n
    
    %Calculation for angle deviations
    deltaP=Psp-Pcal;   
    F01=[deltaP(2)/vabs(2); deltaP(3)/vabs(3)];   
    Jacob77=[-Ybusimag(2,2) -Ybusimag(2,3); -Ybusimag(3,2) -Ybusimag(3,3)];    
    deltaXa=(inv(Jacob77))*F01;    
    %updated values of voltage angles are given below   
    vangle(2)=vangle(2)+deltaXa(1);
    vangle(3)=vangle(3)+deltaXa(2);    
           
    %Calculate deltaQ3
    i=3;
    for k=1:n
    tmp3=(Ybusreal(i,k)*sin(vangle(i)-vangle(k)))-(Ybusimag(i,k)*cos(vangle(i)-vangle(k)));
    tmp4=vabs(i)*vabs(k)*tmp3;
    Qcal(i)=Qcal(i)+tmp4;                
    end
    
    deltaQ(i)=Qsp(i)-Qcal(i)   
    F02=[deltaQ(3)/vabs(3)];
    deltaXm=(inv(-Ybusimag(3,3)))*F02;
    vabs(3)=vabs(3)+deltaXm*vabs(3);
    
    increment=[deltaXa(1) deltaXa(2) deltaXm ];   
    'Results in iteration:', increment
    
    
    
    for i=1:3
        v(i)=complex(vabs(i)*cos(vangle(i)), vabs(i)*sin(vangle(i)));
    end
    
    vabs=abs(v); %magnitude of bus voltage
    vangle=angle(v); %angle of bus voltage in radians
    
    error=max(abs(F01),abs(F02));
    if error<0.001
        break;
    end
    
%         
    iter=iter+1;
    if (iter>itermax) 
        break;
    end
    
end


'At the end of iteration', v', vabs', (vangle/d2r)'

%Calculation of Slack bus power
%P calculation
i=1;
for k=1:n
    tmp1=(Ybusreal(i,k)*cos(vangle(i)-vangle(k)))+(Ybusimag(i,k)*sin(vangle(i)-vangle(k)));
    tmp2=vabs(i)*vabs(k)*tmp1;
    Pcal(i)=Pcal(i)+tmp2;                
end
%Q calculation
for k=1:n
    tmp3=(Ybusreal(i,k)*sin(vangle(i)-vangle(k)))-(Ybusimag(i,k)*cos(vangle(i)-vangle(k)));
    tmp4=vabs(i)*vabs(k)*tmp3;
    Qcal(i)=Qcal(i)+tmp4;                
end

%'At the end of iteration (all values in pu)', iter, error, v', vabs', (vangle/d2r)'
%'Slack bus power (in pu)', complex(Pcal(1), Qcal(1))

%'Number of iterations: ', iter
%'Bus voltage magnitudes in pu: ',abs(v)'
%'Bus voltage angles in degrees: ', angle(v)'/d2r

