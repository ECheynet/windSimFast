function [u,v,w,nodes] = windSimFast(U,f,Su,Sv,Sw,CoeffDecay,Y,Z,varargin)
% [u,v,w,nodes] = windSimFast(U,f,Su,Sv,Sw,CoeffDecay,Y,Z,varargin)
% simulates the turbulent components u, v and w of the wind
% velocity using a target power spectral density (PSD) and coherence model.
% The numerical method comes from ref. [1] and a similar Matlab implementation 
% has been used in ref. [2].
%
% Inputs:
% U: matrix [Ny x Nz] of mean wind velocity (in m/s) at each node of a grid.
% f: vector [1 x Nfreq] of frequency (in Hz)
% Su: vector [Nm x 1] corresponding to the PSD the u-component.
% Sv: vector [Nm x 1] corresponding to the PSD the v-component.
% Sw: vector [Nm x 1] corresponding to the PSD the w-component.
% CoeffDecay: Structure containing the decay coefficient for the Davenport
% model [3] 
% Z: matrix [Ny x Nz] of height (in m) at each node of a grid.
% Y: matrix [Ny x Nz] of lateral position (in m) at each node of a grid.
%
% Outputs:
% Posing Nm = Nx*Ny and N = number of time step,
% u: matrix [N x Nm] of along-wind velocity fluctuations
% v: matrix [N x Nm] of lateral-wind velocity fluctuations
% w: matrix [N x Nm] of vertical-wind velocity fluctuations
% nodes: structure containing the position and associated velocity of each
% nodes on the 2D-grid.
% 
% Options (varargin):
% 'Suw':  vector [Nm x 1] corresponding to the CPSD the u and w components
% 'Svw': vector [Nm x 1] corresponding to the CPSD the v and w components
% 'cohModel': string: the coherence model (so far, only 'Davenport' exist)
% 
% References:
% [1] Shinozuka, M., & Deodatis, G. (1991). 
% Simulation of stochastic processes by spectral representation. 
% Applied Mechanics Reviews, 44(4), 191-204.
% 
% [2] Wang, J., Cheynet, E., Snæbjörnsson, J. Þ., & Jakobsen, J. B. (2018).
% Coupled aerodynamic and hydrodynamic response of a long span bridge
% suspended from floating towers. 
% Journal of Wind Engineering and Industrial Aerodynamics, 177, 19-31.
% 
% [3] Davenport, A. G. (1961). The spectrum of horizontal gustiness near 
% the ground in high winds. 
% Quarterly Journal of the Royal Meteorological Society, 87(372), 194-211.
% 
% Author: E. Cheynet - UiB - last modified : 12-06-2020


%% optional parameters removed from previous version
% 'quadCoh_Cu' are decay coeficients for the quad-coherence of the u component.
%  Example: quadCoh_Cu = [5 10];
% 'quadCoh_Cv' are decay coeficients for the quad-coherence of the w component.
%  Example: quadCoh_Cv = [5 10];
% 'quadCoh_Cw' are decay coeficients for the quad-coherence of the w component.
%  Example: quadCoh_Cw = [5 10];

%% Input parser 
p = inputParser();
p.CaseSensitive = false;
% p.addOptional('quadCoh_Cu',[]); % optional coefficients used for the quad-coherence
% p.addOptional('quadCoh_Cv',[]); % optional coefficients used for the quad-coherence
% p.addOptional('quadCoh_Cw',[]); % optional coefficients used for the quad-coherence
p.addOptional('cohModel','Davenport');
p.addOptional('Suw',zeros(size(Su)));
p.addOptional('Svw',zeros(size(Su)));
p.parse(varargin{:});
% shorthen the variables name
Suw = p.Results.Suw ;
Svw = p.Results.Svw ;
cohModel = p.Results.cohModel;
% quadCoh_Cu = p.Results.quadCoh_Cu;
% quadCoh_Cv = p.Results.quadCoh_Cv;
% quadCoh_Cw = p.Results.quadCoh_Cw;
%% Create the structure "nodes"
Nm = numel(Y(:)); % number of nodes in the grid, equal to Nyy*Nzz
M = 3*Nm; % u,v and w are generated together, requiring 3 times more points than Nm (u,v and w are not necessarily independant)
% Create the structure nodes
nodes.U = U;
nodes.Y = Y;
nodes.Z = Z;
% Affect one name and to each nodes
for ii=1:Nm,    nodes.name{ii} = strcat('N',num2str(ii));end

