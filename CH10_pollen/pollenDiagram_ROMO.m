function [CHAR,char_ybp,pol_dat,pol_ybp,pol_sum] =...
    pollenDiagram_ROMO(site,pollen_counts,pollen_cm,pollen_ybp,taxa_for_sum,...
	taxa,taxa_plot,char_counts,char_peak_id,peaks,ybp_start,ybp_stop,...
    transform,scdv,p_analog,zd,szd,printing)
% function [CHAR,char_ybp,pol_dat,pol_ybp] =...
%     plot_pollen_char_peaks(site,age_depth_data,pollen_counts,pollen_cm,...
% 	taxa,taxa_plot,char_counts,char_peak_id,ybp_start,ybp_stop,peaks,...
%     transform);
% This function plots pollen and charcoal data horizontally as a function
% of time. It requires the following variables:
%
% site -- site name
% age_depth_data -- look-up table with the depth in the first column and age 
%    in the second column for each sample of a core
% pollen_cm -- vector with depths of pollen samples
% pollen_counts -- matrix with pollen counts for each taxa (i) and 
%     sample (j)
% taxa -- matrix with the taxa code (j=1) and taxa name (j=2) for each
%     taxa in pollen_counts
% char_counts -- vector of charcoal concentrations
% char_peak_id -- matix from CHAR_analysis.m with charcoal peak location
% and background CHAR data.

% SET-UP PARAMETERS:

p_analog_data = 0;  % 1 if you have probability of analog values already,
                    % else, 0.
if transform == 1
gs = 0.006;%0.01;   % value controlling vertical spaces between graphs
hm = 0.005;%;0.01;%0.0022;  % height multiplier to calculate height of each graph
else 
gs = 0.006;%0.01;   % value controlling vertical spaces between graphs
hm = 0.0008;%051;%0.0015;
end
LP = 0.12;          % left position for graphs
if max(ybp_start)>7200
TF = 1.2*2.8e-005;  % time factor, for scaling width of graphs (make 
                    % bigger to make graphs wider)
elseif max(ybp_start)<=7200 & max(ybp_start)>2000
TF = 2.0*2.25e-005; % Was 2.0, changed to 1.5; 15 Sept., 2009, PEH.      
else
    TF = 3.5*2.25e-005;       
end
   
LW = 1.0;           % line width for plots
FS = 8;             % font size for tick labels
FW = 'bold';        % font weight for titles 
face_color = [.75 .75 .75];     % color for fill in graphs
bs = 0.9;           % bottom position for spruce graph (top)
plot_char = 0;      % 1 if you want to plot charcoal, else 0

