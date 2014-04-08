% Fig_4_5.m
%
% Make Figure 4 and Figure 5 from:
% Dunnette P.V., P.E. Higuera, K.K. McLauchlan, K.M. Derr, C.E. Briles, 
% M.H. Keefe. 2014. Biogeochemical impacts of wildfires over four millennia 
% in a Rocky Mountain subalpine watershed. New Phytologist Accepted.
%
% Figure 4. Time series of sediment biogeochemistry and bulk density. Raw 
% and smoothed (500-year trend; bold line) time series, with vertical solid
% red lines denoting high-severity catchment fires (n = 11) and vertical 
% dashed blue lines denoting lower severity/extra local fires (n = 9) used 
% in Superposed Epoch Analysis (SEA). Grey dots represent lower 
% severity/extra local fires not included in the SEA (see Materials and 
% Methods). Bulk density is abbreviated by “BlkDens.”
%
% Figure 5. Results of Superposed Epoch Analysis (SEA). Composite residual
% response values (y axis) before and after high-severity catchment fires
% (solid red lines, left column) and lower severity/extra local fires
% (dashed blue lines, right column). The horizontal dashed and solid lines
% represent Monte Carlo-derived 99% and 95% confidence intervals, 
% respectively. Bulk density is abbreviated by “BlkDens.”
%
% Details for SEA:
% SEA takes as in input a matrix of event time series, 'events', and a 
% matrix response time sereis, 'response.' In both cases, the first column 
% in each matrix includes the years of the time series, while the remaining
% columns include the events (binary, 1 or 0) or response values (units of
% the response variable). 
%
% The user must/may define the following:
% yrCutOff: [yr BP] Years of BOTH time series to analyze.
% params.interpValue: [yr] Years to interpolate response series to. 
% params.smWindow: [yr] Years to smooth response series to, for calculating 
%                   residuals. 
% params.eventWindow: [yr] Years to analyze, before and after events. 
% x_lim: [yr BP] Years for plotting time series.
%
% Criteria for events: 99.9 percentile CHAR pks, 99.9 percentile pks. 
% 70 years was the minimum allowable time between consecutive events
% (approximately 1/2 the longest FRI). A coincident event at 3316 yrBP was 
% excluded, owing to its proximity to the 3262 yrBP fire (~54 yr). 
% Including these events did not significantly alter the results. 
%
% Created by: P.E. Higuera
% Created on: 18 July, 2012
% Updated: 19 July, 2012, by PEH
% Updated: 12/2012; 3/2013; 6/2013; 7/2013; 8/2013; 9/2013 by P.V. Dunnette
% Edited: 4/2014 for publication, by P.E. Higuera
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu
clear all

%% Set working directories: directories where input data are located
workingDir = 'L:\4_archivedData\Dunnette_et_al_2014_NewPhytologist\CH10_biogeochem\';
workingDir2 = 'L:\4_archivedData\Dunnette_et_al_2014_NewPhytologist\CH10_c\';
startDir = pwd;     % Record starting path

%% User-set parameters
params.interpValue = 5 ;        % [yr] Years to interpolate to 
params.smWindow = 500 ;         % [yr] Years to smooth to.
params.eventWindow = [-50 75] ; % [yr] Years to analyze, before and after 
params.responseName = {['\delta^1^5N (' char(8240) ')'];...
    'C:N'; ['      C_a_c_c      ' ;...
    '(g cm^{-2} yr^{-1})'];'C (%)';...
    'N (%)';['  BlkDens  ';...
    '(g cm^{-3})']};            % Parameter lables
params.responseName = params.responseName([1 2 3 4 5 6]);  % Trim

yrCutOff = [-57 4300];      % [cal yr BP] Years to use in the analysis                              
x_lim = yrCutOff;

