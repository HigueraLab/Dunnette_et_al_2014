%Edited by PVD: 12/2012, 1/2013, 3/2013; Tested again in 11/2013

function rand_composite = createFullRandComposite(nEventSeries,events,...
    nEvents,nBins,nResponse,x_response,eventBin,response_res)

rand_composite = NaN*ones(max(nEvents),nBins,nResponse,nEventSeries);
            % Space for response values, where i = events, j = bins before 
            % and after an events, k = each response variable, and l = 
            % event time series. 

for l = 1:nEventSeries      % For each event time series...
    event_in = events(:,1+l) > 0;						
    eventYr = events(event_in,1); %event year here
    blk=5; %PVD Edit; Establishes size for block resampling
    tempLength=(length(response_res)-blk); %PVD Edit; 
    recLength=1:(round2(tempLength,blk)); % PVD Edit (Lines 15-16 construct time series of a length that can be shuffled in blocks of 5; i.e.,nearest multiple of 5)
    response_res2=response_res(recLength,:); %PVD Edit; response_res2 is the slightly abbreviated time series used to construct the random distributions
    [trash nRandResponse] = size(response_res2);   % Number of response vars.

   randResponse=NaN*ones(size(response_res2));% %PVD Edit
   for n = 1:nRandResponse%(recLength,:)   %PVD Edit
       randResponse(:,n) = randblock(response_res2(:,n),blk); %PVD Edit
    
    for i = 1:nEvents(l)   % For each event...
        in = find(abs(x_response - eventYr(i)) ==...
            min(abs(x_response - eventYr(i)))); % Find the index value that 
        % that minimizes the difference between the year of the event and
        % the closest matching year in the response variable. 
        
        sampleIn = in - eventBin;   % Index for sampling before and after
        % event i. eventbin is defined in SEA. it is the number of samples
        % before and after the event. 
        
        if min(sampleIn) < 1 || max(sampleIn) > length(randResponse)
            sampleIn(sampleIn < 1) = NaN;
            sampleIn(sampleIn > length(randResponse)) = NaN;
        end
        
      temp = randResponse(sampleIn(~isnan(sampleIn)),:);
        
      rand_composite(i,find(~isnan(sampleIn)),:,l) = temp; %
       
    end
   end  
end