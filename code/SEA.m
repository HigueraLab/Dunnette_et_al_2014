function [composite] = SEA(x,Y,events,params)
% function [composite] = SEA(x,Y,events,params)
%
% Superposed Epoch Analysis, or compositing:
% SEA.m takes as input a matrix of event time series, events, and a 
% matrix response time series, Y, and calculates the average (composite)
% value in the response series for samples before and after each event. 
% 
% TAKES AS INPUTS:
% x: m-by-1 vector with sample id for each sample in Y, usually time.
% Y: m-by-n matrix where each row (m) is a sample, and each column is a 
%   response series. Y may have multiple columns (n), or response
%   series, but all columns in Y should have the same number of row. When 
%   n > 1, SEA.m will return composite records for each response series. 
% events: m-by-n matrix, where the number of rows (m) equals those in x and
%   Y, and values are 0 (no event) or 1 (event). Each column, n, represents
%   and independent event series. 
% params: structure with multiple fields. Only one field is needed by SEA.m
%   params.bin: Number of samples to use in the composite, before and after
%   each event. The value 0 represents the event, and negative values
%   represent values before the event. 
%
% RETURNS:
% composite: m-by-n-by-o matrix, where m = bins as defined by params.bin, 
%   n = each response series (equal to n of matrix Y), and o = each event
%   series defined in events (equal to n of matrix events).
%
% DEPENDENCIES: 
%   (1) nanmean.m -- Matlab function, from the Matlab statistics toolbox.
%
% CITATION:
%   Higuera, P.E. and P.V. Dunnette. 2014. Data, code, and 
%   figures from Dunnette et al. 2014. figshare. 
%   http://dx.doi.org/10.6084/m9.figshare.988687
%
% Created by: P.E. Higuera
% Created on: 18 July, 2012
% Updated on: 8 April, 2014 -- Updated for submission with Dunnette et al.
% 2014, to make function more general.  
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu

%% Create composite record
[~,nResponseVar] = size(Y); % Number of response variables input
[~,nEventSeries] = size(events); % Number of event series

response = NaN*ones(max(sum(events)),length(params.bin),nResponseVar,...
    nEventSeries);
            % Space for response values, where i = events, j = bins before 
            % and after an event, k = each response variable, and l = 
            % event time series. 

composite = NaN(length(params.bin),nResponseVar,nEventSeries);
            % Space for composite record, where i = bins before and after
            % an event, j = each response variable, and k = event time
            % series. 
            
for l = 1:nEventSeries    % For each event time series...
    event_in = find(events(:,l) > 0);         % Index for events					
    eventYr = round(x(event_in));   % Event year, rounded
    nEvents = length(eventYr);      % Number of events
    for i = 1:nEvents	% For each event...
        in = find(x == eventYr(i)); % Index for event i
        sampleIn = in - params.bin; % Index for sampling before and after
        % event i. eventbin is defined in SEA. It is the number of samples
        % before and after the event. 
        
        % Screen for events that are too close to the start or end of the
        % response series, such that +/- bin values exceed the size of the
        % response series vector. 
        if min(sampleIn) < 1 || max(sampleIn) > length(x)
            sampleIn(sampleIn < 1) = NaN;
            sampleIn(sampleIn > length(x)) = NaN;
            disp('Note: Event too close series end - response series trimmed') 
        end
        
        response_i = Y(sampleIn(~isnan(sampleIn)),:);% Response values 
        % in each response series, for event i. Rows are time steps, 
        % columns are response variables. 
        
        response(i,~isnan(sampleIn),:,l) = response_i; % Response values 
        % from each response variable.      
    end
    composite(:,:,l) = squeeze(nanmean(response(:,:,:,l),1));   % Mean 
        % value across all events, for each bin (i) before and after
        % events, for each response variable (j), and for each event series
        % (k). 
end
