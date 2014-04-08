function [composite] = SEA(x,Y,events,params)
% SEA.m
%
% Given inputs of n event series ("response_res")...

% Requires equally-spaced samples.

% events.x -- 
% events.nSeries

% params.interpValue --
% params.smWindow --
% params.eventWindow --
% params.bin -- 

% response.n
% response.x
% response.y
% response.xi
% response.yi
% response.ySm
% response.residuals


% Created by: P.E. Higuera
% Created on: 18 July, 2012
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu

%% Create composite record
[~,nResponseVar] = size(Y); % Number of response variables input. 
composite = NaN*ones(max(sum(events.x)),length(params.bin),nResponseVar,...
    events.nSeries);
            % Space for response values, where i = events, j = bins before 
            % and after an events, k = each response variable, and l = 
            % event time series. 

for l = 1:events.nSeries    % For each event time series...
    event_in = find(events.x(:,l) > 0);         % Index for events					
    eventYr = round(x(event_in));   % Event year, rounded
    nEvents = length(eventYr);      % Number of events
    for i = 1:nEvents	% For each event...
        in = find(x == eventYr(i)); % Index for event i
        sampleIn = in - params.bin; % Index for sampling before and after
        % event i. eventbin is defined in SEA. It is the number of samples
        % before andafter the event. 
        
        % Screen for events that are too close to the start or end of the
        % response series, such that +/- bin values exceed the size of the
        % response series vector. 
        if min(sampleIn) < 1 || max(sampleIn) > length(x)
            sampleIn(sampleIn < 1) = NaN;
            sampleIn(sampleIn > length(x)) = NaN;
            disp('Note: Event too close series end - response series trimmed') 
        end
        
        composite_i = Y(sampleIn(~isnan(sampleIn)),:);% Composite values 
        % in each response series, for event i. Rows are time steps, 
        % columns are response variables. 
        
        composite(i,~isnan(sampleIn),:,l) = composite_i; % Response 
        % values from each response varialbe.      
    end
end