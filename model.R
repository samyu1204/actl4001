library(readxl)
library(dplyr)
library(xgboost)
library(forecast)
library(ROCR)
library(vars)

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

# Moving Average (IT WORKS)
MA2 <- ma(eco_dem_data$Inflation, order = 5, centre = TRUE)
MA2
forecastMA2 <- forecast(MA2, h = 10)
forecastMA2
accuracy(forecastMA2)


# Keven's Code:
demodata <- read_excel("data/2023-student-research-eco-dem-data.xlsx", 2)

#Projection of population for the next 10 years
poptable <- demodata[c(9,8,7),]

colnames(poptable) <- demodata[6,]

#Changing columns to numeric
poptable$'Region 1'<- as.numeric(poptable$'Region 1')
poptable$'Region 2'<- as.numeric(poptable$'Region 2')
poptable$'Region 3'<- as.numeric(poptable$'Region 3')
poptable$'Region 4'<- as.numeric(poptable$'Region 4')
poptable$'Region 5'<- as.numeric(poptable$'Region 5')
poptable$'Region 6'<- as.numeric(poptable$'Region 6')

#Average population growth rate over 2019-2021 period
growth <- c(0,0,0,0,0,0)
for (i in 2:7){
  print(i)
  ave <- mean(c(as.numeric(poptable[2,i]/poptable[1,i]),as.numeric(poptable[3,i]/poptable[2,i])))
  print(ave)
  growth[i-1] <- ave
}

#Projecting next 10 years using found growth rates
popproj <- data.frame()

#Region
for (i in (1:6)){
  #year 1 projection
  popproj[1,i] <- poptable[3,i+1]*growth[i]
  #year 2-10 projection
  for (j in (2:10)){
    popproj[j,i] <- popproj[j-1,i]*growth[i]
  } 
}

#Property value distribution
pvd <-demodata[c(37:49),]
colnames(pvd) <- demodata[6,]
pvd$'Region 1'<- as.numeric(pvd$'Region 1')
pvd$'Region 2'<- as.numeric(pvd$'Region 2')
pvd$'Region 3'<- as.numeric(pvd$'Region 3')
pvd$'Region 4'<- as.numeric(pvd$'Region 4')
pvd$'Region 5'<- as.numeric(pvd$'Region 5')
pvd$'Region 6'<- as.numeric(pvd$'Region 6')

#Replacing first column with average value
firstcolumn <-c(25000,75000,125000,175000,225000,275000,350000,450000,625000,875000,1250000,1750000,2000000)
pvd[,1] <- firstcolumn


#Expected property value
pvd1 <- data.frame()

for (i in (1:6)){
  for (j in (1:13)){
    pvd1[j,i] <- pvd[j,1]*pvd[j,i+1] 
  }
}

epv <- c()
for (i in (1:6)){
  epv[i] <- sum(pvd1[,i])  
}

#In order from lowest to highest expected property value: Region 4,5,6,3,2,1

#Household goods value ranges from 5-10% of property value
hhgoodsval <- epv*0.05


#Accommodation costs
#With the assumptions that accommodation is only sourced for 3 weeks after claim, and the found accommodation is based on property value to replicate "quality of life"
weeka <- 3
accomval <- epv*0.001*weeka
#Modelling with inflation


#Psychological impacts
#With the assumption that psychological treatment is only sourced for 5 weeks after claim
weekb <- 5
psychoval <- epv*0.00075*weekb
#Modelling with inflation


#Combined insured amount (pre-inflation)
insured <- hhgoodsval + accomval + psychoval

inflation <- as.vector(forecastMA2$mean) + 1

postinsured <- data.frame()
for(i in (1:6)){
  postinsured[1, i] <- insured[i]
  for(j in (2:10)){
    postinsured[j, i] <- postinsured[j-1, i] * inflation[j]
  }
}


#Combined insured amount (post-inflation) for the next 10 years
#using a loop that creates 10 lines using insured + inflation

#Probability of claims over the next 10 years


#Claim cost prediction
#post inflation x probability of claim


#voluntary vs involuntary displacement
# maybe additional expected cost for involuntary displacement

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


# 
sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob=c(0.7,0.3))

train <- data[sample, ]
# train %>% count(region)

x_train <- as.matrix(subset(train, select = -c(property_damage, hazard_event)))
y_train <- as.matrix(subset(train, select = c(property_damage)))

y_train_binary <- ifelse(y_train == 0.001, 0, 1)

test <- data[!sample, ]
x_test <- as.matrix(subset(test, select = -c(property_damage, hazard_event)))
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
  return(sum((actual - predicted)^2) / length(actual))
}

# Max depth 3: 6.208e+16
# Max depth 20: 5.765571e+16
# New without hazards: 3084333201679640
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


# Probability prediction
xgb_classification_model <- xgb.XGBClassifier(
  'max_depth': 7,
  'n_estimators': 50,
  'learning_rate': 0.5,
)

xgb_model_prob <- xgboost(
  data = x_train, label = y_train_binary, 
  nrounds = 100, 
  objective = "binary:logistic", 
  eval_metric = "auc"
  )

y_pred_prob <- predict(xgb_model_prob, x_test)



