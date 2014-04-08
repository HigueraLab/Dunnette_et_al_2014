
% Fig_S1_script.m
%
% Make Figure S1 from:
% Dunnette P.V., P.E. Higuera, K.K. McLauchlan, K.M. Derr, C.E. Briles, 
% M.H. Keefe. 2014. Biogeochemical impacts of wildfires over four millennia 
% in a Rocky Mountain subalpine watershed. New Phytologist Accepted.
%
% Figure S1.  
% Fig. S1. Series-wide Spearman correlation coefficients (r) between selected biogeochemical variables from Chickaree Lake. 
% Reported P-values account for reduced sample sizes due to temporal autocorrelation (see Materials and Methods). 
% 
% Requires the following files: 
%
% Created by: P.V. Dunnette
% Created on: January 2013
% Edited: 4/2014 for publication, by P.V. Dunnette
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu

clear all

%% Set working directories: directories where input data are located
workingDir = 'L:\4_archivedData\Dunnette_et_al_2014_NewPhytologist\CH10_biogeochem\';

startDir = pwd;     % Record starting path

%% Load data and create variables
cd(workingDir)      % Change to working directory
data1 = csvread('CH10_biogeochemData.csv',1,3);
data2 = csvread('CH10_LOI_Data.csv',1,6);
data3 = csvread('CH10_BSiData.csv',1,0);
cd(startDir)

%% Define variables from biogeochemData
YBP1 = data1(1:618,4);
N15 = data1(1:618,6);
N = data1(1:618,7);
C13 = data1(1:618,8);
C = data1(1:618,9); 
CN = data1(1:618,10); 
BD = data1(1:618,11);

%% Define variables from LOI_Data
YBP2 = data2(1:121,1);
N152 = data2(1:121,3); 
N2 = data2(1:121,4);
C132 = data2(1:121,5);
C2 = data2(1:121,6);
CN2 = data2(1:121,7);
BD2 = data2(1:121,8);
LOI550 = (data2(1:121,9))*100; 

%% Define variables from BSiData
YBP3 = data3(1:40,3);
N153=data3(1:40,6);
N3=data3(1:40,7);
C133=data3(1:40,8);
C3=data3(1:40,9);
CN3=data3(1:40,10);
BD3=data3(1:40,11); 
BSi=data3(1:40,5); 

%% Create Figure

figure('Color',[1 1 1]);

%%%% Correlation between LOI550 and %C 
g=subplot(3,3,1)
scatter(C2,LOI550,'.k');
[RHO1,PVAL1]=corr(C2,LOI550,'type','spearman')
ylabel('LOI_5_5_0','fontsize',10,'FontWeight','b');
set(gca,'xTick',[0:15:30],'ytick',[0:25:50],'xlim',[0 30],'ylim',[0 50],'fontsize',10,'FontWeight','b');
axis square
p=get(g,'position');
p(4)=p(4)-0.020;
set(g,'position',p);
title(['r = ' num2str(round(RHO1*100)/100) '; p = ' num2str(round(PVAL1*1000)/1000)],'fontsize',10,'fontweight','b')

%%%% Correlation between N15 and BSi

g=subplot(3,3,2);
scatter(N153,BSi,'.k');
[RHO2,PVAL2]=corr(BSi,N153,'type','spearman'); 
ylabel('BSi (%)','fontsize',10,'FontWeight','b');
set(gca,'xTick',[-0.75:1.75:2.75],'yTick',[16:13:42],'xlim',[-0.75 2.75],'ylim',[16 42],'fontsize',10,'FontWeight','b');
axis square
p=get(g,'position');
p(4)=p(4)-0.020;
set(g,'position',p);
title(['r = ' num2str(round(RHO2*100)/100) '; p = ' num2str(round(PVAL2*1000)/1000)],'fontsize',10,'fontweight','b')

%%%% Correlation between BSi and C13

