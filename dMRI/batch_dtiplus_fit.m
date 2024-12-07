close all
clear all
clc

% cvx_setup

% function to batch run the DTI+ fit on POCO19 data

addpath('/home/andek67/Data/Postcovid/')
addpath('/home/andek67/Data/Postcovid/qtiplus/')
addpath('/home/andek67/Data/Postcovid/qtiplus/helper_functions')
addpath('/home/andek67/Data/Postcovid/qtiplus/fitting_functions')
addpath('/home/andek67/Data/Postcovid/qtiplus/pipelines')
addpath('/home/andek67/Data/Postcovid/qtiplus/cvx/')

subjs_path = '/home/andek67/Data/Postcovid/';
cd(subjs_path)

%% get list of subjects without '.', '..'
d = dir;
d = d(~ismember({d.name}, {'.','..'}));
d = d(~ismember({d.name}, {'Analyses','DRgroup*','qtiplus','*slicetiming*'}));
d = d(~ismember({d.name}, {'*.sh','*.m','*.txt','*.ods'}));

%% loop through subjects
for i = 1:numel(d)
       
    try

        path_tmp = strcat(subjs_path,'/',d(i).name);
        cd(path_tmp)

        % if already processed, skip
        if ~exist('DTIp_topup_results', 'dir')
            
            disp('Analyzing')
            d(i).name
    
            % cd the temporary folder with copied file for pre/post processing
            cd('proc_dwi_topup')
   
            % run dti+ fit
            dtiplus_run_fit()
    
            % clear path and data for next subject
            clear path_tmp
        else
           disp('Skipping directory')
           d(i).name
        end
    
    catch
       disp('Could not process this directory') 
       d(i).name
    end
end
