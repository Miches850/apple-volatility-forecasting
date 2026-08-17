# Project Summary

## Objective

Model and forecast the conditional volatility of Apple daily stock returns using ARCH and GARCH methods.

## Workflow

1. Import Apple daily prices.
2. Calculate daily close-to-close log returns in basis points.
3. Check whether additional differencing is needed.
4. Reserve 26 observations as a test sample.
5. Estimate an ARIMA mean model on the training sample.
6. Diagnose ARCH effects through squared residuals.
7. Regress squared residuals on four lags.
8. Compare ARCH(2), ARCH(3), and ARCH(4) using SIC.
9. Compare four GARCH(p,q) models using SIC.
10. Generate 26 one-step-ahead conditional-standard-deviation forecasts.
11. Compare model forecasts to an absolute-residual volatility proxy.

## Professional relevance

The project demonstrates financial time-series transformation, volatility-clustering diagnosis, ARCH/GARCH modeling, information-criterion comparison, held-out forecast design, and rolling conditional-volatility forecasting in R.
