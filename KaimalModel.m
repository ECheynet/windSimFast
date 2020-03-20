function [Su,Sv,Sw,Suw,Svw] = KaimalModel(U,Z,f,u_star)
% [Su,Sv,Sw,Suw,Svw] = KaimalModel(U,Z,f,u_star) computes the one-point
% auto and cross-spectral densities of the Kaimal model [1].
% [1] Kaimal, J. C., & Finnigan, J. J. (1994).
% Atmospheric boundary layer flows: their structure and measurement.
% Oxford university press.
%
%
% Inputs:
% U: matrix [Ny x Nz] of mean wind velocity (in m/s) at each node of a grid.
% Z: matrix [Ny x Nz] of height (in m) at each node of a grid.
% f: vector [1 x Nfreq] of frequency (in Hz)
% u_star: scalar [1 x 1] friction velocity (in m/s)
%
% Outputs:
% Posing Nm = Nx*Ny and recalling that PSD = power spectral density and
% CPSD = cross-power spectral density:
% Su: vector [Nm x 1] corresponding to the PSD the u-component
% Sv: vector [Nm x 1] corresponding to the PSD the v-component.
% Sw: vector [Nm x 1] corresponding to the PSD the w-component
% Suw: vector [Nm x 1] corresponding to the CPSD the u and w components
%
% Author: E. Cheynet - UiS - last modified : 25-08-2018

%%
N = numel(f);
Nm = numel(U(:));
Su = zeros(Nm,N); % preallocation
Sv = zeros(Nm,N); % preallocation
Sw = zeros(Nm,N); % preallocation
Suw = zeros(Nm,N); % preallocation
Svw = zeros(Nm,N); % preallocation
dummyU = U(:);
dummyZ = Z(:);
for jj=1:Nm
    fr = (f*dummyZ(jj)/dummyU(jj));
    Su(jj,:) = 102.*fr./(1+33.*fr).^(5/3).*u_star.^2./f; % Kaimal  model (NOT normalized)
    Sv(jj,:) = 17.*fr./(1+9.5.*fr).^(5/3).*u_star.^2./f; % Kaimal  model (NOT normalized)
    Sw(jj,:) = (2.*fr./(1+5.*fr.^(5/3))).*u_star.^2./f; % Kaimal model (NOT normalized)
    Suw(jj,:) = -14.*fr./(1+10.5*fr).^(7/3).*u_star.^2./f; % corrected (by me) Kaimal cross-spectrum model (NOT normalized)
end

end