%% Load data and create variables
cd(workingDir)      % Change to working directory
data = csvread('CH10_biogeochemData.csv',1,3);      % Biogeochemical data
colName = {'topCm';'botCm';'topAge';'botAge';['\delta^1^5N (' char(8240) ')'];'C:N'; 'N (%)';'BD(g/cm^3)';	
    ['\delta^1^3C (' char(8240) ')']};     % Column headers, and units
cd(startDir)        % Change direcotry back to starting directory.

%% Mannualy input events dates
HSCF = [161 960 1243 2124 2670 2752 2913 3262 3725 3803 4156]; 
    % [cal yr BP] High-severity catchmant fires (n = 11). Based on output 
    % from events_ID (altered manually for more precise fire yr)
nHSCF = length(HSCF);               % sample size for HSCF
    
LSEF_hiRes = [230 521 1637 1875 2177 2508 3116 3396 3863];
    % [cal yr BP] Lower severity, extra local fires (LSEF)with high 
    % resolution analysis (n = 9)
nLSEF_hiRes = length(LSEF_hiRes);   % sample size for LSEF_hiRes

LSEF_lowRes = [573 659 823 891 1360 1577 1893 2065 2870 2948 3316 3888...
    4081 4179]; 
    % [cal yr BP] LSEF, without high-resolution analysis (n = 14). These
    % are only for plotting (Fig. 4).

%% Define response series
response.in = [6 10 13 9 7 11];     % Index for response vars., from data
response.n = length(response.in);   % Number of response variables
in = find([(response.x >= yrCutOff(1)) .* (response.x <= yrCutOff(2))]);
    % Index for all samples within desired age range, defined by yrCutOff   
response.x = mean(data(in,4:5),2);  % [cal yr BP] Mid-sample age of samples
response.y = data(in,response.in);  % Response time series; units are in 
                                    % params.responseName.  

%% Interpolate and smooth response series
response.xi = [yrCutOff(1):params.interpValue:max(response.x(:,1))]';
                % [cal yr BP] Interpolated x values
response.yi = interp1(response.x,response.y,response.xi);   % Interpolated 
                % response series; units as in response.y

response.ySm = NaN*ones(size(response.yi)); % Space for smoothed 
                                            % response series
for i = 1:response.n
    response.ySm(:,i) = smooth(response.yi(:,i),... % Lowess smoother, 
    params.smWindow/params.interpValue,'rlowess');  % robust to outliers. 
end

%% Caclulate residual response series, to be used in SEA
response.residuals = response.y - response.ySm; % Residulas after removing 
                    % long-term trends from interpolated response variables

%% Create composite records, using the function "createComposite.m"

eventBin = [round(params.eventWindow(1)/params.interpValue):...
round(params.eventWindow(2)/params.interpValue)];   % Bins to use before 
                                                    % and after events. 
