function [stats] = corr_p_adj_N(x,y,Type)
% function [stats] = corr_p_adj_N(x,y,Type)
%
% This function calculates an adjusted probability of obtaining the 
% observed correlation, r, using a sample size adjusted for first-order 
% autocorrelation, n_adj, and Student's t distribution. If input variables 
% x or y have significant positive autocorrelation, then the true number 
% of independent samples will be less than n, and the probability of Type I
% error, p, will be artificially deflated. 
% 
% TAKES AS INPUTS:
%   x: a m-by-n matrix that can be passed to the Matlab corr.m function 
%   y: a m-by-n matrix that can be passed to the Matlab corr.m function
%   Type: Single value. If "1" then Pearson correlation is performed.
%       Otherwise, Spearman rank correlation is performed. Pearson 
%       correlation is the default method (if Type is not passed to the
%       function). 
%
% RETURNS:
% stats -- structure with seven elements:
%   stats.auto -- Lag 0-5 autocorrelation values for inputs x and y.
%   stats.sigAuto --  Results of the test for significant positive
%                   autocorrelation: 'yes' if significant autocorrelation 
%                   exists, else 'no.'
%   stats.r -- Correlation coefficient between inputs x and y.
%   stats.p -- Standard p-value, given original sample size of x and y.
%   stats.p_adj -- Adjusted p-value, given sample size adjusted for
%                   autocorrelation.
%   stats.n -- Original sample size.
%   stats.n_adj -- Sample size of x and y, adjusted for first-order
%                   autocorrelation. 
%
% DETAILS:
% Specifically, this function (1) calculates the  correlation 
% coefficient between input variables x and y, using the 'corr' function in
% MATLAB, (2) tests for significant *positive* autocorrelation within the 
% input variables x and y, using 95% confidence intervals, as described by 
% Anderson (1942), and (3) estimates the adjusted sample size, n_adj, for 
% input variables x and y, using the equation from Dawdy and Matalas 
% (1964): N' = N*(1-rValue1/1+rValue1), and (4) calculates an
% adjusted p-value for the null hypothesis that r = 0, using the mean of
% the two adjusted p-values and Student’s t distribution, as described in 
% Zar (1999). 
%
% Anderson, R. L. 1942. Distribution of the Serial Correlation Coefficient. 
%       The Annals of Mathematical Statistics 13:1-13.
% Dawdy, D.R., and Matalas, N.C. 1964. Statistical and probability
%       analysis of hydrologic data, part III: Analysis of variance, 
%       covariance and time series, in Ven Te Chow, ed., Handbook of 
%       applied hydrology, acompendium of water resources technology: New 
%       York, McGraw-Hill Book Company, p. 8.68-8.90. 
% Zar, J. H. 1999. Biostatistical Analysis. Fourth edition. Prentice Hall, 
%       Upper Saddle River, NJ. Chapter 19. 
%
% DEPENDENCIES: 
%   (1) corr.m -- Matlab function, from the Matlab statistics toolbox.
%   (2) tcdf.m -- Matlab function, from the Matlab statistics toolbox.
%   (3) auto.m -- Function to calculate autocorrelation.
%
% CITATION:
%   Higuera, P.E. and P.V. Dunnette. 2014. Data, code, and 
%   figures from Dunnette et al. 2014. figshare. 
%   http://dx.doi.org/10.6084/m9.figshare.988687
%
% Created by: P.E. Higuera
% Created on: 19 June, 2013
% Updated on: 25 June, 2013 -- Updated to be able to do Pearson or Spearman
%   correlation, via the variable "Type" (1 == Pearson [default]), 
%   2 == Spearman).
% Updated on: 9 April, 2014 -- for publication with Dunnette et al. 2014.
%
% University of Idaho, PaleoEcology and Fire Ecology Lab
% http://www.uidaho.edu/cnr/paleoecologylab
% phiguera@uidaho.edu

%% Select correlation type
if nargin == 2
    Type = 1;       % Default is Pearson correlation. 
