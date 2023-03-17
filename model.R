library(readxl)
library(dplyr)
library(xgboost)
set.seed(123) # for reproducibility
data <- read_excel("data/2023-student-research-hazard-event-data.xlsx")

colnames(data) <- c(
  "region", 
  "hazard_event", 
  "quarter", 
  "year", 
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



# Sampling for GLM with gamma link:
sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob=c(0.7,0.3))

train <- data[sample, ]
# train %>% count(region)

x_train <- as.matrix(train[1:(length(train)-1)])
y_train <- as.matrix(train[, 8])

test <- data[!sample, ]
x_test <- as.matrix(test[1:(length(test)-1)])
y_test <- as.matrix(test[, 8])
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

# make predictions on the test set
y_pred <- predict(xgb_model, x_test)

calc_mse <- function(predicted, actual) {
  print(length(actual))
  return(sum((actual - predicted)^2) / length(actual))
}

# Max depth 3: 6.208e+16
# Max depth 20: 5.765571e+16

print(calc_mse(y_pred, y_test))






