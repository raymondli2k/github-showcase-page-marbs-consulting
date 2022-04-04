# SOA CASE STUDY
# ECONOMIC IMPACT

# load packages

library(FitAR)
library(forecast)
library(ggplot2)
library(tidyverse)
library(FitAR)
library(glmnet)
library(leaps)
library(caret)
library(forcasts)
library(tidyverse)
library(dplyr)
library(GGally)
library(broom)


# INFLATION TIME SERIES

# insert and tidy data
data<-read.csv(file.choose()) # choose "Inflation.csv"
colnames(data)<-c("Time","InflationRate")
head(data)

data$InflationRate <- as.numeric(data$InflationRate)
tail(data)

# time series with cpi
cpi <- ts(data$InflationRate, frequency = 1, start = c(1991))


# make the data frame

tidy_data <- data.frame(
  date = seq(as.Date("1991-12-01"), as.Date("2020-12-01"), by = "year"),
  cpi = cpi
)
tidy_data

# plot 
p <- ggplot(tidy_data, aes(x=date, y=cpi)) +
  geom_line(color="red", size=1.1) +
  theme_minimal() +
  xlab("") +
  ylab("Consumer Price Index") +
  ggtitle("Rarita's Consumer Price Index", subtitle = "From December 1991 Until December 2020")
p

# Get the statistical summary
# Returns data frame and sort based on the CPI
tidy_data %>%
  arrange(desc(cpi))
tidy_data %>%
  arrange(cpi)

acf(cpi, plot = T, main = "ACF Plot of CPI", xaxt="n")
pacf(cpi, plot = T, main = "PACF Plot of CPI", xaxt="n")

fit_2<-auto.arima(cpi)

# plot fitted model
residuals_2 <- residuals(fit_2)
fit_2_fitted <- cpi - residuals_2
ts.plot(cpi, main="CPI vs Fitted CPI 1991-2020")
legend(x="topright",inset = 0.05, legend=c("CPI", "CPI Fitted"),col=c("black", "red"), lty=1:2, cex=0.8)
points(fit_2_fitted, type = "l", col = 2, lty = 2)


# testing accuracy of fit and residuals
Box.test(resid(fit_2),type="Ljung",lag=20,fitdf=3)
acf(fit_2$residuals, main='ACF of Fitted CPI Residuals')
qqnorm(fit_2$residuals)
qqline(fit_2$residuals)

accuracy(fit_2)


# predict next 11 observations from 2021-2031
forc<-forecast(fit_2, 11)
plot(forecast(fit_2, 11))

forc

# _____________________________________________________________________________

# HOUSEHOLD SAVINGS TIME SERIES

# load data
HSdata<-read.csv(file.choose()) # insert Household.csv

colnames(HSdata)<-c("Time","Household Savings Rate")
HSdata$`Household Savings Rate` <- as.numeric(HSdata$`Household Savings Rate`)

# transform into time series
HS_R <- ts(HSdata$`Household Savings Rate`, frequency = 1, start = c(2011))

# Plot acf and pacf
acf(HS_R, plot = T, main = "ACF Plot of HSR", xaxt="n")
pacf(HS_R, plot = T, main = "PACF Plot of HSR", xaxt="n")

# arima(0,0,0) with non-zero mean
fit_hs_r<-auto.arima(HS_R)

# plot fitted model
residuals_hs_r <- residuals(fit_hs_r)
fitted_hs_r <- HS_R - residuals_hs_r
ts.plot(HS_R, main="HSR vs Fitted HSR")
points(fitted_hs_r, type = "l", col = 2, lty = 2)

# testing accuracy and residuals
Box.test(resid(fit_hs_r),type="Ljung",lag=5,fitdf=1)
acf(fit_hs_r$residuals, main="ACF of Fitted HSR Residuals")
qqnorm(fit_hs_r$residuals)
qqline(fit_hs_r$residuals)

accuracy(fit_hs_r)

# predict next 11 observations
forc_hs_r<-forecast(fit_hs_r, 11)
plot(forecast(fit_hs_r, 11))

forc_hs_r


# ____________________________________________________________________________

# HEALTHCARE SPENDING TIME SERIES

# Import Data
Healthdata<-read.csv(file.choose()) # Healthcare.csv

# make numeric
colnames(Healthdata)<-c("Time","Healthcare spending per capita")
Healthdata$`Healthcare spending per capita` <- as.numeric(Healthdata$`Healthcare spending per capita`)

# time series
Health_R <- ts(Healthdata$`Healthcare spending per capita`, frequency = 1, start = c(2011))

# acf and pacf
acf(Health_R, plot = T, main = "ACF Plot of Healthcare Spending", xaxt="n")
pacf(Health_R, plot = T, main = "PACF Plot of Healthcare Spending", xaxt="n")

