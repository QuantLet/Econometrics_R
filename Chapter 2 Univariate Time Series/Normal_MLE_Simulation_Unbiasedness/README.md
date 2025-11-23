<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Normal_MLE_Simulation_Unbiasedness

Published in: Econometrics_R

Description: This R script investigates the sampling behaviour and approximate unbiasedness of the maximum likelihood estimators (MLEs) for the mean and standard deviation of a normal distribution. It repeatedly simulates samples of size n = 1000 from a N(μ = 5, σ = 2) distribution over 100,000 Monte Carlo replications. For each sample, it computes the MLE of μ (the sample mean) and the MLE of σ, using sqrt((n - 1) / n * var(sample)) to adjust for the bias of the usual sample variance. The script records all simulated MLEs, prints the average of the μ estimates and of the σ² estimates to assess approximate unbiasedness, and then uses ggplot2 to visualise the empirical distributions of μ̂ and σ̂. Histograms with overlaid kernel density estimates are produced for both estimators, and the resulting figures are saved as 6 x 4 inch PNG files ("mu_mle_distribution.png" and "sigma_mle_distribution.png") in the working directory.

Keywords: Econometrics, Maximum Likelihood, Normal Distribution, MLE, Unbiasedness, Monte Carlo Simulation, Sampling Distribution, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/Normal_MLE_Simulation_Unbiasedness/mu_mle_distribution.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/Normal_MLE_Simulation_Unbiasedness/sigma_mle_distribution.png" alt="Image" />
</div>

