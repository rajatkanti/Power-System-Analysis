%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program performs Load Flow using Newton-Raphson Method
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
error=1;iter=1;itermax=10; %itermax=0 calcualtes voltages after one iteration
while error>1e-4
    Pcal=[0;0;0]; Qcal=[0;0;0];
    %iter
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
            
            %vabs=abs(v); %magnitude of bus voltage
            %vangle=angle(v); %angle of bus voltage in radians
    end %Power calculation ends for all the buses i=1:n
    
%     'Calculated Real Power', Pcal'
%     'Calculated Reactive Power', Qcal'
    
    deltaP=Psp-Pcal;
    deltaQ=Qsp-Qcal;
    
    
        
    %'Delta P', deltaP'
    %'Delta Q', deltaQ'
    
    F0=[deltaP(2); deltaP(3); deltaQ(3)];
%     'Real and reactive power deviations', F0'
    error=max(abs(F0));
    if error<0.001
        break;
    end
        
%     errorP=max(abs(deltaP));
%     errorQ=max(abs(deltaQ));
%     error=max(errorP, errorQ);
    
    %Calculation of the Jacobian matrix starts below. Refer P-263 KUR
    i=2; Q=Qcal; P=Pcal;
    for i=2:3  
        if (i==vc && iter==1)
            for k=1:n
                tmp3=(Ybusreal(i,k)*sin(vangle(i)-vangle(k)))-(Ybusimag(i,k)*cos(vangle(i)-vangle(k)));
                tmp4=vabs(i)*vabs(k)*tmp3;
                Q(i)=Q(i)+tmp4;                
            end
        end
        
        %Evaluation of elements H
        H(i,i)=-Q(i)-Ybusimag(i,i)*vabs(i)^2;
        if (i==2)
            k=3;
            N(i,k)=vabs(i)*vabs(k)*((Ybusreal(i,k)*cos(vangle(i)-vangle(k)))+(Ybusimag(i,k)*sin(vangle(i)-vangle(k))));
            M(k,i)=-N(i,k);
        else
            k=2;
        end
        H(i,k)=vabs(i)*vabs(k)*((Ybusreal(i,k)*sin(vangle(i)-vangle(k)))-(Ybusimag(i,k)*cos(vangle(i)-vangle(k))));
        %H calculation ends
        
        %Calculate L
        if(i==3)
            N(i,i)=P(i)+Ybusreal(i,i)*vabs(i)^2;
            M(i,i)=P(i)-Ybusreal(i,i)*vabs(i)^2;
            L(i,i)=Q(i)-Ybusimag(i,i)*vabs(i)^2;
        end
                
    end
%     H
%     N
%     L
    
    Jacob77=[H(2,2) H(2,3) N(2,3); H(3,2) H(3,3) N(3,3); M(3,2) M(3,3) L(3,3)];
    deltaX=(inv(Jacob77))*F0;
    
%     'Jacobian:', Jacob77
%     'Increments:', deltaX'
    
    vangle(2)=vangle(2)+deltaX(1);
    vangle(3)=vangle(3)+deltaX(2);
    vabs(3)=vabs(3)+deltaX(3)*vabs(3);
    
    for i=1:3
        v(i)=complex(vabs(i)*cos(vangle(i)), vabs(i)*sin(vangle(i)));
    end
    
    vabs=abs(v); %magnitude of bus voltage
    vangle=angle(v); %angle of bus voltage in radians
    
%     'At the end of iteration', v', vabs', (vangle/d2r)'
    
    
    iter=iter+1;
    if (iter>itermax) 
        break;
    end
    
    
    
end

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

'At the end of iteration (all values in pu)', iter, error, v', vabs', (vangle/d2r)'
'Slack bus power (in pu)', complex(Pcal(1), Qcal(1))

%'Number of iterations: ', iter
%'Bus voltage magnitudes in pu: ',abs(v)'
%'Bus voltage angles in degrees: ', angle(v)'/d2r