g=subplot(333);
scatter(BSi,C133,'.k');
[RHO3,PVAL3]=corr(C133,BSi,'type','spearman'); 
ylabel(['\delta^1^3C (' char(8240) ')'],'fontsize',10,'FontWeight','b');
set(gca,'xTick',[16:13:42], 'yTick',[-30:3:-24],'xlim',([16 42],'ylim',[-30 -24],...
    'fontsize',10,'FontWeight','b');
axis square
p=get(g,'position');
p(4)=p(4)-0.020;
set(g,'position',p);
title(['r = ' num2str(round(RHO3*100)/100) '; p = ' num2str(round(PVAL3*1000)/1000)],'fontsize',10,'fontweight','b')

%%%% Correlation between %C and %N 

g=subplot(3,3,4);

scatter(C,N, '.k');
ylabel('N (%)','fontsize',10,'FontWeight','b');
set(gca,'fontsize',10,'FontWeight','b');

set(gca,'xTick',[0:15:30]);
set(gca,'xlim',([0 30]));
set(gca,'yTick',([0:1.25:2.5]));
set(gca,'ylim',([0 2.5]));
axis square
p=get(g,'position');
p(4)=p(4)-0.020;
set(g,'position',p);
[RHO5,PVAL5]=corr(C,N,'type','spearman'); 
%r=gtext(['r=',num2str(RHO5,2)])
%f=gtext(['p=',num2str(PVAL5,2)])
%set(f(1),'FontSize',7,'FontWeight','b')
%set(r(1),'FontSize',7,'FontWeight','b')
title(['r = ' num2str(round(RHO5*100)/100) '; p = ' num2str(round(PVAL5*1000)/1000)],'fontsize',10,'fontweight','b')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


g=subplot(335);

scatter(N15,N,'.k');
%ylabel('% N','fontsize',10,'FontWeight','b');
ylabel('N (%)','fontsize',10,'FontWeight','b');
set(gca,'fontsize',10,'FontWeight','b');
set(gca,'xTick',[-0.75:1.75:2.75]);
set(gca,'yTick',([0:1.25:2.5]));
set(gca,'ylim',([0 2.5]));
set(gca,'xlim',([-0.75 2.75]));
p=get(g,'position'); %left bottom width height
p(4)=p(4)-0.02;
%p(3)=p(3)-0.05
set(g,'position',p);
[RHO1,PVAL1]=corr(N,N15,'type','spearman')
%r=gtext(['r=',num2str(RHO1,2)])
%f=gtext(['p=',num2str(PVAL1,2)])
%set(f(1),'FontSize',7,'FontWeight','b')
% title({['r = ', num2str(RHO1)]; ['p = ',num2str(PVAL1)]})
title(['r = ' num2str(round(RHO1*100)/100) '; p = ' num2str(round(PVAL1*1000)/1000)],'fontsize',10,'fontweight','b')
%set(r(1),'FontSize',7,'FontWeight','b')
axis square

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(336)
scatter(BSi,C3,'.k');
%xlabel('% C','fontsize',10,'FontWeight','b');
ylabel('C (%)','fontsize',10,'FontWeight','b');
set(gca,'fontsize',10,'FontWeight','b');
set(gca,'yTick',[8:10:28]);
set(gca,'xTick',[16:13:42]); 
set(gca,'xlim',([16 42]));
set(gca,'ylim',([8 28]));
p=get(g,'position');
p(4)=p(4)-0.020;
set(g,'position',p);
axis square
[RHO6,PVAL6]=corr(C3,BSi,'type','spearman'); 
%r=gtext(['r=',num2str(RHO6,2)])
%f=gtext(['p=',num2str(PVAL6,2)])
%set(f(1),'FontSize',7,'FontWeight','b')
%set(r(1),'FontSize',7,'FontWeight','b')
title(['r = ' num2str(round(RHO6*100)/100) '; p = ' num2str(round(PVAL6*1000)/1000)],'fontsize',10,'fontweight','b')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(337);
scatter(C,CN,'.k');
ylabel('C:N','fontsize',10,'FontWeight','b');
xlabel('C(%)','fontsize',10,'FontWeight','b');

set(gca,'fontsize',10,'FontWeight','b');

set(gca,'xlim',([0 30]));
set(gca,'xTick',[0:15:30]);


set(gca,'yTick',[8:10:28]);
set(gca,'ylim',([8 28]));
axis square
p=get(g,'position');
p(4)=p(4)-0.020;
set(g,'position',p);
[RHO7,PVAL7]=corr(C,CN,'type','spearman'); 
%r=gtext(['r=',num2str(RHO7,2)])
%f=gtext(['p=',num2str(PVAL7,2)])
%set(f(1),'FontSize',7,'FontWeight','b')
%set(r(1),'FontSize',7,'FontWeight','b')
title(['r = ' num2str(round(RHO7*100)/100) '; p = ' num2str(round(PVAL7*1000)/1000)],'fontsize',10,'fontweight','b')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

g=subplot(338);

scatter(N15,CN,'.k');
ylabel('C:N','fontsize',10,'FontWeight','b'); 
set(gca,'fontsize',10,'FontWeight','b');
set(gca,'yTick',[8:10:28]);
set(gca,'ylim',([8 28]));
set(gca,'xTick',[-0.75:1.75:2.75]);
set(gca,'xlim',([-0.75 2.75]));
xlabel(['\delta^1^5N (' char(8240) ')'],'fontsize',10,'FontWeight','b');

p=get(g,'position'); %left bottom width height
p(4)=p(4)-0.02;
%p(3)=p(3)-0.05
set(g,'position',p);
[RHO1,PVAL1]=corr(CN,N15,'type','spearman'); 
%r=gtext(['r=',num2str(RHO1,2)])
%f=gtext(['p=',num2str(PVAL1,2)])
%set(f(1),'FontSize',7,'FontWeight','b')
% title({['r = ', num2str(RHO1)]; ['p = ',num2str(PVAL1)]})
title(['r = ' num2str(round(RHO1*100)/100) '; p = ' num2str(round(PVAL1*1000)/1000)],'fontsize',10,'fontweight','b')
%set(r(1),'FontSize',7,'FontWeight','b')
axis square

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=subplot(339);

scatter(BSi,CN3,'.k');
xlabel('BSi (%)','fontsize',10,'FontWeight','b');
ylabel('C:N','fontsize',10,'FontWeight','b');
set(gca,'fontsize',10,'FontWeight','b');
set(gca,'yTick',[10:6:28]);
set(gca,'xTick',[16:13:42]); 
set(gca,'xlim',([16 42]));
set(gca,'ylim',([10 22]));
p=get(g,'position');
p(4)=p(4)-0.020;
set(g,'position',p);
axis square
[RHO8,PVAL8]=corr(BSi, CN3,'type','spearman'); 
%r=gtext(['r=',num2str(RHO8,2)])
%f=gtext(['p=',num2str(PVAL8,2)])
%set(f(1),'FontSize',7,'FontWeight','b')
%set(r(1),'FontSize',7,'FontWeight','b')
title(['r = ' num2str(round(RHO8*100)/100) '; p = ' num2str(round(PVAL8*1000)/1000)],'fontsize',10,'fontweight','b')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