events.bin
                                                    
                                                    
composite = createComposite(2,[
                                                    
                                                    
composite1 = createComposite(nEventSeries1,events1,nEvents1,nBins,...
    response.n,response.x,eventBin,response.residuals);

composite2 = createComposite(nEventSeries2,events2,nEvents2,nBins,...
    response.n,response.x,eventBin,response.residuals);


%% Derive bootstrapped confidence intervals for each composite record.
    
nBoot = 10000;

mearesponse.n_i_1 = NaN*ones(nBoot,nBins,response.n,nEventSeries1);

for i = 1:nBoot  
    % Create random response series
    blk=5; %PVD Edit; Establishes size for block resampling
    tempLength=(length(response.residuals)-blk); %PVD Edit; 
    recLength=1:(round2(tempLength,blk)); % PVD Edit (Lines 15-16 construct time series of a length that can be shuffled in blocks of 5; i.e.,nearest multiple of 5)
    response.residuals2=response.residuals(recLength,:); %PVD Edit; response.residuals2 is the slightly abbreviated time series used to construct the random distributions
    [trash nRandResponse] = size(response.residuals2);   % Number of response vars.

    
    
    
    rand_composite1 = createFullRandComposite(nEventSeries1,events1,...
        nEvents1,nBins,response.n,response.x,eventBin,response.residuals);

    for l = 1:nEventSeries1
        for k = 1:response.n
            mearesponse.n_i_1(i,:,k,l) = nanmean(rand_composite1(:,:,k,l)); 
        end
    end
end

mearesponse.n_CI_1 = NaN*ones(4,nBins,response.n,nEventSeries1);
for l = 1:nEventSeries1
    for k = 1:response.n
        mearesponse.n_CI_1(:,:,k,l) = prctile(mearesponse.n_i_1(:,:,k,l),...
            [0.5 2.5 97.5 99.5]);
    end
end
%mearesponse.n_i_1%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mearesponse.n_i_2 = NaN*ones(nBoot,nBins,response.n,nEventSeries2);

for i = 1:nBoot    % 
    
    rand_composite2 = createFullRandComposite(nEventSeries2,events2,nEvents2,nBins,...
    response.n,response.x,eventBin,response.residuals);

    for l = 1:nEventSeries2
        for k = 1:response.n
            mearesponse.n_i_2(i,:,k,l) = nanmean(rand_composite2(:,:,k,l)); 
        end
    end
end

mearesponse.n_CI_2 = NaN*ones(4,nBins,response.n,nEventSeries2);
for l = 1:nEventSeries2
    for k = 1:response.n
        mearesponse.n_CI_2(:,:,k,l) = prctile(mearesponse.n_i_2(:,:,k,l),...
           [0.5 2.5 97.5 99.5]);

    end
end
%mearesponse.n_i_2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Figure 4: Time series

y_lim_bc = [-0.4 0.35; -1.7 1.7; -0.1 0.2; -7 4; -0.6 0.3; -0.1 0.3];
y_tick_bc = [-999 -0.2 0 0.2; -999 -1 0 1; -999 -0.1 0 0.1; -999 -4 0 4;...
    -0.4 -0.2 0 0.2; -0.1 0 0.1 0.2];
fs = 10;
figure(2); clf
set(gcf,'color','w','units','centimeters','position',[15 0 12.35 23.35]); 
    subplotIn = [1:6:response.n*6]; % This is: 1 7 13 19 25 31; refers to placement of the time series plot in a figure divided into 24 slots (see bar graphs)

j = 1;
for i = 1:response.n

       subplot(response.n,1,i)
       plot(response.x,response.y(:,i),'k')
       set(gca,'FontSize',fs,'FontWeight','b');
       set(gca,'xdir','rev','tickdir','out')
       box off
       hold on
       axis tight
       y_lim = get(gca,'ylim');
       
       if i == 3 % If C_acc, change y-lim
           ylim([y_lim(1) 1.8])
       end
       
        HSC = events2(events2(:,1+j)>0,1);
        for k = 1:length(HSC)
            plot([HSC(k) HSC(k)],[y_lim(1) 0.90*y_lim(2)],'-r',...
                'linewidth',1)
        end
        LSE = events1(events1(:,1+j)>0,1);
        for k = 1:length(LSE)
             plot([LSE(k) LSE(k)],[y_lim(1) 0.90*y_lim(2)],'--b',...
                 'linewidth',1)
        end           
        h3 = plot(events3(events3(:,1+j)>0,1),...  
            0.90.*y_lim(2).*events3(events3(:,1+j)>0,1+j),'.',...
            'color',[0.5 0.5 0.5]);             
            hold on
            plot(response.x,response.ySm(:,i),'k','linewidth',1.5) ;
        
        if i < response.n
           set(gca,'xticklabel','')
        else
           xlabel('Calibrated years BP','FontSize',fs)
        end
                
        set(gca,'xtick',[0:500:4000],'ticklength',[0.012 0.012]);
        xlim(x_lim)
        ylabel(params.responseName(i))
        pos = get(gca,'position');
        pos(4) = 0.12;
        pos(1) = 0.17;
        set(gca,'position',pos)
        
end

%% Figure 5: SEA results
figure(3); clf
set(gcf,'color','w','units','centimeters','position',[25 0 12.35 23.35]); 
plotIn = [1:2:response.n*2];

for i = 1:response.n
        % (c)
        subplot(response.n,2,plotIn(i)+1)
        set(gca,'tickdir','out');
        box off
        x = eventBin .* params.interpValue;
        y = nanmean(composite1(:,:,i,j));  
       
        y2 = squeeze(composite1(:,:,i,j));
        hold on
        h4 = bar(x,y,1);
        set(h4,'facecolor',[0.5 0.5 0.5],'edgecolor',[0.5 0.5 0.5])
        plot(x,mearesponse.n_CI_1([1],:,i,j),'--k')
        plot(x,mearesponse.n_CI_1([2],:,i,j),'-k')
        plot(x,mearesponse.n_CI_1([3],:,i,j),'-k')
        plot(x,mearesponse.n_CI_1([4],:,i,j),'--k')
        axis tight 
        y_lim = get(gca,'ylim');    
        plot([0 0],y_lim_bc(i,:),'--b','linewidth',1)% Alter this to change blue line 
        set(gca,'ylim',y_lim_bc(i,:),'ytick',y_tick_bc(i,:),...
            'FontSize',fs,'FontWeight','b');
        xlim([-50 50]);
        set(gca,'xtick',[-50:25:50]);
        set(gca,'ticklength',[0.06 0.06]);
        if i == 1
            title({'Lower severity /' 'extra local fires'},'FontSize',fs,'FontWeight','bold')
        end
        pos=get(gca,'position');
        pos(4) = 0.11;
        pos(3) = 0.3347*0.75;
        pos(1) = 0.65;
        set(gca,'position',pos)
     
         if i < response.n
           set(gca,'xticklabel','')           
         else
            set(gca,'xticklabel',{'-50','','0','','50',});
         end

%%%%    (b)
        subplot(response.n,2,plotIn(i))
        x = eventBin .* params.interpValue;
        set(gca,'tickdir','out');
       
        yb = nanmean(composite2(:,:,i,j));   
        y2b = squeeze(composite2(:,:,i,j));
        h5= bar(x,yb,1);
        hold on
        set(h5,'facecolor',[0.5 0.5 0.5],'edgecolor',[0.5 0.5 0.5])
        plot(x,mearesponse.n_CI_2([1],:,i,j),'--k') 
        plot(x,mearesponse.n_CI_2([2],:,i,j),'-k')
        plot(x,mearesponse.n_CI_2([3],:,i,j),'-k')
        plot(x,mearesponse.n_CI_2([4],:,i,j),'--k')
        axis tight
%         y_lim = get(gca,'ylim');
        box off
        set(gca,'ylim',y_lim_bc(i,:),'ytick',y_tick_bc(i,:),...
            'xtick',[-50:25:75],'tickdir','out',...
            'ticklength',[0.06 0.06],'FontSize',fs,'FontWeight','b');
        ylabel(params.responseName(i))
        pos = get(gca,'position');
        pos(4) = 0.11;
        pos(1) = 0.18;
        set(gca,'position',pos)

        if i == 1
%             title('Composite Residual Response','fontsize',7,'fontweight','b')
            title ({'High-severity' 'catchment fires'},'fontweight',...
                'bold','FontSize',fs)
        end
        if i < response.n
           set(gca,'xticklabel','')
       else
            xlabel({' ' '                                                Lag (years)'},...
                'fontsize',fs,'fontweight','b')
            set(gca,'xticklabel',{'-50','','0','','50',''});
        end
        set(gca,'xlim',[-50 75])
        plot([0 0],y_lim_bc(i,:),'r','linewidth',1)

end