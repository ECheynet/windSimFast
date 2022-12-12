# windSimFast
A three-variate turbulent wind field (u,v and w components) is simulated in three-dimensions. 

[![View Wind field simulation (the fast version) on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/68632-wind-field-simulation-the-fast-version)
[![DOI](https://zenodo.org/badge/248844343.svg)](https://zenodo.org/badge/latestdoi/248844343)
[![Donation](https://camo.githubusercontent.com/a37ab2f2f19af23730565736fb8621eea275aad02f649c8f96959f78388edf45/68747470733a2f2f77617265686f7573652d63616d6f2e636d68312e707366686f737465642e6f72672f316339333962613132323739393662383762623033636630323963313438323165616239616439312f3638373437343730373333613266326636393664363732653733363836393635366336343733326536393666326636323631363436373635326634343666366536313734363532643432373537393235333233303664363532353332333036313235333233303633366636363636363536353264373936353663366336663737363737323635363536653265373337363637)](https://www.buymeacoffee.com/echeynet)

## Summary
A turbulent wind field (u,v,w, components) in 3-D (two dimensions for space and one for the time) is simulated using random processes.  The computational efficiency of the simulation relies on Ref. [1], which leads to a significantly shorter simulation time than the function windSim, also available on fileExchange. However,  only the case of a regular 2D vertical grid normal to the flow is here considered.


## Content
The submission contains:
- An example file Example1 that illustrates simply how the output variables look like.
- An example file Example2, which is more complete, and which simulates a 3-D turbulent wind field on a 7x7 grid.
- A data file exampleData.mat used in Example1.
- The function windSimFast.m, which is used to generate the turbulent wind field.  A similar implementation of windSimFast.m was used in ref. [2].
- The function getSamplingpara.m, which computes the time and frequency vectors.
- The function KaimalModel.m, which generates the one-point auto and cross-spectral densities of the velocity fluctuations, following the Kaimal model [3]. I have corrected the cross-spectrum density formula used by Kaimal et al. so that the simulated friction velocity is equal to the target one. 
- The function coherence used to estimate the root-mean-square coherence, the co-coherence and the quad-coherence.
- The function write2bts to convert the data into a .bts file (binary data). This function is still under testing and I ignore if it performs well.

Any comment, suggestion or question is welcomed.


## References

  [1] Shinozuka, M., & Deodatis, G. (1991).   Simulation of stochastic processes by spectral representation.   Applied Mechanics Reviews, 44(4), 191-204.
  
  [2] Wang, J., Cheynet, E., Snæbjörnsson, J. Þ., & Jakobsen, J. B. (2018). Coupled aerodynamic and hydrodynamic response of a long span bridge suspended from floating towers.  Journal of Wind Engineering and Industrial Aerodynamics, 177, 19-31.
  
  [3] Davenport, A. G. (1961). The spectrum of horizontal gustiness near the ground in high winds.   Quarterly Journal of the Royal Meteorological Society, 87(372), 194-211.






