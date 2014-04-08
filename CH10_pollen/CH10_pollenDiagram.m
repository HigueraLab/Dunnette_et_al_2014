% CH10_pollenDiagram.m
clear all

%% Input variables
site = {'Chickaree Lake, CO'};    % site name
zd = [-57 1200];   % zone dates
szd = [-9999];  % sub-zone divisions 
taxa_plot = [3:5 15 17 18 7 23 44 42 51];  % Taxa to include in the plot %Adjust this. 
taxa_for_sum = [1:89];          % Taxa to include in the pollen sum
ybp_start = 4500;    % [cal ybp] year to start record
ybp_stop = -60;      % [cal ybp] year to stop record
peaks = 0;           % 1 = plot peaks (with background), 0 = don't
transform = 0;       % 0 == none, 1 = sqrt pollen
printing = 0;        % Save file? 1 == yes, 0 == no

%% Load input data:

cd L:\1_projectsData\CO_RMNP_project\Analysis\1_Lakes\CH10\charcoal
char_counts = csvread('CH10_charData.csv',1,0);
char_peaks = csvread('CH10_charResults.csv',1,0);
char_peak_id = char_peaks(:,[1 2 6 7 19]);
char_peaks = -999;

cd L:\4_archivedData\Dunnette_et_al_2014_NewPhytologist\CH10_pollen
[data taxa] = xlsread('CH10_PollenCounts.xls','c1:di42');
        taxa(1:2) = []; % Delete the first two rows to include only taxa
pollen_counts = data(:,3:end)';

pollen_cm = data(:,1);
pollen_ybp = data(:,2);

p_analog = -999;
scdv = -999;

%% Run plot_pollen_char.m function:
[CHAR,char_ybp,pol_dat,pol_ybp,pol_sum] =...
    pollenDiagram_ROMO(site,pollen_counts,pollen_cm,pollen_ybp,taxa_for_sum,...
	taxa,taxa_plot,char_counts,char_peak_id,peaks,ybp_start,ybp_stop,...
    transform,scdv,p_analog,zd,szd,printing);

pol_percent = pol_dat(:,:,1)';
%%
cd L:\1_projectsData\CO_RMNP_project\Analysis\1_Lakes\CH10\pollen


