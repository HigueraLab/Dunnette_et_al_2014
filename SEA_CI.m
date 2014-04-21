function [composite_CI] = SEA_CI(x,Y,events,params)
% function [composite_CI] = SEA_CI(x,Y,events,params)
%
% Confidence interval for Superposed Epoch Analysis, or compositing:
% SEA_CI.m requires SEA.m be run first.
% takes as input a matrix of event time series, events, and a 
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
% params: structure with multiple fields. Only one field is neede by SEA.m
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

%% Derive variables
[~,nResponseVar] = size(Y); % Number of response variables input. 
[~,nEventSeries] = size(events); % Number of event series

%% Randomzie Y via block resampling
nBoot = params.nBoot;               % Number of bootstrapped samples
[n,m] = size(Y);                    % Size of response variable matrix
blockSize = params.block;           % [samples] Block size          
nBlocks = floor(n / blockSize);     % Number of blocks, rounded down

composite_boot = NaN(length(params.bin),nResponseVar,nEventSeries,nBoot);
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
    % 5 and 95, corresponding to 90% CI> 
 

