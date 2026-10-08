# Fixed intraday sample: two-scale realised variance

This example accompanies Chapter 9 of *Econometrics and Time Series Methods:
Theory, Applications, and R Implementation*.

## Data

The CSV and RDS contain `sampleMultiTradeData` from **highfrequency 1.0.1**:
43,581 trades on 17 September 2014, with pseudonymised symbols AAA (7,848),
BBB (19,540) and ETF (16,193). The RDS preserves the package object. The CSV
preserves its recorded clock values, including subsecond precision, with the
package's UTC timezone attribute. Those clock labels are used as supplied;
the example does not infer or convert their exchange timezone.

Source: https://github.com/jonathancornelissen/highfrequency
Dataset documentation: https://github.com/jonathancornelissen/highfrequency/blob/master/man/sampleMultiTradeData.Rd

The upstream package is licensed under GPL (>= 2); its DESCRIPTION and a copy
of GPL version 2 accompany these files. For the software, see Boudt, Kleen and
Sjørup (2022), *Journal of Statistical Software*, 104(8), 1–36,
https://doi.org/10.18637/jss.v104.i08. The data and attribution are redistributed
from that package; the original providers and package authors retain their rights.

## Run

Open this folder as the working directory and run:

```r
source("tsrv_fixed_sample.R", print.eval = TRUE)
```

Only base R is required. No API key, subscription or network request is needed
at runtime. `prepare_intraday_sample.R` contains the preparation step on its own.

After retaining the last trade at duplicated timestamps, the code uses
preceding-trade interpolation on a ten-second grid restricted to the interval
observed for every asset. This produces 2,339 prices and 2,338 returns per asset,
from 09:30:10 to 15:59:50. It never fills a grid time with a future trade.

For AAA, K = 176, realised variance is 0.0006761835 and TSRV is 0.0001794451.
Both estimates cover this interval and are unannualised. The latent integrated
variance is unknown, so their difference is not an observed estimation error.
The bundled `tsrv_result.txt` records the script's output.

Book resources: https://econometricsandtimeseries.com/
