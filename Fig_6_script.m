% Fig_6_script.m
% 
% Make Figure 6 from:
% Dunnette P.V., P.E. Higuera, K.K. McLauchlan, K.M. Derr, C.E. Briles, 
% M.H. Keefe. 2014. Biogeochemical impacts of wildfires over four millennia 
% in a Rocky Mountain subalpine watershed. New Phytologist Accepted.
%
% Figure 6. Relationships between charcoal peak magnitude and the proxy 
% responses following high-severity catchment fires. Pearson correlation 
% coefficients (r) were calculated using the log-transformed peak magnitude
% of each fire event and mean residual response variable values ~0-20 years
% (left column) and ~20-50 years (right column) after each event. Bulk 
% density is abbreviated by “BlkDens.”
%
% FILE REQUIREMENTS:
%   (1) CH10_biogeochemData.csv -- Biogeochemcial data from Chickaree Lk.
%   (2) CH10_charResults.csv -- CharAnalysis results from Chickaree Lk.

% DEPENDENCIES: 
%
% CITATION, FILES, AND SELF-AUTHORED FUNCTIONS AVAILABLE FROM FigShare
%   Higuera, Philip E.; Dunnette, Paul V.; al., et (2014): Data, code, and 
%   figures from Dunnette et al. 2014. figshare. 
%   http://dx.doi.org/10.6084/m9.figshare.988687
%
% Created by: P.V. Dunnette
% Created on: March, 2013
% Updated: May, June, 2013, by PVD
% Edited: 25 Jan., 2013, by P.E. Higuera
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu

clear all

%% Set working directories: directories where input data are located
workingDir = 'L:\4_archivedData\Dunnette_et_al_2014_NewPhytologist\CH10_biogeochem\';
workingDir2 = 'L:\4_archivedData\Dunnette_et_al_2014_NewPhytologist\CH10_c\';
startDir = pwd;     % Record starting path


%% Load input data

cd(workingDir)      % Change to working directory
data = csvread('CH10_biogeochemData.csv',1,3);

YBP = mean(data(:,4:5),2); % Uses midpoint of top and bottom year
Params = data(:,6:13);
N15 = data(:,6);
N = data(:,7);
C13 = data(:,8);
C = data(:,9);
CN = data(:,10);
BD = data(:,11);
CAR = data(:,13);
NAR = data(:,12);
int = 5;        
yrMin = -57;
yrMax = 4300;   % T     

%Interpolate data  %
YBPi = (yrMin:int:yrMax)';
IntParams = interp1(YBP,Params(:,1:8),YBPi); %Interpolated Time Series
N15i = IntParams(:,1);
Ni = IntParams(:,2);
C13i = IntParams(:,3);
Ci = IntParams(:,4);
CNi = IntParams(:,5);
BDi = IntParams(:,6);
NARi = IntParams(:,7);
CARi = IntParams(:,8);

%Smooth data
SmWind =  500;
[Pershing nParams] = size(IntParams(:,1:8));  
SmParams=NaN*ones(size(IntParams)); %Smoothed Time Series
for i= 1:nParams
    SmParams(:,i)=smooth(IntParams(:,i),SmWind/int,'rlowess');      
end
ResParams = IntParams-SmParams; %Residual Time Series 

N15r=ResParams(:,1);Nr=ResParams(:,2);C13r=ResParams(:,3);Cr=ResParams(:,4);CNr=ResParams(:,5);BDr=ResParams(:,6); NARr=ResParams(:,7); CARr=ResParams(:,8); %ID Parameters for analysis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% charData = csvread('C:\Users\Paul Dunnette\Desktop\analysis\CH10_charResults.csv',1,0); % charAnalysis results
charData = csvread('L:\1_projectsData\CO_RMNP_project\Analysis\1_Lakes\CH10\charcoal\Dunnette_et_al_charcoal\CH10_charResults.csv',1,0);

