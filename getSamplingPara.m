function [t,f] = getSamplingPara(M,fs)
%  The function getSamplingPara(M,fs) computes the time and frequency 
% vectors based on two inputs: the sampling frequency fs and an integer M 
% used to compute the number of time step, which is equal to 2^M.
% 
% Inputs:
%   M: is a natural number used as the power of 2 and is used to compute the 
% number of time step for the simulation.
%   fs: Sampling frequency (Hz)
% 
% Outputs:
%   t: dimensions [1 xN]: time vector (units: s)
%   f: dimensions [1 x N/2]: frequency vector  (units: s^(-1))
% 
% Author: E. Cheynet - UiS - last modified : 25-08-2018 

%% 

if mod(M,1)~=0 || M<=0, error(' ''M'' should be a natural '); end

N = 2^M; % number of time step
dt = 1/fs; 
tmax=dt.*N; 
t = (0:N-1)*dt;

fprintf(['Duration of target time series is ',num2str(tmax/3600,3),' hours, i.e. ',num2str(tmax,3),' sec \n\n'])
f0 = 1/tmax;  % minimal frequency recorded
fc = fs/2; % Nyquist freq
f = [f0:f0:fc]; % frequency vector
end

