function [composite_CI] = SEA_CI(x,Y,events,params)
% SEA_CI
%
% Created by: P.E. Higuera
% Created on: 18 July, 2012
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu

%% Derrive variables
[~,nResponseVar] = size(Y); % Number of response variables input. 


%% Randomzie Y via block resampling
nBoot = params.nBoot;               % Number of bootstrapped samples
[n,m] = size(Y);                    % Size of response variable matrix
blockSize = params.block;           % [samples] Block size          
nBlocks = floor(n / blockSize);     % Number of blocks, rounded down

composite_boot = NaN(length(params.bin),nResponseVar,events.nSeries,nBoot);
            % Space for composite record, where i = bins before and after
            % an event, j = each response variable, k = event time
            % series, and l = nBoot samples. 
for j = 1:nBoot
    randIn = NaN*ones(nBlocks*blockSize,1); % Space for the index values 
        % for randomized response series. If series if long than nBlocks 
        % * blockSize, it will contain NaN values. 
    startIn = randperm(nBlocks) .* blockSize;   % Randomized starting index  
                                                % for each block.                                            
    in = 1; % Index for use in for loop
    for i = 1:length(startIn) 
        randIn(in:in+blockSize-1) =...
            [startIn(i):startIn(i)+blockSize-1];    % Fill in randIn
        in = in + blockSize;
    end
    % Deal with samples that overlap the end of the series: If a block
    % overlaps the end of the series, then use the first block in the
    % dataset instead. If no blocks overlap the end of the series, then the
    % first block is never used. 
    if max(randIn > n)
        randIn([max(find(randIn > n))-...
        blockSize+1:max(find(randIn > n))]) = [1:5];
    end
    % plot(randIn,'.'); grid on     % Plot to confirm randomized blocks.
    
    Y_rand = Y(randIn,:);           % Response variable matrix, Y, 
                                    % randomized. To be used in SEA.

	%%%% Perform SEA and save results in composite_boot
    composite_boot(:,:,:,j) = SEA(x,Y_rand,events,params);    
end

composite_CI = prctile(composite_boot,[0.5 99.5 2.5 97.5 5 95],4);
    % composite_CI: percentile values for each bin before and after
    % events (i), each response series (j), each event series (k), and each
    % percentile level (l). Percentiles are as follows: 0.5 99.5, 
    % corresponding to 99% CI, 2.5 and 97.5, corresponding to 95 CI, and 
    % 5 and 95, correspnding to 90% CI> 
 

