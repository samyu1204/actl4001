library(readxl)
library(dplyr)
library(xgboost)
library(forecast)
library(ROCR)

set.seed(123) # for reproducibility
data <- read_excel("data/2023-student-research-hazard-event-data.xlsx")
options(scipen = 999)

colnames(data) <- c(
  "region", 
  "hazard_event", 
  "quarter", 
  "Year", 
  "duration", 
  "fatalities", 
  "injuries", 
  "property_damage"
  )
# Convert hazard event to categorical event
data$hazard_event <- as.factor(data$hazard_event)
# Convert into numbers
data$hazard_event <- as.numeric(data$hazard_event)
# Gamma cannot have zero value
data[data == 0] <- 0.001


# Inflation data:
eco_dem_data <- read_excel("data/2023-student-research-eco-dem-data.xlsx", sheet = "Inflation-Interest")

# Maybe Remove NA's and Outliers
eco_dem_data = eco_dem_data[-c(42), ]
eco_dem_data = na.omit(eco_dem_data)

# Graphs to see relationship
plot(eco_dem_data$Year, eco_dem_data$Inflation, type = 'l', lwd = 3, ylim = c(0, 0.2))
lines(eco_dem_data$Year, eco_dem_data$`Government Overnight Bank Lending Rate`, col = 'red')
lines(eco_dem_data$Year, eco_dem_data$`1-yr risk free rate`, col = 'green')
lines(eco_dem_data$Year, eco_dem_data$`10-yr risk free rate`, col = 'blue')

# Make the time series
TS <- ts(eco_dem_data$Inflation, start = eco_dem_data$Year[1], frequency = 1)


# # ARIMA Model
# arima_model <- auto.arima(TS)
# pred_ARIMA <- forecast(arima_model, h = 10)
# pred_ARIMA
# 
# # ARMA Model 
# # https://rpubs.com/JSHAH/481706
# AR <- arima(TS, order = c(1,0,0))
# pred_AR <- predict(AR, n.ahead = 10)
# pred_AR


# Moving Average (Constant Prediction)
MA <- ma(TS, order = 2, centre = TRUE)
MA
forecastMA <- forecast(MA, h = 10)
forecastMA
accuracy(forecastMA)

# Moving Average (IT WORKS)
MA2 <- ma(eco_dem_data$Inflation, order = 5, centre = TRUE)
MA2
forecastMA2 <- forecast(MA2, h = 30)
forecastMA2
accuracy(forecastMA2)

# Add inflation to data:
data <- left_join(data, eco_dem_data, by = "Year", multiple = "all")
colnames(data) <- c(
  "region", 
  "hazard_event", 
  "quarter", 
  "Year", 
  "duration", 
  "fatalities", 
  "injuries", 
  "property_damage",
  "inflation",
  "bank_rate",
  "one_year_risk_rate",
  "ten_year_risk_rate"
)


# Sampling for GLM with gamma link:
sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob=c(0.7,0.3))

train <- data[sample, ]
# train %>% count(region)

x_train <- as.matrix(subset(train, select = -c(property_damage)))
y_train <- as.matrix(subset(train, select = c(property_damage)))

test <- data[!sample, ]
x_test <- as.matrix(subset(test, select = -c(property_damage)))
y_test <- as.matrix(subset(test, select = c(property_damage)))
# test %>% count(region)

gamma_param <- list(
  objective = "reg:gamma",
  gamma = 1,
  max_depth = 20,
  eta = 0.5
)

xgb_model <- xgboost(
  data = x_train,
  label = y_train,
  params = gamma_param,
  nrounds = 100
)

summary(xgb_model)

# make predictions on the test set
y_pred <- predict(xgb_model, x_test)

calc_mse <- function(predicted, actual) {
  print(length(actual))
  return(sum((actual - predicted)^2) / length(actual))
}

# Max depth 3: 6.208e+16
# Max depth 20: 5.765571e+16
print(calc_mse(y_pred, y_test))

# Graphs:
# Plot prediction distribution
plot(density(y_pred), main = "Prediction Distribution", xlab = "Predicted Value")
lines(density(y_test), col = "red")
legend("topright", legend = c("Predicted", "Actual"), col = c("black", "red"), lty = 1)

# Feature importance
# Plot feature importance
xgb.plot.importance(importance_matrix = 
                      xgb.importance(feature_names = names(x_train), model = xgb_model),
                      main = "Importance Feature")


