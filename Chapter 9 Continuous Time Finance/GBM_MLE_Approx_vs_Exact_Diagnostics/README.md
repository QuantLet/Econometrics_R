<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: GBM_MLE_Approx_vs_Exact_Diagnostics

Published in: Econometrics_R

Description: This R script simulates data from a geometric Brownian motion (GBM) model, calibrates the drift and volatility parameters via maximum likelihood estimation using an approximate transition density, and compares the resulting diagnostics to the exact likelihood-based quantities. The code sets up optimisation options for nloptr, simulates GBM paths with a fine time grid and subsampling, runs MLE via a user-defined ModelU2, and computes standard errors and robust Huber–sandwich standard errors from the approximate information and Hessian matrices. It then evaluates the exact log-likelihood, score, information matrix, and Hessian at the estimated parameters, constructs exact and robust standard errors, and reports the discrepancies (norms) between approximate and exact quantities, providing a detailed diagnostic of the approximation quality.

Keywords: Econometrics, Diffusion Process, Geometric Brownian Motion, GBM, Maximum Likelihood Estimation, Approximate Likelihood, Exact Likelihood, Score, Information Matrix, Hessian, Robust Standard Errors, Huber Sandwich, nloptr, Simulation, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
