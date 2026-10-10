# Econometrics and Time Series Methods

R examples and accompanying data for *Econometrics and Time Series Methods: Theory, Applications, and R Implementation*.

The [companion website](https://econometricsandtimeseries.com/) provides chapter guides, online lectures and selected exercises with hints.

## Chapters

- [Chapter 1 Regression Models](Chapter_1_Regression_Models/)
- [Chapter 2 Univariate Time Series](Chapter_2_Univariate_Time_Series/)
- [Chapter 3 Multivariate Linear Time Series](Chapter_3_Multivariate_Linear_Time_Series/)
- [Chapter 4 Volatility Models](Chapter_4_Volatility_Models/)
- [Chapter 5 Nonparametric Methods](Chapter_5_Nonparametric_Methods/)
- [Chapter 6 HAR Inference](Chapter_6_HAR_Inference/)
- [Chapter 7 Filtering](Chapter_7_Filtering/)
- [Chapter 8 Nonstationary Processes](Chapter_8_Nonstationary_Processes/)
- [Chapter 9 Continuous Time Finance](Chapter_9_Continuous_Time_Finance/)
- [Chapter 10 Selected Machine Learning Tools for Econometrics in R](Chapter_10_Selected_Machine_Learning_Tools_for_Econometrics_in_R/)

- [Appendix: R programming](Appendix_R_programming/)

## Using the examples

Open an example folder and follow its README. Run the R script with that folder as the working directory, keeping any accompanying CSV files beside it. Install the packages loaded by the script first. Examples with saved data use the same observations as the revised manuscript; examples using a live service obtain the data available when they are run.

The Chapter 9 [covariance examples](Chapter_9_Continuous_Time_Finance/Noise_Robust_Covariance/) implement two-scale covariance with a common finite-sample correction, and both bias-corrected and positive-semidefinite pre-averaging. The [TSRV example](Chapter_9_Continuous_Time_Finance/Intraday_Fixed_Sample/) uses a bundled public trade sample from `highfrequency`: 43,581 trades in three assets on 17 September 2014. Both examples run without an API key.

The Chapter 6 [aersn example](Chapter_6_HAR_Inference/AERSN_Multivariate_Inference/) compares multivariate adjusted-range and quadratic self-normalization, with joint confidence regions, simultaneous contrast intervals and selected regression coefficients.

Figure examples include [normal and Student t densities](Chapter_1_Regression_Models/Student_t_Normal_Densities/), the [boundary-bias simulation](Chapter_5_Nonparametric_Methods/NW_Local_Linear_Boundary_Bias/) and the [iris correlation matrix](Appendix_R_programming/Iris_Correlation_Plot/). The density, boundary-bias and joint-confidence-region examples include the plotting code printed in the book.
