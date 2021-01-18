function mapping_fullBZ()

clc
clear all
close all
format long g

% mapping ful BZ for a given structure

% The geometry and number of parameters to optimize should be defined by the user. 

%% First part used to initialize geoemetry and optimization parameters

% set directory and select geoemtry
cd('/Data/Juan/MPB_Working/2D/Full BZ');
geom_script = 'mapBZ.ctl';
display(['Using geometry script: ',geom_script])

%% Initial values

ascan = 290;    % a values for scanning
R = 103;     % R values for scanning            
res = 30;
fD2 = 351.725e12;

% Create vector list
x1 = [0:0.025:1]*0.5;

for ia = 1:numel(ascan);
    for ix1 = 1:numel(x1);
        for ix2 = 1:numel(x1);
            dims = [ascan(ia) R];
            kxy = [x1(ix1) x1(ix2)];
            params = params_new(dims,kxy,res);
            MPB_out = run_MPB(geom_script,params); % Run MPB script
            MPB_out
            low(ix1,ix2,ia) = (MPB_out.lower)/1e12;     %record lower frequency band
            high(ix1,ix2,ia) = (MPB_out.upper)/1e12;    %record upper frequency band
        end
    end
end

save('flow_fullBZ_ascan.mat','ascan','R','x1','low')
save('fhigh_fullBZ_ascan.mat','ascan','R','x1','high')

end

%% Auxiliary functions

% Generate parameters
function params_out = params_new(dims,kxy,res)
    params_out = ['a=',num2str(dims(1)),' Rnm=',num2str(dims(2)),' x1=',num2str(kxy(1)),' x2=',num2str(kxy(2)),' res=',num2str(res)];
end

% Run MPB
function MPB_out = run_MPB(geom_script,params)
    cmd = ['/usr/bin/mpb ',params,' ',geom_script] ;
    disp(cmd)
    [~,output] = unix(cmd);
    MPB_out = get_freqs_MPB_output(output);
end  

% Process MPB output
function MPB_out = get_freqs_MPB_output(input)
    k1 = strfind(input,'lower band:');
    k2 = strfind(input,'higher band:');
    k3 = strfind(input,'Some');
    lower_band = input((k1+12):(k2-1));
    upper_band = input((k2+12):(k3-1));
    MPB_out.lower = str2num(lower_band);
    MPB_out.upper = str2num(upper_band);
end  
   
