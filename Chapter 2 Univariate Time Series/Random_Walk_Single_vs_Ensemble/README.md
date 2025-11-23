<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Random_Walk_Single_vs_Ensemble

Published in: Econometrics_R

Description: This R script illustrates the difference between time-series (single-realization) and ensemble perspectives for a simple random walk. It first simulates one length-1000 random walk defined by Y_t = Y_{t-1} + ε_t with Gaussian increments, computes the sample mean and variance from this single path, and plots the realization over time, saving the figure as "single_realization.png". It then simulates N = 50 independent random walks of the same length, computes the ensemble average and variance of Y_t across paths at a fixed time point t = 100, and reshapes the simulated paths into long format for ggplot2. A plot of all 50 random walk trajectories is produced and saved as "50_random_walks_plot.png". Finally, the script prints the single-path estimates and the ensemble statistics to the console, highlighting the contrast between time-average and ensemble-average behaviour in random walk models.

Keywords: Econometrics, Time Series, Random Walk, Ensemble Averages, Simulation, Monte Carlo, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/Random_Walk_Single_vs_Ensemble/50_random_walks_plot.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/Random_Walk_Single_vs_Ensemble/single_realization.png" alt="Image" />
</div>