%% RETRIEVE VARIABLES FROM INPUT FILES:
age_depth_data = char_counts(:,[1 3]);  % Make age-depth vectors.
char_cm = char_counts(find(char_counts(:,1)>-99),1);  % [cm] charcoal depths
char_num = char_counts(find(char_counts(:,6)>-99),6); % [#] charcould counts
char_vol = char_counts(find(char_counts(:,5)>-99),5); % [cm^3] charcould vol.
char_con = char_num./char_vol; % [#/cm3] charcoal conc.
char_ybp = age_depth_data(:,2);	% age_depth values should come from charcoal 
							% sample depth
%% Create space for variables:
pol_dat = zeros(length(taxa)-7,length(pollen_cm),3);  % space for pollen 
                    % percentage values (:,:,1)
                    % space for pollen concentration values (:,:,2)
                    % [grains/cm3] 
                    % space for PAR values [grains/cm2/yr)
pol_ybp = zeros(length(pollen_cm),1);  % space for age of each pollen sample
acc = zeros(length(age_depth_data),1); % space for sediment accumulation rate          

%% DERIVE VARIABLES:

acc = [char_counts(:,2)-char_counts(:,1)]./[char_counts(:,4)-char_counts(:,3)];
    % [cm/yr] sediment accumulation rate

if peaks == 0
    CHAR = char_con.*acc;  % [#/cm2/yr] take sediment accumulation rate, acc, 
    % and multiply by charcoal concentration to get CHAR 
else
    CHAR = char_peak_id(:,3);
    char_ybp = char_peak_id(:,2);
end
% TURNED THIS OFF FOR "ROMO" VERSION. 
% taxa_for_sum = [8:35]; % index for taxa to use in pollen sum
pol_sum = [sum(pollen_counts(taxa_for_sum,:))];
                    % calculates pollen sum to obtain percentage values
                    % Change these number if you want to change the taxa
                    % included in the pollen sum                   
for met = 1:3;      % for each metric of pollen: %, concentration, PAR
    for j=1:length(pollen_cm)
        for i=1:length(pol_dat)
        if met == 1
        pol_dat(i,j,met) = (pollen_counts(i,j) ./ pol_sum(j)) * 100;
        % pollen percent is the pollen count divided by pollen sum,
        % multiplied by 100
        end
        if met == 2
          pol_dat(i,j,met) = ((pollen_counts(2,j)*pollen_counts(3,j))*...
              pollen_counts(i,j))/pollen_counts(5,j);
        % X_con = (EU_tot * X_count) / EU_count --> based on the ratio
        % EU_count:EU_tot = X_count:X_tot
        end
        if met == 3
        pol_dat(i,j,met) = pol_dat(i,j,2).*acc(find(age_depth_data(:,1)==...
            pollen_cm(j)));
        % pol_con multiplied by the accumulation rate (acc) of the sample
        % with the same depth value as the pollen sample = PAR
        end
        end
    end
end

pol_dat(:,:,2) = pol_dat(:,:,2)./10000; % divide concentrations by 10k for
                                        % plotting
pol_dat(:,:,3) = pol_dat(:,:,3)./100; % divide PAR data by 100 for plotting

for i = 1:length(pol_ybp)
    [in] = age_depth_data(:,1)==pollen_cm(i);
    pol_ybp(i)= age_depth_data(in,2);
end
%%%%%%%%%%%%%%%%%%%%
if transform == 1 
pol_dat(:,:,1) = sqrt(1+pol_dat(:,:,1));
%CHAR = log(CHAR+1);% turned off option to log-transform CHAR 1/25/06 PEH
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATE GRAPHS:
% First plot pine
for met = 1:1;%3   % for each metric of pollen: %, concentration, PAR
figure (met);clf; set(gcf,'color','w')
set(gcf,'Units','normalized')
p_vect = NaN*ones(length(taxa_plot),4); % positioning vector for graphs
i = 1;
subplot(length(taxa_plot)+5,1,2);
if transform == 0
h = area(pol_ybp,sum(pol_dat(1:3,:,met)));% total pollen
set(h(1),'FaceColor',face_color);
hold on;
% plot(pol_ybp,5*sum(pol_dat(2:4,:,met)),'Color',[.75 .75 .75],...
%     'LineWidth',.5); % 5 x %
bar(pol_ybp,sum(pol_dat(1:3,:,met)),0.001); % bar graph of same data

    y_label = {'percent of pollen sum', 'pollen concentration (x 10k grains cm^-^3)',...
    'pollen accumulation rate (x 100 grains cm^-^2 yr^-^1)'};
else    % transform == 1
    if met == 1
        h = area(pol_ybp,sqrt(1+pol_dat(11,:,met).^2-1));
        set(h(1),'FaceColor',face_color);
        % total spruce pollen 
        hold on;
        bar(pol_ybp,sqrt(1+pol_dat(11,:,met).^2-1),0.001); 
        % bar graph of same data

    y_label = {'sqrt. percent of pollen sum',...
        'pollen concentration (x 10k grains cm^-^3)',...
    'pollen accumulation rate (x 100 grains cm^-^2 yr^-^1)'};
    else
        h = area(pol_ybp,sqrt(pol_dat(11,:,met).^2));
        set(h(1),'FaceColor',face_color);
        % total spruce pollen *untransformed the pollen data, summed all
        % spruce, then transformed pollen data back*
        hold on;
        bar(pol_ybp,sqrt(pol_dat(11,:,met).^2),0.001); 
        % bar graph of same data

        y_label = {'sqrt. percent of pollen sum',...
        'pollen concentration (x 10k grains cm^-^3)',...
        'pollen accumulation rate (x 100 grains cm^-^2 yr^-^1)'};
    end
end

in = find(pol_ybp == (max(pol_ybp(pol_ybp <= ybp_start))));
        % index for the oldest pollen sample that's < ybp_start
y_max = 1.1*max(sum(pol_dat(1:3,1:in,met))); % maximum y value
% if met == 1 y_max = 80; end
p_vect(i,1) = LP;       % left positioning
p_vect(i,2) = bs;       % bottom positioning = constant for first plot
p_vect(i,3) = (ybp_start-ybp_stop)*TF; % width of graph is a 
                        % function of how much time is displayed
p_vect(i,4) = (y_max/1.1)*hm;  % height of graph is a 
                        % function of max pollen value

if transform == 1 && met == 1
    axis([ybp_stop ybp_start 1 y_max]); % xmin, xmax, ymin, ymax for graph
else
    axis([ybp_stop ybp_start 0 y_max]); % xmin, xmax, ymin, ymax for graph
end
set(gca,'Position',p_vect(i,:),'XDir','reverse',...
    'XTick',[0:1000:ybp_start],'XTickLabel',{''},'TickDir','out',...
    'XMinorTIck','on','YMinorTick','off','FontSize',FS)
% position of each plot based on p_vect
    % reverse order the x-axis; label X-axis every 1000 years; 
    % turn off-x-axis tick labels on all plots; make tick marks go out
    % turn on minor tick marks
    if met == 1
    if transform == 1
        if y_max < 5
            %set(gca,'ytick',[1:5:y_max],'yticklabel',{' ','5','10'})
            set(gca,'ytick',[1:5:y_max],'yticklabel',{' ','5','10'})
        else
            set(gca,'ytick',[0:5:y_max],'yticklabel',{' ','5','10'})
        end
    else
            set(gca,'ytick',[0 20:20:y_max],'yticklabel',...
               {'','20','40','60','80'},'YMinorTick','off')   
    end
    end
     ylabel(taxa([taxa_plot(i)]),...
    'VerticalAlignment','middle','HorizontalAlignment','right',...
    'FontAngle','italic','FontWeight',FW,'FontSize',FS,'rotation',0)    
% text(ybp_start-0.1*ybp_start,y_max,taxa([taxa_plot(i)],1),...
%     'VerticalAlignment','middle','HorizontalAlignment','left',...
%     'FontAngle','italic','FontWeight',FW,'FontSize',FS)
    % title for each graph taken from 'taxa' matrix, placed at the top left
title(site,'FontSize',FS,'VerticalAlignment','bottom',...
    'FontWeight',FW,'BackgroundColor','w');   % set and place site name
box
end

%% Now plot the rest of the taxa
for met = 1:1%3
figure (met)
for i = 2:length(taxa_plot)
subplot(length(taxa_plot)+5,1,i)
h = area(pol_ybp,pol_dat(taxa_plot(i),:,met));% total pollen
set(h(1),'FaceColor',face_color);
hold on
% plot(pol_ybp,5*pol_dat(taxa_plot(i),:,met),'Color',[.75 .75 .75],...
%     'LineWidth',.5); % 5 x %; % 5 x %
bar(pol_ybp,pol_dat(taxa_plot(i),:,met),0.001); % bar graph of same data
      in = find(pol_ybp == (max(pol_ybp(pol_ybp <= ybp_start))));
        % index for the oldest pollen sample that's < ybp_start
y_max = 1.1*max(pol_dat(taxa_plot(i),1:in,met)); % maximum y value
p_vect(i,1) = LP;     % left positioning = constant

p_vect(i,3) = (ybp_start-ybp_stop)*(TF); % width of graph is a 
                        % function of how much time is displayed

p_vect(i,4) = (y_max/1.1);  % height of graph is a 
                        % function of max pollen value
                        
% Use lines below if you want to scale each y-axis differently
if max(pol_dat(taxa_plot(i),:,met))>100;%(1.1*max(sum(pol_dat(1:3,:,met))))
p_vect(i,4) = ((y_max/1.1)*hm)/2;% height of graph is a 
                        % function of max pollen value
else
p_vect(i,4) = (y_max/1.1)*hm;  % height of graph is a 
                        % function of max pollen value

        if y_max/1.1 < 20    % if < 20% for this taxa
            p_vect(i,4) = 20*hm; % make graph for a value of 20%
            y_max = 1.1*20; % maximum y value
        end
end
p_vect(i,2) = (p_vect(i-1,2)-p_vect(i,4))-gs;
                  % bottom positioning is a function of the previous graph
if transform == 1 & met == 1
    axis([ybp_stop ybp_start 1 y_max]); % xmin, xmax, ymin, ymax for graph
else
    axis([ybp_stop ybp_start 0 y_max]); % xmin, xmax, ymin, ymax for graph
end
set(gca,'Position',p_vect(i,:),'XDir','reverse',...
    'XTick',[0:1000:ybp_start],'XTickLabel',{''},'TickDir','out',...
    'XMinorTIck','on','YMinorTick','on','FontSize',FS) 
    % position of each plot based on p_vect
    % reverse order the x-axis; label X-axis every 1000 years; 
    % turn off-x-axis tick labels on all plots; make tick marks go out
    % turn on minor tick marks
if i == round(length(taxa_plot)/2)
    if ybp_start > 8000
    text(ybp_start*1.15,round(y_max/2),...
        char(y_label(met)),'FontSize',FS,'FontWeight',FW,'rotation',90,...
        'VerticalAlignment','middle','HorizontalAlignment','center');
    end
    if ybp_start < 2501 & ybp_start 
        text(1.5*ybp_start,round(y_max/2),...
        char(y_label(met)),'FontSize',FS,'FontWeight',FW,'rotation',90,...
        'VerticalAlignment','middle','HorizontalAlignment','center');
    %ylabel(char(y_label(met)),'FontSize',FS,'FontWeight',FW);
    end
    if  ybp_start <= 8000 & ybp_start > 2500
        text(1.4*ybp_start,round(y_max/2),...
        char(y_label(met)),'FontSize',FS,'FontWeight',FW,'rotation',90,...
        'VerticalAlignment','middle','HorizontalAlignment','center');
    end
end
    if met == 1
    if transform == 1
        if y_max < 5
            set(gca,'ytick',[0:4],'yticklabel',{' ',' ','2',' ',' '})
        else
            set(gca,'ytick',[0:5:y_max],'yticklabel',{' ','5','10'})
        end
    else
        if y_max < 56
            set(gca,'ytick',[0 20:20:y_max],'yticklabel',...
               {'','20','40'},'YMinorTick','off')
        else
            set(gca,'ytick',[0 20:20:y_max],'yticklabel',...
                {'','20','','60','','100','','140','',''},'YMinorTick','off')
        end        
    end
    end
    
% title for each graph taken from 'taxa' matrix, placed at the top left
    if taxa_plot(i) ~= 43 && taxa_plot(i) ~= 42 
     ylabel(taxa([taxa_plot(i)]),...
    'VerticalAlignment','middle','HorizontalAlignment','right',...
    'FontAngle','italic','FontWeight',FW,'FontSize',FS,'rotation',0) 
    else
    ylabel(taxa([taxa_plot(i)]),...
    'VerticalAlignment','middle','HorizontalAlignment','right',...
    'FontWeight',FW,'FontSize',FS,'rotation',0) 
    end
box
end

%% Now plot total PAR or concentration on all graphs
tot_PAR = sum(pol_dat(taxa_for_sum,:,3));   % total PAR
tot_con = sum(pol_dat(taxa_for_sum,:,2));    % total pol. concentration
y = tot_PAR;
label = {'     total PAR';' (x 100 grains';'cm^-^2 yr^-^1)'};%{'x 10k grains';'cm^-^3'}; %
in = i+1;
subplot(length(taxa_plot)+5,1,in)
h = area(pol_ybp,y);% [grains cm^-2 yr^-1] tot. PAR
set(h(1),'FaceColor',face_color);
hold on;
bar(pol_ybp,y,0.001); % bar graph of same data
axis([ybp_stop ybp_start 0 max(y)]); % xmin, xmax, ymin, ymax
par_vect(1,1) = LP;     % left positioning = constant
par_vect(1,3) = (ybp_start-ybp_stop)*TF; % width of graph is a 
                        % function of how much time is displayed
par_vect(1,4) = (.04);    % height of graph
par_vect(1,2) = (p_vect(i,2)-par_vect(1,4))-gs;
set(gca,'Position',par_vect,'XDir','reverse','YTick',[0:50:200],...
    'XTick',[0:1000:ybp_start],'XTickLabel',{''},'TickDir','out',...
    'XMinorTIck','on','YMinorTick','off','FontSize',FS) 
if max(y)>100
    set(gca,'YTickLabel',{'','','100','','200'},'YMinorTick','off')
end

ylabel(char(label),'FontSize',FS,'FontWeight',FW,'VerticalAlignment',...
    'middle','HorizontalAlignment','right',...
    'FontWeight',FW,'FontSize',FS,'rotation',0)
box

%% Now plot SCD and analog results
if length(scdv)>1
symbol = ['d','s','^'];
color_in = [1 1 1; 0 0 0; .5 .5 .5];
% color_in = [0.49 1 0.83; 0 .6 0; .5 .5 .5;];   % colors for color
plot_in = [2 3 1];
veg_compare = [1 2 7];  % index values in mod_veg_codes identifying the
in = i+1;
for p_in = 1:3;
subplot(length(taxa_plot)+5,1,in)
if p_analog_data == 1
semilogy(pol_ybp,scdv(:,plot_in(p_in)),char(symbol(plot_in(p_in))),'linestyle',...
    '-','color','k','markerfacecolor',color_in(plot_in(p_in),:),...
    'markeredgecolor','k','markersize',4)
end
hold on
if p_in == 3
%legend ('acrtcic tundra','boreal forest','forest-tundra')
scd_vect(1,1) = LP;     % left positioning = constant
scd_vect(1,3) = (ybp_start-ybp_stop)*TF; % width of graph is a 
                        % function of how much time is displayed
scd_vect(1,4) = (.075);    % height of graph
scd_vect(1,2) = (par_vect(1,2)-scd_vect(1,4))-0.01;     % y-positioning of graph
set(gca,'Position',scd_vect(1,:),'XDir','reverse','YTick',[0.01 0.1],...
    'YTickLabel',[0.01 0.1],'XTick',[0:1000:ybp_start],'XTickLabel',...
    {''},'TickDir','out','XMinorTIck','on','YMinorTick','on','FontSize',FS) 
    % position of each plot based on p_vect;
    % reverse order the x-axis; label X-axis every 1000 years; 
    % turn off-x-axis tick labels on all plots; make tick marks go out
    % turn on minor tick marks
ylim ([0.01 1])
box off
ylabel('SCD','fontsize',FS,'fontweight',char(FW),'VerticalAlignment',...
    'middle','HorizontalAlignment','right',...
    'FontWeight',FW,'FontSize',FS,'rotation',0)
xlim ([ybp_stop ybp_start])
if ybp_start < 11000 %& ybp_start > 2500
legend ({'Zone 1','Zone 2','Zone 3','Zone 4'},...
    'fontsize',FS-2,'orientation','horizontal',1)
end
end

subplot(length(taxa_plot)+5,1,in+1)
if p_analog_data == 1
plot(pol_ybp,p_analog(:,plot_in(p_in)),char(symbol(plot_in(p_in))),'linestyle',...
    '-','color','k','markerfacecolor',color_in(plot_in(p_in),:),...
    'markeredgecolor','k','markersize',4)
%plot(pol_ybp,smooth(p_analog(:,plot_in(p_in)),1000/mean(diff(pol_ybp))),'k
%')
end
hold on
if p_in == length(veg_compare)
scd_vect(1,2) =  (scd_vect(1,2)-scd_vect(1,4))-0.01;% y-positioning of graph
set(gca,'Position',scd_vect(1,:),'XDir','reverse','YTickLabel',...
    {'0','0.5',''},'XTick',[0:1000:ybp_start],'XTickLabel',...
    {''},'TickDir','out','XMinorTIck','on','YMinorTick',...
    'on','FontSize',FS) 
    % position of each plot based on p_vect;
    % reverse order the x-axis; label X-axis every 1000 years; 
    % turn off-x-axis tick labels on all plots; make tick marks go out
    % turn on minor tick marks
box off
xlim ([ybp_stop ybp_start])
ylabel ([{'prob. of'}, {'analog '}],'fontsize',FS,...
    'VerticalAlignment','middle','HorizontalAlignment','right',...
    'FontWeight',FW,'FontSize',FS,'rotation',0,'fontweight',char(FW))
end
if ybp_start > 11000
legend ({'Boreal Forest','Forest-tundra','Arctic Tundra'},...
    'fontsize',FS-2,'orientation','horizontal',2)
end
end
else
    scd_vect = par_vect;
end
%% Now make plot for pollen zones
if ybp_start > 5500
in = in+2;
subplot(length(taxa_plot)+5,1,in)
zone_vect(1,1) = scd_vect(1,1);
zone_vect(1,3) = scd_vect(1,3);
zone_vect(1,4) = 0.04;%0.075;   % height of graph
zone_vect(1,2) =  (scd_vect(1,2)-zone_vect(1,4))-gs;% y-positioning of graph
plot(0.0,'.w')
zone_txt = [{'Zone 1'};{'Zone 2'};{'Zone 3'};...
    {'Zone 4'};{'Zone 5'}];   % zone titles
plot([szd szd],[0 1],'--k','color',[.5 .5 .5]);hold on
for z = 2:length(zd)
    if z < length(zd)
        plot([zd(z) zd(z)],[0 1],'-k','color',[.5 .5 .5],'linewidth',2); 
    end
    text(mean(zd(z-1:z)),0.5,char(zone_txt(z-1,:)),'horizontalalignment',...
        'center','fontweight',FW,'fontsize',FS)
end
ylim ([0 1]); xlim ([ybp_stop ybp_start])
box off
ylabel ({'veg.        ';'zone        '},'fontsize',FS,'fontweight',FW,...
    'VerticalAlignment','middle','HorizontalAlignment','right',...
    'FontWeight',FW,'FontSize',FS,'rotation',0)
set(gca,'Position',zone_vect,'XDir','reverse',...
    'XTick',[0:1000:ybp_start],'XTickLabel',[],'YTick',[],...
    'TickDir','out','XMinorTIck','on','YMinorTick','on','FontSize',FS) 
    % position of each plot based on p_vect;
    % reverse order the x-axis; label X-axis every 1000 years; 
    % turn off-x-axis tick labels on all plots; make tick marks go out
    % turn on minor tick marks
else
    zone_vect = scd_vect;
end  
%% Now plot CHAR, if desired
if plot_char == 1
in = in+1;
subplot(length(taxa_plot)+5,1,in)
% [H1] = bar(char_ybp,CHAR); hold on
% set(H1,'FaceColor','k','BarWidth',1,'linewidth',LW)
stairs(char_ybp,CHAR,'k','LineWidth',LW);
hold on
if peaks == 1
plot(char_peak_id(:,2),char_peak_id(:,4),'color',[.5 .5 .5],...
    'linewidth',LW*1.5) % background 
char_peak_id(char_peak_id(:,5)>0,5) = 0.75*max(CHAR);   % peaks
char_peak_id(char_peak_id(:,5)<=0,5) = NaN;
plot(char_peak_id(:,2),char_peak_id(:,5),'+k')
end

axis([ybp_stop ybp_start 0 max(CHAR)]); % xmin, xmax, ymin, ymax
cp_vect(1,1) = LP;     % left positioning = constant
cp_vect(1,3) = (ybp_start-ybp_stop)*TF; % width of graph is a 
                        % function of how much time is displayed
cp_vect(1,4) = (.12);    % height of graph
cp_vect(1,2) = (zone_vect(1,2)-cp_vect(1,4))-gs;
set(gca,'Position',cp_vect,'XDir','reverse',...
    'XTick',[0:1000:ybp_start],'XTickLabel',[0:ybp_start/1000],...
    'TickDir','out','XMinorTIck','on','YMinorTick','on','FontSize',FS)
    % position of each plot based on p_vect
    % reverse order the x-axis; label X-axis every 1000 years; 
    % turn off-x-axis tick labels on all plots; make tick marks go out
    % turn on minor tick marks
% text(ybp_start-0.01*ybp_start,max(CHAR),'CHAR',...
%     'VerticalAlignment','top','HorizontalAlignment','left',...
%     'FontWeight',FW,'FontSize',FS)
    % title for CHAR graph
if transform == -99
ylabel({'log CHAR  ','(# cm^-^2 yr^-^1)'},'FontSize',FS,'FontWeight',FW,...
    'VerticalAlignment','middle','HorizontalAlignment','right',...
    'FontWeight',FW,'FontSize',FS,'rotation',0)
else
ylabel({'CHAR     ';'(# cm^-^2 yr^-^1)'},'FontSize',FS,'FontWeight',FW,...
    'VerticalAlignment','middle','HorizontalAlignment','right',...
    'FontWeight',FW,'FontSize',FS,'rotation',0)
end
xlabel('age (cal. yr BP x 1000)','FontSize',FS','FontWeight',FW)
text(ybp_start,0-.5*max(CHAR),(date),'FontSize',FS)
box
else
    set(gca,'XDir','reverse',...
    'XTick',[0:1000:ybp_start],'XTickLabel',[0:ybp_start/1000],...
    'TickDir','out','XMinorTIck','on','YMinorTick','on','FontSize',FS)
    xlabel('age (cal. yr BP x 1000)','FontSize',FS','FontWeight',FW)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save CHAR and pollen data in two files
if transform == 1
pollen_percentages = pol_dat(:,:,1);
pollen_accumulation = pol_dat(:,:,3);
save sqrt_pollen_percentages.txt pollen_percentages -ascii
save sqrt_pollen_accumulation.txt pollen_accumulation -ascii
save pollen_ybp.txt pol_ybp -ascii
CHAR_data = [char_ybp, CHAR];
else
pollen_percentages = pol_dat(:,:,1);
pollen_accumulation = pol_dat(:,:,3);
save pollen_percentages.txt pollen_percentages -ascii
save pollen_accumulation.txt pollen_accumulation -ascii
save pollen_ybp.txt pol_ybp -ascii
CHAR_data = [char_ybp, CHAR];
end

if printing == 1
figure (1); set(gcf,'PaperPositionMode','auto','PaperType','uslegal')  
    orient(gcf,'landscape')
print -dpdf -r300 pollen_per_plot.pdf
print -dtiff -r300 pollen_per_plot.tif
% 
% figure (2); set(gcf,'PaperPositionMode','auto','PaperType','uslegal')  
%     orient(gcf,'landscape')
% print -dpdf -r300 pollen_con_plot.pdf
% print -dtiff -r300 pollen_con_plot.tif
% 
% figure (3); set(gcf,'PaperPositionMode','auto','PaperType','uslegal')  
%     orient(gcf,'landscape')
% print -dpdf -r300 pollen_acc_plot.pdf
% print -dtiff -r300 pollen_acc_plot.tif

end
