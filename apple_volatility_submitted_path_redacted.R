# ---------------------------------------------
# ECMT 674 - Homework 4: Volatility Forecasting
# ---------------------------------------------

# Load required libraries
library(tidyverse)
library(tseries)
library(forecast)
install.packages("fGarch")
library(fGarch)
library(dynlm)
library(readxl)

# ---------------------------
# Question 1: Load + Returns
# ---------------------------

# Read the APPL.xlsx daily data (Close price)
appl_data <- read_excel("[local path]/APPL.xlsx", sheet = "Daily")
close <- ts(appl_data$Close, frequency = 1)

# Calculate daily returns in basis points
ret_appl <- 10000 * diff(log(close))

# 1a: Check stationarity
ndiffs(ret_appl)

# 1b: Plot returns
autoplot(ret_appl) + 
  ggtitle("Daily Returns for Apple Stock in Basis Points") +
  theme_minimal()

# ---------------------------
# Question 2: Create Training Set + Fit ARIMA
# ---------------------------

# Split into training (1 to 2554) and test (2555–2580)
train_appl <- window(ret_appl, end = 2554)

# Fit ARIMA model to training data
arima_fit <- auto.arima(train_appl, seasonal = FALSE, stepwise = FALSE, approximation = FALSE)
summary(arima_fit)

# 2a: Check ARCH effects — Squared residuals
res_sq <- residuals(arima_fit)^2
tsdisplay(res_sq)

# 2b: dynlm regression on squared residuals (4 lags)
res_sq_fit <- dynlm(res_sq ~ L(res_sq, 1) + L(res_sq, 2) + L(res_sq, 3) + L(res_sq, 4))
summary(res_sq_fit)

# -------------------------------------
# Question 3: ARCH(p) Models, p = 2,3,4
# -------------------------------------

arch2 <- garchFit(formula = ~ arma(0,2) + garch(2,0), data = train_appl, trace = FALSE)
arch3 <- garchFit(formula = ~ arma(0,2) + garch(3,0), data = train_appl, trace = FALSE)
arch4 <- garchFit(formula = ~ arma(0,2) + garch(4,0), data = train_appl, trace = FALSE)

# Compare SIC
arch_sic <- c(
  arch2@fit$ics["SIC"],
  arch3@fit$ics["SIC"],
  arch4@fit$ics["SIC"]
)
names(arch_sic) <- c("ARCH(2)", "ARCH(3)", "ARCH(4)")
arch_sic  # use this to confirm lowest SIC

# Select ARCH(4) as best model based on SIC
best_arch <- arch4
summary(best_arch)

# -------------------------------------
# Question 4: GARCH(p,q) Models
# -------------------------------------

garch11 <- garchFit(formula = ~ arma(0,2) + garch(1,1), data = train_appl, trace = FALSE)
garch12 <- garchFit(formula = ~ arma(0,2) + garch(1,2), data = train_appl, trace = FALSE)
garch21 <- garchFit(formula = ~ arma(0,2) + garch(2,1), data = train_appl, trace = FALSE)
garch22 <- garchFit(formula = ~ arma(0,2) + garch(2,2), data = train_appl, trace = FALSE)

# Compare SIC
garch_sic <- c(
  garch11@fit$ics["SIC"],
  garch12@fit$ics["SIC"],
  garch21@fit$ics["SIC"],
  garch22@fit$ics["SIC"]
)
names(garch_sic) <- c("GARCH(1,1)", "GARCH(1,2)", "GARCH(2,1)", "GARCH(2,2)")
garch_sic  # update best model below based on output

# Select best GARCH model by lowest SIC
best_garch <- garch12  # update this after running SIC comparison
summary(best_garch)

# -------------------------------------
# Question 5: One-Step-Ahead Forecasts
# -------------------------------------

# Re-estimate best models using full sample for test period residuals
full_arch <- garchFit(formula = ~ arma(0,2) + garch(4,0), data = ret_appl, trace = FALSE)
full_garch <- garchFit(formula = ~ arma(0,2) + garch(1,2), data = ret_appl, trace = FALSE)

# Absolute residuals for final 26 days
resid_actual <- abs(full_garch@residuals[2555:2580])
resid_actual <- ts(resid_actual, frequency = 1)

# Rolling one-step-ahead forecasts
arch_os_fore <- ts(0, frequency = 1, start = 1, end = 26)
garch_os_fore <- ts(0, frequency = 1, start = 1, end = 26)

ret <- window(ret_appl, end = 2554)

for (j in 1:26) {
  arch_pred <- predict(arch4, n.ahead = 1, mse = "cond")
  garch_pred <- predict(garch12, n.ahead = 1, mse = "cond")
  arch_os_fore[j] <- arch_pred[,3]
  garch_os_fore[j] <- garch_pred[,3]
  i <- j + 2554
  ret <- window(ret_appl, end = i)
  arch4 <- garchFit(formula = ~ arma(0,2) + garch(4,0), data = ret, trace = FALSE)
  garch12 <- garchFit(formula = ~ arma(0,2) + garch(1,2), data = ret, trace = FALSE)
}

# Plot: ARCH vs GARCH vs Actual
autoplot(arch_os_fore, series = "ARCH Forecast") +
  autolayer(garch_os_fore, series = "GARCH Forecast") +
  autolayer(resid_actual, series = "Actual Volatility") +
  ggtitle("Volatility Forecasts vs Actual Volatility (Apple Returns)") +
  ylab("Standard Deviation") +
  theme_minimal()

