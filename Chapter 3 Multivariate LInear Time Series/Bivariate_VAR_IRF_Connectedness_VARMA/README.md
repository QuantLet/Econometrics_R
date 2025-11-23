<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Bivariate_VAR_IRF_Connectedness_VARMA

Published in: Econometrics_R

Description: This R script performs a comprehensive multivariate time series analysis on US real consumption and real disposable income, and then illustrates VARMA dynamics via simulation. It first retrieves monthly real PCE (PCEC96) and real DPI (DSPIC96) from FRED using fredr, constructs log real consumption and log real income, and forms a bivariate monthly time series. A VAR lag order is selected via VARselect(), and a VAR(p) with constant is estimated using vars::VAR(), with the stacked coefficient matrix and innovation covariance matrix Ω reported alongside the sample covariance matrix Γ(0). For illustration, a VAR(1) approximation is also estimated and the theoretical Γ(0) is computed via vec(Γ(0)) = (I − A ⊗ A)^{-1} vec(Ω), then compared to the sample Γ(0).

The script next computes impulse response functions (IRFs). It first uses vars: :irf() to obtain standard IRFs (with optional orthogonalisation), and then builds the full array of VMA coefficient matrices Ψ_k via a custom recursion based on the estimated VAR coefficients. Using Ψ_k and Ω, it implements the Diebold–Yilmaz (2014) connectedness measure d_ij^K, producing a connectedness matrix that quantifies how shocks originating in one variable contribute to forecast error variance in another.

A separate VMA(1) example is included, in which y₁t is i.i.d. and y₂t follows an MA(1) process. The script computes empirical lag-1 cross-autocovariance and cross-autocorrelation matrices and compares them with the theoretical Γ_ij(1) and R_ij(1) expressions derived in the text. Finally, it simulates a bivariate VARMA(1,1) process using MTS: :VARMAsim with specified AR and MA coefficient matrices and correlated innovations, plots the simulated series, approximates the VARMA(1,1) with a higher-order VAR(4), and computes orthogonalised IRFs from the VAR(4) approximation to demonstrate how VARs can serve as finite-order approximations to VARMA models.

Keywords: Econometrics, Time Series, VAR, VARMA, VMA, Impulse Response Functions, Diebold–Yilmaz Connectedness, Innovation Covariance, FRED, Real Consumption, Real Disposable Income, MTS, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