# arima(0,1,0) with drirft
fit_health_r<-auto.arima(Health_R)

# plot fitted model
residuals_health_r <- residuals(fit_health_r)
fitted_health_r <- Health_R - residuals_health_r
ts.plot(Health_R, main="Healthcare Spending vs Fitted Healthcare Spending")
points(fitted_health_r, type = "l", col = 2, lty = 2)

# test accuracy and residuals
Box.test(resid(fit_health_r),type="Ljung",lag=10,fitdf=1)
acf(fit_health_r$residuals, main="ACF of Fitted Healthcare residuals")
qqnorm(fit_health_r$residuals)
qqline(fit_health_r$residuals)

accuracy(fit_health_r)

# predict next 11 observations
forc_health_r<-forecast(fit_health_r, 11)
plot(forecast(fit_health_r, 11))

forc_health_r


# ____________________________________________________________________________


# Population Time Series

# import data 
population<-read.csv(file.choose()) # Population.csv
population$Population<-as.numeric(population$Population)

# time series
pop <- ts(population$Population, frequency = 1, start = c(2011))

# acf and pacf
acf(pop, plot = T, main = "ACF Plot of Population", xaxt="n")
pacf(pop, plot = T, main = "PACF Plot of Population", xaxt="n")

# arima(0,1,0) with drift
fit_pop<-auto.arima(pop)

# plot fitted vs population
residuals_pop <- residuals(fit_pop)
fitted_pop <- pop - residuals_pop
ts.plot(pop, main="Population vs Fitted Population")
points(fitted_pop, type = "l", col = 2, lty = 2)

# accuracy and residuals
Box.test(resid(fit_pop),type="Ljung",lag=2,fitdf=1)
acf(fit_pop$residuals, main="ACF of Fitted Population")
qqnorm(fit_pop$residuals)
qqline(fit_pop$residuals)

accuracy(fit_pop)

# predict next 11 observations
forc_pop<-forecast(fit_pop, 11)
plot(forecast(fit_pop, 11))

forc_pop


# _____________________________________________________________________________


# GDP TIME SERIES

# import data
GDPdata<-read.csv(file.choose()) # GDP.csv

# make data numeric
GDPRarita<-GDPdata[,c(1,5)]
colnames(GDPRarita)<-c("Time","GDP per capita")
GDPRarita$`GDP per capita` <- as.numeric(GDPRarita$`GDP per capita`)

# time series
GDP_R <- ts(GDPRarita$`GDP per capita`, frequency = 1, start = c(2011))

# acf and pacf
acf(GDP_R, plot = T, main = "ACF Plot of GDP", xaxt="n")
pacf(GDP_R, plot = T, main = "PACF Plot of GDP", xaxt="n")

# arima(0,1,0) with drift
fit_gdp_r<-auto.arima(GDP_R)

# GDP vs Fitted GDP
residuals_gdp_r <- residuals(fit_gdp_r)
fitted_gdp_r <- GDP_R - residuals_gdp_r
ts.plot(GDP_R, main="GDP vs Fitted GDP")
points(fitted_gdp_r, type = "l", col = 2, lty = 2)

# testing accuracy and residuals
Box.test(resid(fit_gdp_r),type="Ljung",lag=4,fitdf=1)
acf(fit_gdp_r$residuals, main="ACF of Fitted GDP")
qqnorm(fit_gdp_r$residuals)
qqline(fit_gdp_r$residuals)

accuracy(fit_gdp_r)

# predict next 11 observations
forc_gdp_r<-forecast(fit_gdp_r, 11)
plot(forecast(fit_gdp_r, 11))

forc_gdp_r

# graphical representations
GDP_no_tournament<-as.data.frame(forc_gdp_r$mean)
Decade<-as.data.frame(Rarita_predict$Year)

GDP_no_tournament_1<-cbind(Decade,GDP_no_tournament)
colnames(GDP_no_tournament_1)<-c("Time","GDP per capita")

GDP_no_tourn<-as.data.frame(rbind(Rarita_2020,GDP_no_tournament_1))

GDP_no_tournament_confidence<-cbind(forc_gdp_r$mean,forc_gdp_r$lower,forc_gdp_r$upper)
GDP_no_tourn_conf<-as.data.frame(cbind(Decade,GDP_no_tournament_confidence))
GDP_no_tourn_conf1<-as.data.frame(cbind(GDP_no_tourn_conf$`Rarita_predict$Year`,GDP_no_tourn_conf$`forc_gdp_r$mean`,
                                        GDP_no_tourn_conf$`forc_gdp_r$lower.95%`,GDP_no_tourn_conf$`forc_gdp_r$upper.95%`))
colnames(GDP_no_tourn_conf1)<-c("Time","GDP per capita","Upper","Lower")


