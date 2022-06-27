%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program solves economic dispatch problem with losses
% $Author: Dr. Rajat Kanti Samal$ $Date: 27-Jun-2022 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$
%@Author: Rajat Kanti Samal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem Statement (Refer Example 8.12, P-327, K. Uma Rao, 
%  Book: Computer Techniques and Models in Power Systems
%  This program uses simplified transmission loss formula as Bij=0
%  The fuel costs of two units are given by
%  F1 = 320 + 6.2*Pg1 + 0.004 Pg1^2; F2 = 200 + 6.0*Pg2 + 0.003 Pg2^2
%  The real power loss is given by Pl = 0.0125 Pg1^2 + 0.0625 Pg2^2
%  Pg1, Pg2 are in MW. The loss coefficients are in pu on a 100 MVA base. 
%  Find the optimal schedule if the power demand is 412.35 MW.   

clc;
clear all;

Pd=412.35;delP=Pd; 
n=2; %number of generators

a=[320 200];
b=[6.2 6.0];
c=[0.004 0.003];
B(1,1)=0.0125/100; B(2,2)=0.00625/100;
Pg=zeros(1,n);
lambda=7; %this can be changed to initial guess 
itermax=10; iter=0;

while (delP>0.001 && iter<itermax)
    iter=iter+1;
    sumPg=0;
    Ploss=0;
    dPgdLam=0;
    for i=1:n
        Pg(i)=(lambda-b(i))/(2*(c(i)+lambda*B(i,i)));
        sumPg=sumPg+Pg(i);
        Ploss=Ploss+B(i,i)*Pg(i)^2;
        dPgdLam=dPgdLam+(c(i)+b(i)*B(i,i))/(2*(c(i)+lambda*B(i,i))^2);
    end
    delP=abs(Pd+Ploss-sumPg);      
    delLAM=delP/dPgdLam;
    lambda=lambda+delLAM;
%     iter
%     Pg
%     Ploss
%     dPgdLam
%     delP
%     delLAM
%     lambda

end

F=zeros(1,n); Tcost=0;
for i=1:n
    F(i)=a(i)+b(i)*Pg(i)+c(i)*(Pg(i)^2);
    Tcost=Tcost+F(i);
end

fprintf('Pg         Cost\n');
for i=1:n
    fprintf ('%5.1f      %7.1f \n', Pg(i)', F(i)')
end
iter
delP
lambda
Tcost

