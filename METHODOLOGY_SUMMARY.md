# Methodology Summary

## Return construction

The assignment defines daily Apple returns as:

`return_t = 10000 × [log(Close_t) - log(Close_(t-1))]`

This expresses the log return in basis points.

## Sample split

The daily return series contains 2,580 observations after differencing prices.

Training:
- observations 1-2554

Test:
- observations 2555-2580
- 26 trading days

## Mean-model stage

The assignment directs the student to use `auto.arima()` on the training sample and carry the selected mean-model structure into the ARCH/GARCH specifications.

The written homework describes the fitted mean model as ARIMA(0,0,1).

## ARCH diagnosis

Squared residuals from the ARIMA model are inspected through:
- time plot
- ACF
- PACF

A dynamic regression of squared residuals on four lags is also used to test whether lagged squared innovations predict current squared innovations.

## Volatility models

ARCH candidates:
- ARCH(2)
- ARCH(3)
- ARCH(4)

GARCH candidates:
- GARCH(1,1)
- GARCH(1,2)
- GARCH(2,1)
- GARCH(2,2)

Models are compared using the Schwarz Information Criterion.

## Forecast evaluation

The assignment requests 26 one-step-ahead conditional-standard-deviation forecasts from the preferred ARCH and GARCH models.

The "actual volatility" comparison proxy is the absolute residual from the preferred GARCH model fit to the full sample, for the final 26 observations.