end

%% Collect information about input data
X = [x,y];          % Put x and y input data into one matrix, X.
n = length(X);      % Original sample size.
 
%% Use Matlab's function 'corr' to find linear correlation and p-value:
if Type == 1
    [r p] = corr(x,y);     
else
    [r p] = corr(x,y,'Type','Spearman');
end

%% Test for positive autocorrelation; if significant, calculate adjusted n.
lag = 5;     
n_adj = NaN(1,2);       % Room for adjusted N values, based on 1st-order
                        % autocorrelation.
stats.auto = NaN(2,lag+1);      % Space to store autocorrelation values.
stats.sigAuto = {'No' 'No'};    % Will change to "yes" if there is significant
                                % positive autocorrelation (lag 1-5). 
for i = 1:2
    x = X(:,i);   
    ac = auto(x(~isnan(x)),lag);
    stats.auto(i,:) = ac;
    %%%%% 95% confidence intervals for lag k autocorrelation:
    % Anderson, R. L. 1942. Distribution of the Serial Correlation 
    % Coefficient. The Annals of Mathematical Statistics 13:1-13.
%     % One tailed hypothesis: positive (negative) autocorrelation
%     ac_CI = [-1+1.645.*sqrt(length(y)-[1:lag]-1)] ./ (length(y)-[1:lag]);
    % Two tailed hypothesis: positive or negative autocorrelation
    ac_CI = [-1+1.96.*sqrt(length(y)-[1:lag]-1)] ./ (length(y)-[1:lag]);
       
    % If there is evidence for positive autocorrelation, then estimate n_adj.
    %%%%%% Equation for calculating effective sample size:
    %Dawdy, D.R., and Matalas, N.C. 1964. Statistical and probability
%       analysis of hydrologic data, part III: Analysis of variance, covariance
%       and time series, in Ven Te Chow, ed., Handbook of Applied Hydrology, a
%       Compendium of Water Resources Technology: New York, McGraw-Hill Book
%       Company, p. 8.68-8.90. 
    
    if sum(ac(2:end) >= ac_CI)
        n_adj(i) = round(length(x) * ((1-ac(2))/(1+ac(2))));  
        stats.sigAuto(i) = {'yes'};
    else
        n_adj(i) = length(x);
    end
end
 
%% Calculate probability of null hypothesis, Ho: r = 0.
s_r = sqrt([1-r^2]/(n-2));      % Equation 19.3, Zar 1999.
t = r / s_r;                    % Equation 19.4, Zar 1999.
n = round(mean(n_adj));       % Sample size: mean from original n 
                                    % and n_adj.
v = n-2;                        % Degrees of freedom.
    if v <= 0
        display('WARNING: Adjusted degrees of freedom = 0; changing to 1')
        v = 2;
    end
p_adj = 2*(1-tcdf(abs(t),v));   % Probability of a t-value equal to or 
                                    % greater than observed. 
 
%% Store data to return 
stats.r = r;
stats.p = p;
stats.p_adj = p_adj;
stats.n = length(X);
stats.n_adj = n_adj;
 
%% Test algorithm against Matlab's function 'corr' with the code below:
% 
% n = 10;
% nBoot = 100;
% p1_p = NaN(nBoot,2);
% 
% for i = 1:nBoot
% 
%     x = rand(n,1);
%     y = rand(n,1);
%     [r p] = corr(x,y);
% 
%     %% Calculate probability of null hypothesis, Ho: r = 0.
%     s_r = sqrt([1-r^2]/(n-2));      % Equation 19.3, Zar 1999.
%     t = r / s_r;                    % Equation 19.4, Zar 1999.
%     v = n-2;                        % Degrees of freedom.
%     p = 2*(1-tcdf(abs(t),v));       % Probability of a t-value equal to or 
%                                     % greater than observed. 
%     p1_p(i,:) = [p1 p];
% end
% figure(1) 
% plot(p1_p(:,1),p1_p(:,2),'.')


