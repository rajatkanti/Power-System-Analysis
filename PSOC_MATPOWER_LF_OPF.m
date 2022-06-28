%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load flow and Optimal Power Flow using MATPOWER software
% MATPOWER can run in both MATLAB and free open source OCTAVE 
% Steps to download and install.
% 1. Download MATPOWER software from https://matpower.org/ 
% 2. Put the matpower directory in workspace
% 3. Add the matpower subdirectories in the Set Path
% 4. Download MATPOWER documentation
% 5. The case file contains all information related to test system
% If you are using MATPOWER6 in OCTAVE install the octave-optim package using
% sudo apt-get install -y octave-optim
% else use a higher version of MATPOWER.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;

%% The following file contains all field information of mpc/results strut
define_constants;
baseMVA=100; 

%% Load flow using MATPOWER 
% load the case file (test system)
mpc = loadcase('case30');
% Refer P-32, MATPOWER6.0 manual for options
mpopt = mpoption('pf.alg', 'NR', 'verbose', 1, 'out.all', 1);

choice=input('Enter choice (1-Load flow; 2- OPF)-->');

switch(choice)
    case 1 % Load Flow
        % runpf is the MATPOWER function for load flow
        results = runpf(mpc,mpopt);

    case 2 % Optimal Power Flow
        %% Optimal Power Flow
        results = runopf(mpc,mpopt);
end

%% Write results in an output file
if choice==2
    busRES=results.bus(:,BUS_I:VA);
    busRES(:,3:4)=busRES(:,3:4)/baseMVA; % convert to pu             
    genRES=results.gen(:,GEN_BUS:VG);
    genRES(:,2:5)=genRES(:,2:5)/baseMVA; % convert to pu                 
    disp('Now writing results...')
    % xlswrite('C:\Users\RKSAMAL\Documents\MATLAB\Learning\PS-LAB-II\PS-LAB-II-IO.xlsx', busRES, 'EXP2', 'D6:L35');
    % xlswrite('C:\Users\RKSAMAL\Documents\MATLAB\Learning\PS-LAB-II\PS-LAB-II-IO.xlsx', genRES, 'EXP2', 'D40:I45');
end