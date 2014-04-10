function a = auto(data, endlag)
% function a = auto(data, endlag)
%
% This function calculates the autocorrelation function for the 
% data set "data" for a lag timescale of 0 to "endlag" and outputs 
% the autocorrelation function in to "a".
%
% Created by: D. L. Hartman, University of Washington
% Obtained by: P. E. Higuera, from ATM 552 "Objective Analysis" course, ca.
% 2004. Available at 
% http://www.atmos.washington.edu/~dennis/552_Software.html
%

N = length(data);

% Now solve for autocorrelation for time lags from zero to endlag
for lag=0:endlag
  data1=data(1:N-lag);
   data1=data1-mean(data1);
  data2=data(1+lag:N);
   data2=data2-mean(data2);
  a(lag+1) = sum(data1.*data2)/sqrt(sum(data1.^2).*sum(data2.^2));
  clear data1
  clear data2
end
