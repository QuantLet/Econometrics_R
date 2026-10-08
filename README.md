# Econometrics and Time Series Methods

R examples and accompanying data for *Econometrics and Time Series Methods: Theory, Applications, and R Implementation*.

The [companion website](https://econometricsandtimeseries.com/) provides chapter guides, online lectures and selected exercises with hints.

## Chapters

- [Chapter 1 Regression Models](Chapter%201%20Regression%20Models/)
- [Chapter 2 Univariate Time Series](Chapter%202%20Univariate%20Time%20Series/)
- [Chapter 3 Multivariate Linear Time Series](Chapter%203%20Multivariate%20Linear%20Time%20Series/)
- [Chapter 4 Volatility Models](Chapter%204%20Volatility%20Models/)
- [Chapter 5 Nonparametric Methods](Chapter%205%20Nonparametric%20Methods/)
- [Chapter 6 HAR Inference](Chapter%206%20HAR%20Inference/)
- [Chapter 7 Filtering](Chapter%207%20Filtering/)
- [Chapter 8 Nonstationary Processes](Chapter%208%20Nonstationary%20Processes/)
- [Chapter 9 Continuous Time Finance](Chapter%209%20Continuous%20Time%20Finance/)
- [Chapter 10 Selected Machine Learning Tools for Econometrics in R](Chapter%2010%20Selected%20Machine%20Learning%20Tools%20for%20Econometrics%20in%20R/)

- [Appendix: R programming](Appendix%20R%20programming/)

## Using the examples

Open an example folder and follow its README. Run the R script with that folder as the working directory, keeping any accompanying CSV files beside it. Install the packages loaded by the script first. Examples with saved data use the same observations as the revised manuscript; examples using a live service obtain the data available when they are run.

The Chapter 4 [news impact curves](Chapter%204%20Volatility%20Models/News_Impact_Curves/) reproduce Figure 4.1, comparing symmetric ARCH/GARCH and asymmetric EGARCH responses with the lagged variance held fixed.

The Chapter 9 [pre-averaging example](Chapter%209%20Continuous%20Time%20Finance/Preaveraging_Covariance/) contains the explicit noise-bias correction for covariance estimation. The simulated intraday illustration requires no API key; the separate TSRV example uses an Alpha Vantage key supplied through the environment.

The Chapter 6 [aersn example](Chapter%206%20HAR%20Inference/AERSN_Multivariate_Inference/) compares multivariate adjusted-range and quadratic self-normalization, with joint confidence regions, simultaneous contrast intervals and selected regression coefficients.

Figure examples include [normal and Student t densities](Chapter%201%20Regression%20Models/Student_t_Normal_Densities/), the [CART partition](Chapter%2010%20Selected%20Machine%20Learning%20Tools%20for%20Econometrics%20in%20R/CART_Partition/) and the [iris correlation matrix](Appendix%20R%20programming/Iris_Correlation_Plot/). Their legends and colour scales are placed below the plotting area.
