function [cocoh, Quad, freq] = coherence(X,Y,WINDOW,NOVERLAP,NFFT,Fs)
%  [cocoh, Quad, freq] = coherence(X,Y,WINDOW,NOVERLAP,NFFT,Fs) computes
%  the coherence estimate between X and Y.
%
% Author: E Cheynet - University of Stavanger, Norway.
%
% See also cpsd cohere


% get only the fluctuating part
X = detrend(X); % remove mean
Y = detrend(Y); % remove mean

% get cross spectrum
[pxy, freq] = cpsd(X,Y,WINDOW, NOVERLAP,NFFT,Fs);

% get single point spectrum
pxx = cpsd(X,X,WINDOW, NOVERLAP,NFFT,Fs);
pyy = cpsd(Y,Y,WINDOW, NOVERLAP,NFFT,Fs);

% Normalize the cross spectrum
cocoh = real(pxy./sqrt(pxx.*pyy));  % co-coherence
Quad = imag(pxy./sqrt(pxx.*pyy)); % quad-coherence


end