plot(GDP_no_tourn_conf1$Time, GDP_no_tourn_conf1$`GDP per capita`, type='l',col='black', lty = 1,pch=19,lwd=1, main='GDP per province without International Team (95% CI)',xlab='Time',ylab='GDP per province')
axis(1,seq(2021,2031,1))
polygon(c(rev(GDP_no_tourn_conf1$Time), GDP_no_tourn_conf1$Time), c(rev(GDP_no_tourn_conf1$Upper), GDP_no_tourn_conf1$Lower), col = 'grey80', border = NA)
lines(GDP_no_tourn_conf1$Time, GDP_no_tourn_conf1$Upper, lty = 'dashed', col = 'red')
lines(GDP_no_tourn_conf1$Time, GDP_no_tourn_conf1$Lower, lty = 'dashed', col = 'red')
lines(GDP_no_tourn_conf1$Time,GDP_no_tourn_conf1$`GDP per capita`,col='black',lty=1,pch=19,lwd=1)
points(GDP_no_tourn_conf1$Time,GDP_no_tourn_conf1$`GDP per capita`,lty = 1,pch=19,lwd=1)


# ____________________________________________________________________________

# GDP PROJECTION

# import data for rarita from 2011-2022
Rarita<-read.csv(file.choose()) # Rarita_train.csv

# import data for rarita from 2022-2031 using data from forcasted time series and revenue and expenses
Rarita_predict<-read.csv(file.choose()) # Rarita_predict.csv

Rarita_completed<-Rarita

# correlation between variables
ggpairs(data=Rarita_completed)

# partition data into a training and test set
set.seed(2)
dt = sort(sample(nrow(Rarita_completed), nrow(Rarita_completed)*.7))
train<-Rarita_completed[dt,]
test<-Rarita_completed[-dt,]

# fit model using selected variables
fit.train=lm(GDP~Year+Healthcare+Profit,data=train)

pred.train.GDP<-predict(fit.train,newdata = test)
predict(fit.train,newdata=test,interval='confidence')

# accuracy of model and stats
summary(fit.train)

AIC(fit.train)
BIC(fit.train)

predictions <- fit.train %>% predict(Rarita_completed)
data.frame(
  R2 = R2(predictions, Rarita_completed$GDP),
  RMSE = RMSE(predictions, Rarita_completed$GDP),
  MAE = MAE(predictions, Rarita_completed$GDP)
)

glance(fit.train)


# fit full model
fit=lm(GDP~Year+Healthcare+Profit,data=Rarita_completed)

summary(fit)

# predicting 
set.seed(2)
pred.GDP <- predict(fit, newdata=Rarita_predict)

pred.GDP.df <- as.data.frame(pred.GDP)

pred.GDP.df

# merges both data sets 
Complete <- cbind(Rarita_predict,pred.GDP.df)
summary(Complete)

GDP_tournament<-as.data.frame(cbind(Complete$Year,Complete$pred.GDP))
colnames(GDP_tournament)<-c("Time","GDP per capita")

Rarita_2020<-as.data.frame(cbind(Rarita_completed$Year,Rarita_completed$GDP))
colnames(Rarita_2020)<-c("Time","GDP per capita")


GDP_tourn<-as.data.frame(rbind(Rarita_2020,GDP_tournament))

# plot GDP without tournament against GDP with tournament
plot(GDP_tourn$Time, GDP_tourn$`GDP per capita`, type='l', col='red', lty = 1,pch=19,lwd=1, main='GDP per province with International Team vs without',xlab='Time',
     ylab = 'GDP per province')
lines(GDP_no_tourn$Time,GDP_no_tourn$`GDP per capita`,type='l',col='black',lty=1,pch=19,lwd=1)
legend(x="topleft",inset = 0.05, legend=c("Without International Team", "With International Team"),col=c("black", "red"), lty=1:2, cex=0.8)


# plot GDP with tournament with a confidence interval

preds <- predict(fit, newdata = Rarita_predict, 
                 interval = 'confidence')


plot(GDP_tournament$Time, GDP_tournament$`GDP per capita`, type='l',col='black', lty = 1,pch=19,lwd=1, main='GDP per province with International Team (95% CI)',xlab='Time',ylab='GDP per province')
axis(1,seq(2021,2031,1))
polygon(c(rev(GDP_tournament$Time), GDP_tournament$Time), c(rev(preds[ ,3]), preds[ ,2]), col = 'grey80', border = NA)
lines(GDP_tournament$Time, preds[ ,3], lty = 'dashed', col = 'red')
lines(GDP_tournament$Time, preds[ ,2], lty = 'dashed', col = 'red')
lines(GDP_tournament$Time,GDP_tournament$`GDP per capita`,col='black',lty=1,pch=19,lwd=1)
points(GDP_tournament$Time,GDP_tournament$`GDP per capita`,lty = 1,pch=19,lwd=1)





