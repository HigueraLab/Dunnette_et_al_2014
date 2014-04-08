function composite = SEA(nEventSeries,events,nEvents,nBins,...
    nResponse,x_response,eventBin,response_res)
% SEA.m
%
% Given inputs of n event series ("response_res")...

% Created by: P.E. Higuera
% Created on: 18 July, 2012
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu
%%
composite = NaN*ones(max(nEvents),nBins,nResponse,nEventSeries);
            % Space for response values, where i = events, j = bins before 
            % and after an events, k = each response variable, and l = 
            % event time series. 

for l = 1:nEventSeries      % For each event time series...
    event_in = events(:,1+l) > 0;						
    eventYr = events(event_in,1);   % Event year here
    for i = 1:nEvents(l)   % For each event...
        in = find(abs(x_response - eventYr(i)) ==...
            min(abs(x_response - eventYr(i)))); % Find the index value that 
        % that minimizes the difference between the year of the event and
        % the closest matching year in the response variable. 
        
        sampleIn = in - eventBin';   % Index for sampling before and after
        % event i. eventbin is defined in SEA. It is the number of samples
        % before andafter the event. 
        
        if min(sampleIn) < 1 || max(sampleIn) > length(response_res)
            sampleIn(sampleIn < 1) = NaN;
            sampleIn(sampleIn > length(response_res)) = NaN;
        end
        
        sampleIn(:,end);
        
        temp = response_res(sampleIn(~isnan(sampleIn)),:);% Response_res 
        % is the residual time series. This applies the index to the 
        % residual time series. Rows are time steps, columns are parameters. 
        
        composite(i,find(~isnan(sampleIn)),:,l) = temp; % Response values 
        % from each response varialbe.      
    end
end