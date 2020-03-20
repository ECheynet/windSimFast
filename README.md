# windSimFast

[![View Wind field simulation (the fast version) on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/68632-wind-field-simulation-the-fast-version)


The present submission deals with the simulation of turbulent wind field (u,v,w, components) in 3-D (two dimensions for space and one for the time).  The computational efficiency of the simulation relies on Ref. [1], which leads to a significantly shorter simulation time than the function windSim, also available on fileExchange. However,  only the case of a regular 2D vertical grid normal to the flow is here considered.

The submission contains:
- An example file Example1 that illustrates simply how the output variables look like.
- An example file Example2, which is more complete, and which simulates a 3-D turbulent wind field on a 7x7 grid.
- A data file exampleData.mat used in Example1.
- The function windSimFast.m, which is used to generate the turbulent wind field.  A similar implementation of windSimFast.m was used in ref. [2].
- The function getSamplingpara.m, which computes the time and frequency vectors.
- The function KaimalModel.m, which generates the one-point auto and cross-spectral densities of the velocity fluctuations, following the Kaimal model [3]. I have corrected the cross-spectrum density formula used by Kaimal et al. so that the simulated friction velocity is equal to the target one. 
- The function coherence used to estimate the root-mean-square coherence, the co-coherence and the quad-coherence.



References:

  [1] Shinozuka, M., & Deodatis, G. (1991).   Simulation of stochastic processes by spectral representation.   Applied Mechanics Reviews, 44(4), 191-204.
  
  [2] Wang, J., Cheynet, E., Snæbjörnsson, J. Þ., & Jakobsen, J. B. (2018). Coupled aerodynamic and hydrodynamic response of a long span bridge suspended from floating towers.  Journal of Wind Engineering and Industrial Aerodynamics, 177, 19-31.
  
  [3] Davenport, A. G. (1961). The spectrum of horizontal gustiness near the ground in high winds.   Quarterly Journal of the Royal Meteorological Society, 87(372), 194-211.

Any comment, suggestion or question is welcomed.





