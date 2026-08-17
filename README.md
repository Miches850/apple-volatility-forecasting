# Apple Volatility Forecasting

**Course:** ECMT 674 - Economic Forecasting  
**Primary tool:** R  
**Project type:** Financial time-series volatility modeling  
**Data:** Apple daily stock prices, January 2, 2015 - April 7, 2025

## Project overview

This repository documents an R-based volatility-forecasting assignment using daily Apple stock-price data.

The analysis converts Apple closing prices into daily log returns measured in basis points, diagnoses volatility clustering and ARCH behavior, compares ARCH and GARCH specifications, and generates 26 one-step-ahead conditional-standard-deviation forecasts for a held-out test period.

## What this project demonstrates

- financial return construction from daily prices;
- log-return transformation and basis-point scaling;
- stationarity/differencing checks with `ndiffs()`;
- train/test sample design;
- ARIMA mean-model estimation;
- squared-residual diagnostics;
- ACF/PACF interpretation;
- ARCH-effect testing using lagged squared residuals;
- ARCH model comparison;
- GARCH model comparison;
- Schwarz Information Criterion (SIC) selection logic;
- rolling one-step-ahead volatility forecasting;
- residual-based volatility proxies;
- forecast-versus-realized-volatility visualization.

## Data

The original course workbook is included as:

`data/APPL.xlsx`

The assignment states that the `Daily` worksheet contains Apple Open, High, Low, and Close prices from **January 2, 2015 through April 7, 2025**.

Daily returns are constructed as:

`10000 × diff(log(Close))`

so returns are expressed in basis points.

## Train/test design

The assignment defines:

- training observations: **1 through 2,554**
- held-out test observations: **2,555 through 2,580**
- test horizon: **26 trading days**

## ARCH-effect evidence

The submitted analysis reports strong autocorrelation in squared ARIMA residuals and estimates a four-lag squared-residual regression.

Reported lag coefficients include:

| Lag | Coefficient | Reported p-value |
|---|---:|---:|
| 1 | 0.190 | < 2e-16 |
| 2 | 0.160 | < 2.4e-15 |
| 3 | 0.027 | ~0.17 |
| 4 | 0.110 | < 2.3e-08 |

The overall regression was reported as highly significant with an F-statistic of approximately **79.7** and p-value **< 2.2e-16**, supporting the presence of ARCH effects.

## ARCH model comparison

| Model | Reported SIC |
|---|---:|
| ARCH(2) | 13.104 |
| ARCH(3) | 13.087 |
| **ARCH(4)** | **13.075** |

The submitted write-up therefore selected **ARCH(4)** among the ARCH specifications.

## GARCH model comparison

The submitted write-up reports approximately:

| Model | Reported SIC |
|---|---:|
| GARCH(1,1) | 13.027 |
| GARCH(1,2) | 13.027 |
| GARCH(2,1) | 13.028 |
| GARCH(2,2) | 13.028 |

The written submission identifies **GARCH(1,1)** as the preferred GARCH model after examining the unrounded fit statistics.

A code/report inconsistency exists in the retained R script: the code later assigns and forecasts with `GARCH(1,2)`. That issue is deliberately documented rather than silently corrected here. See `docs/REPRODUCIBILITY_NOTES.md`.

## Submitted forecast interpretation

The final forecast figure compares:

- ARCH forecast;
- GARCH forecast;
- an "actual volatility" proxy based on the absolute residual from a full-sample GARCH fit.

The submitted discussion describes the GARCH forecast as smoother and more persistent, while the ARCH forecast responds more sharply to recent shocks.

## Selected submitted figures

### Daily Apple returns

![Daily Apple returns](figures/submitted_figure_01.png)

### Squared-residual diagnostics

![Squared-residual diagnostics](figures/submitted_figure_02.png)

### Volatility forecasts vs. actual-volatility proxy

![Volatility forecast comparison](figures/submitted_figure_03.png)

## Repository structure

```text
6_apple-volatility-forecasting/
├── README.md
├── LICENSE_CODE.txt
├── .gitignore
├── code/
│   ├── apple_volatility_submitted_path_redacted.R
│   ├── apple_volatility_portable.R
│   └── README.md
├── data/
│   ├── APPL.xlsx
│   └── README.md
├── figures/
│   ├── submitted_figure_01.png
│   ├── submitted_figure_02.png
│   ├── submitted_figure_03.png
│   └── README.md
├── report/
│   ├── Apple_Volatility_Forecasting_Public_Summary.docx
│   └── README.md
├── outputs/
│   ├── reported_arch_effect_regression.csv
│   ├── reported_arch_sic.csv
│   ├── reported_garch_sic.csv
│   └── README.md
├── docs/
│   ├── PROJECT_SUMMARY.md
│   ├── METHODOLOGY_SUMMARY.md
│   ├── REPRODUCIBILITY_NOTES.md
│   └── GITHUB_UPLOAD_GUIDE.md
└── reference/
    └── README.md
```

## Reproducibility status

**Strong portfolio artifact; model-selection reconciliation required before calling it fully audited.**

The original Apple workbook and retained R script are present. However, the submitted written report and code disagree on the preferred GARCH model, and the mean-equation specification in the GARCH calls should also be reconciled with the ARIMA model selected earlier in the assignment.

See `docs/REPRODUCIBILITY_NOTES.md`.

## Suggested GitHub description

> R-based Apple stock volatility project using ARIMA residual diagnostics, ARCH-effect testing, ARCH/GARCH model comparison, SIC selection, and 26 one-step-ahead conditional-volatility forecasts.

## Suggested topics

`r` `garch` `arch` `volatility` `time-series` `apple-stock` `financial-econometrics` `forecasting` `financial-data` `risk-analysis`

## Privacy

The original homework submission contains a university identification number. The public portfolio package therefore includes a clean project summary rather than the original submitted PDF/Word file.

## Disclaimer

This repository documents an academic volatility-modeling exercise. It is not investment advice, a trading strategy, or a production risk system.
