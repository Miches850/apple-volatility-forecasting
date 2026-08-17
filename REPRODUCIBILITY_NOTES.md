# Reproducibility Notes

Repository 6 contains the original data workbook and retained R code, but several inconsistencies should be corrected before the project is described as fully audited.

## 1. Written report selects GARCH(1,1); code selects GARCH(1,2)

The submitted write-up states that GARCH(1,1) had the smallest unrounded SIC and identifies it as the preferred GARCH model.

The retained code instead contains:

`best_garch <- garch12`

and later uses GARCH(1,2) in the rolling forecast loop.

### Final correction

Rerun all four GARCH models, capture the full-precision SIC values, select the actual minimum, and use that same model consistently for:
- diagnostics;
- full-sample fit;
- test-period volatility proxy;
- rolling forecasts;
- report text;
- README.

## 2. Mean-equation specification mismatch

The written homework describes the mean model as ARIMA(0,0,1).

The retained `garchFit()` calls use:

`arma(0,2)`

inside every ARCH/GARCH specification.

These are not the same mean structure.

### Final correction

Confirm the `auto.arima()` result from the training data. Then pass the matching ARMA orders into all ARCH/GARCH models, unless there is a documented reason for choosing a different mean equation.

## 3. "ndiffs confirms stationarity" wording should be tightened

The submitted report says `ndiffs()` yielded zero and "confirmed" stationarity.

`ndiffs()` returning zero supports the conclusion that no regular differencing is recommended, but it should not be described as a standalone proof of stationarity.

### Final correction

Use wording such as:
"`ndiffs()` recommended zero additional differences for the return series."

If desired, add an explicit ADF/KPSS check during the correction pass.

## 4. Forecast comparison uses absolute residuals as an actual-volatility proxy

The assignment itself defines the comparison measure as the absolute residual from a full-sample GARCH fit.

This is therefore faithful to the assignment, but it is not directly observed latent volatility.

### Final correction

Label the red comparison line consistently as an **absolute-residual volatility proxy**, not literal observed volatility.

## 5. Forecast-loop model consistency

The forecast loop predicts from the current fitted ARCH/GARCH objects, then extends the data and re-estimates the models for the next step.

This is broadly consistent with recursive one-step-ahead forecasting, but the exact selected GARCH model must first be corrected.

### Final correction

After model selection is reconciled, rerun the entire 26-step recursive procedure and save a forecast table with:
- date;
- ARCH forecast;
- GARCH forecast;
- absolute-residual proxy.

## 6. Data provenance

The Apple workbook is retained, but the public repository should document its original market-data provider if known and confirm that redistribution is permitted.

## 7. Public privacy

The original homework documents contain a university identification number.

Keep the original files private and continue using only the public summary and path-redacted code in GitHub.

## Recommended publication position

This is a strong financial-time-series portfolio project because it demonstrates volatility clustering, ARCH/GARCH estimation, model comparison, and recursive forecasting.

The final pass should reconcile the preferred GARCH specification and the mean equation before the repository is called fully reproducible.