PeakMag=charData(:,21); %Peak magnitudes for 0.999 threshold fires
PkMags=log(PeakMag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%checked 9/26/2013. Good. 
EventYr=[161 960 1243 2124 2670 2752 2913 3262 3725 3803 4156]' ;%Fire years (coincident, high-res peaks); Checked 11/23
ind=[23 102 131 219 274 282 297 333 379 386 422]' ;% Index for CHAR values ; Checked 11/23

%For correlation/regression analysis:
CharPks=PkMags(ind); %For correlation analysis 
PlotPks=PeakMag(ind); % For Plotting

P1=N15r;  P2=BDr;  P3=Cr ; P4=Nr; P5=CNr ; %Choose parameters
Pars=[P1 P2 P3 P4 P5]; %Parameter Matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds biogeochemcial samples matching coincident peak event years

nYBPi=length(YBPi);

nEventYr=length(EventYr);                
Index=NaN*ones(nEventYr,1);             
for k = 1:nEventYr                                         
        Index(k,:) = find(abs(YBPi- EventYr(k)) ==...
            min(abs(YBPi - EventYr(k))));
end       
nIndex=length(Index); %Index is good. 11/25/2013.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response 0-20 yr Post-Fire

EventBin1 = -3:0 ;      %Sampling window (negative=post-fire)
nBins = length(EventBin1);   
[Thorson nPars]=size(Pars)  ; % Matrix Size

meanResp1=NaN*ones(nIndex,nPars); %Matrix with 11 rows, 4 columns
    for h=1:nIndex % for each of the events....n=11
        sampleIn1=Index(h)+EventBin1; % 
        temp_a=(Pars(sampleIn1,:)); % columns are time steps, rows are variables.
        meanResp1(h,:)= mean(temp_a);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Response 20-50 yr Post-Fire

EventBin2 = -9:-4;      %Sampling window (negative=post-fire)
nBins = length(EventBin2);   
[Joseph nPars]=size(Pars)  ; % Matrix Size

meanResp2=NaN*ones(nIndex,nPars); %Matrix with 11 rows, 4 columns
   for i=1:nIndex % for each of the events....n=11
       sampleIn2=Index(i)+EventBin2; % 
       temp_b=(Pars(sampleIn2,:));
       meanResp2(i,:)= mean(temp_b);
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate pearson correlation coefficients

[RHO1,PVAL1]=corr(CharPks,(meanResp1(:,1)),'type','pearson'); 
[RHO2,PVAL2]=corr(CharPks,(meanResp1(:,2)),'type','pearson'); 
[RHO3,PVAL3]=corr(CharPks,(meanResp1(:,3)),'type','pearson'); 
[RHO4,PVAL4]=corr(CharPks,(meanResp1(:,4)),'type','pearson'); 
[RHO5,PVAL5]=corr(CharPks,(meanResp1(:,5)),'type','pearson'); 

[RHO6,PVAL6]=corr(CharPks,(meanResp2(:,1)),'type','pearson'); 
[RHO7,PVAL7]=corr(CharPks,(meanResp2(:,2)),'type','pearson'); 
[RHO8,PVAL8]=corr(CharPks,(meanResp2(:,3)),'type','pearson');
[RHO9,PVAL9]=corr(CharPks,(meanResp2(:,4)),'type','pearson'); 
[RHO10,PVAL10]=corr(CharPks,(meanResp2(:,5)),'type','pearson');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plot Results

figure(1); clf; 
set(gcf,'color','w','units','centimeters','position',[5 0 11 20]); 
fs = 10;
%15N, 0-20 yr post-fire
g=subplot(521);
x=PlotPks; y=(meanResp1(:,1));  
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
ylim([-0.75 0.75]);
set(gca,'ytick',[-0.7:0.7:0.7]);
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
ylabel(['\delta^1^5 N (' char(8240) ')'],'FontSize',fs,'FontWeight','b')
title({['r = ' num2str(round(RHO1*100)/100) '; p = ' num2str(round(PVAL1*1000)/1000)]},'FontSize', fs-2)%'fontweight','b')
text(100,1.45,'0-20 yr postfire','HorizontalAlignment','Center',...
    'FontSize',fs,'FontWeight','bold');