Nfreq = numel(f);
N = 2*Nfreq;
dt = 1/(2*f(end));

%% Compute the core spectral matrix A

dy = abs(bsxfun(@minus,nodes.Y(:)',nodes.Y(:))); % Matrix distance along y
dz = abs(bsxfun(@minus,nodes.Z(:)',nodes.Z(:))); % Matrix distance along z
meanU = 0.5*abs(bsxfun(@plus,nodes.U(:)',nodes.U(:))); % Mean wind velocity between each nodes


A = zeros(Nfreq,M);
ZERO = zeros(Nm);

for ii=1:Nfreq
    if ii==2,    tStart = tic; end
    randPhase = rand(M,1); % set random phase  
    
    % compute the coherence at each frequency step
    if strcmpi(cohModel,'Davenport')
        [cohU] = cohDavenport(meanU,dy,dz,f(ii),CoeffDecay.Cuy,CoeffDecay.Cuz);
        [cohV] = cohDavenport(meanU,dy,dz,f(ii),CoeffDecay.Cvy,CoeffDecay.Cvz);
        [cohW] = cohDavenport(meanU,dy,dz,f(ii),CoeffDecay.Cwy,CoeffDecay.Cwz);
    else
        error('In the present version, no other coherence model than the Davenport model has been implemented');
    end
    
    
%     if ~isempty(quadCoh_Cu)
%        quadCohU = getQuadCoh(meanU,dz,f(ii),quadCoh_Cu); % compute the quad-coherence
%        cohU = cohU + 1i.*quadCohU;       
%     end
%     
%     if ~isempty(quadCoh_Cv)
%        quadCohV = getQuadCoh(meanU,dz,f(ii),quadCoh_Cv); % compute the quad-coherence
%        cohU = cohU + 1i.*quadCohV;       
%     end
%     
%     if ~isempty(quadCoh_Cw)
%        quadCohW = getQuadCoh(meanU,dz,f(ii),quadCoh_Cw); % compute the quad-coherence
%        cohU = cohU + 1i.*quadCohW;       
%     end    
    
    Suu = sqrt(Su(:,ii)*Su(:,ii)').*cohU;
    Svv = sqrt(Sv(:,ii)*Sv(:,ii)').*cohV;
    Sww = sqrt(Sw(:,ii)*Sw(:,ii)').*cohW;
    Suw2 = sqrt(Suw(:,ii)*Suw(:,ii)').*sqrt(cohU.*cohW); % The cross-coherence is here not very well defined, but this should be good enough at a first approximation
    Svw2 = sqrt(Svw(:,ii)*Svw(:,ii)').*sqrt(cohU.*cohW); % The cross-coherence is here not very well defined, but this should be good enough at a first approximation
    
    
    S = [Suu,   ZERO,   Suw2;...
        ZERO,  Svv,    Svw2;...
        Suw2,  Svw2,   Sww];
    
    [L,D]=ldl(S,'lower'); % a LDL decomposition is applied this time
    G = L*sqrt(D);
    A(ii,:)= G*exp(1i*2*pi*randPhase);
    if ii==2,    fprintf(['Expected computation time: From ',num2str(round(min(toc(tStart))*Nfreq/2)),' to ',num2str(round(min(toc(tStart))*Nfreq)),' seconds \n']); end
end

%% Apply IFFT
% Nu = [zeros(1:Nfreq,1);A(1:Nfreq,:) ; real(A(Nfreq,:)); conj(flipud(A(1:Nfreq,:)))];
Nu = [zeros(1,M);A(1:Nfreq-1,:) ; real(A(Nfreq,:)); conj(flipud(A(1:Nfreq-1,:)))];
speed=real(ifft(Nu).*sqrt(Nfreq./(dt)));

u = speed(:,1:Nm);
v = speed(:,Nm+1:2*Nm);
w = -speed(:,2*Nm+1:3*Nm);

%% Nested functions
    function [coh] = cohDavenport(meanU,dy,dz,f,Cy,Cz)
        
        % lateral separation
        ay = Cy(1).*dy;
        % vertical separation
        az = Cz(1).*dz;
        % Combine them into the coherence matrix for lateral and vertical
        % separations
        coh = exp(-sqrt(ay.^2+az.^2).*f./meanU);
    end
   function [Qu] = getQuadCoh(meanU,dz,f,C)
        dummy = -tril(ones(size(dz)),-1) + triu(ones(size(dz)),1);        
        Qu = dummy.*(C(1).*f./meanU.*dz).*exp(-C(2).*f./meanU.*dz);
    end
end