axis square
p=get(g,'position');
p(4)=p(4)-0.0125;
p(1)=p(1)+0.080;
set(g,'position',p);
set(gca,'xticklabel',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(522);
x=PlotPks; y=(meanResp2(:,1));
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
set(gca,'Xscale','log');
xlim([10^0 10^4]);
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
ylim([-0.7 0.3]);
set(gca,'ytick',[-0.6:0.4:0.2]);
title({['r = ' num2str(round(RHO6*100)/100) '; p = ' num2str(round(PVAL6*1000)/1000)]},'FontSize', fs-2);
text(100,0.765,'20-50 yr postfire','HorizontalAlignment','Center',...
    'FontSize',fs,'FontWeight','bold');
axis square
p=get(g,'position');
p(4)=p(4)-0.0125;
set(g,'position',p);
set(gca,'xticklabel',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(523);
x=PlotPks; y=(meanResp1(:,5)); % This is C:N
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
%hold on
%plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
ylabel('C:N','FontSize',fs,'FontWeight','b')
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO5*100)/100) '; p = ' num2str(round(PVAL5*1000)/1000)],'FontSize', fs-2);
set(gca,'xticklabel',[]);
axis square
ylim([-3 3]);
set(gca,'ytick',[-2:2:2]);
p=get(g,'position');
p(4)=p(4)-0.0125;
p(1)=p(1)+0.080;
set(g,'position',p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(524);
x=PlotPks; y=(meanResp2(:,5)); 
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO10*100)/100) '; p = ' num2str(round(PVAL10*1000)/1000)],'FontSize', fs-2);
set(gca,'xticklabel',[]);
axis square
ylim([-4 2]);
set(gca,'ytick',[-3:2:1]);
p=get(g,'position');
p(4)=p(4)-0.0125;
set(g,'position',p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(525);
x=PlotPks; y=(meanResp1(:,3));
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
ylabel('C (%)','FontSize',fs,'FontWeight','b')
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO3*100)/100) '; p = ' num2str(round(PVAL3*1000)/1000)],'FontSize', fs-2);
axis square
p=get(g,'position');
p(4)=p(4)-0.0125;
p(1)=p(1)+0.080;
set(gca,'xticklabel',[]);
set(g,'position',p);
ylim([-10 4]);
set(gca,'ytick',[-9:6:3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(526);
x=PlotPks; y=(meanResp2(:,3)); 
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO8*100)/100) '; p = ' num2str(round(PVAL8*1000)/1000)],'FontSize', fs-2)
axis square
p=get(g,'position');
p(4)=p(4)-0.0125;
set(gca,'xticklabel',[]);
set(g,'position',p);
ylim([-9 5]);
set(gca,'ytick',[-8:6:4]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(527);
x=PlotPks; y=(meanResp1(:,4));
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
ylabel('N (%)','FontSize',fs,'FontWeight','b')
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO4*100)/100) '; p = ' num2str(round(PVAL4*1000)/1000)],'FontSize', fs-2)%'fontweight','b')
axis square
ylim([-0.8 0.4]);
set(gca,'ytick',[-0.7:0.5:0.3]);
p=get(g,'position');
p(4)=p(4)-0.0125;
p(1)=p(1)+0.080;
set(gca,'xticklabel',[]);
set(g,'position',p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(528);
x=PlotPks; y=(meanResp2(:,4));
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO9*100)/100) '; p = ' num2str(round(PVAL9*1000)/1000)],'FontSize', fs-2);
axis square
ylim([-0.5 0.3]);
set(gca,'ytick',[-0.4:0.3:0.2]);
set(gca,'xticklabel',[]);
p=get(g,'position');
p(4)=p(4)-0.0125;
set(g,'position',p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(529);
x=PlotPks; y=(meanResp1(:,2));
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
ylabel({'BlkDens' ;'(g cm^-^3)'},'FontSize',fs,'FontWeight','b')
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO2*100)/100) '; p = ' num2str(round(PVAL2*1000)/1000)],'FontSize', fs-2)%,'fontweight','b')
ylim([-0.2 0.6]);
set(gca,'ytick',[-0.1:0.3:0.5]);
axis square
p=get(g,'position');
p(4)=p(4)-0.0125;
p(1)=p(1)+0.080;
set(g,'position',p);
xlabel('                                            Charcoal peak magnitude (# cm^{-2})','FontSize',fs,'FontWeight','b')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(5,2,10);
x=PlotPks; y=(meanResp2(:,2));
b=regress(y,[ones(size(x)),log(x)]);
xHat=[min(log(x)), max(log(x))];
yHat=b(1)+b(2).*xHat;
plot(x,y,'ok')
hold on
plot(exp(xHat),yHat,'-k')
set(gca,'Xscale','log');
xlim([10^0 10^4]);
set(gca,'FontSize', fs,'FontWeight','b'); 
set(gca,'TickDir','out')
set(gca,'box', 'off');
title(['r = ' num2str(round(RHO7*100)/100) '; p = ' num2str(round(PVAL7*1000)/1000)],'FontSize', fs-2)%'fontweight','b')
ylim([-0.06 0.12]);
set(gca,'ytick',[-0.05:0.08:0.11]);
axis square
p=get(g,'position');
p(4)=p(4)-0.0125;
set(g,'position',p);
