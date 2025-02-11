#load packages
library(tidyverse)
library(tidymodels)
library(readxl)
#time series
library(TTR)
library(forecast)
library(timetk)
library(modeltime)

#read in data
all_sales <- read_xlsx("data/sales by month.xlsx")

glimpse(all_sales)

#group by month 
monthly_sales <- all_sales %>% 
  group_by(year = year(`Order Date`), month = month(`Order Date`)) %>%
  summarise(sales = sum(Sales), profit = sum(Profit))

glimpse(monthly_sales)

#create a date column from month and year
monthly_sales$date <- as.Date(paste("1", as.character(monthly_sales$month), 
                                    as.character(monthly_sales$year), 
                                    sep = " "), format= "%d %m %Y")

#plot line graph of sales
ggplot(data = monthly_sales, aes(x = date, y = sales)) +
  geom_path() + 
  theme_bw()


#create a time series
monthly_sales_time_series <- ts(monthly_sales$sales, frequency = 12, 
                                start = c(2014,1))

#plot time series
#can see Sept, Nov-Dec are higher each year
#not quite additive because sales are getting higher in 2017
plot.ts(monthly_sales_time_series, xlab = "Year", ylab = "Sales", 
        main = "Total Sales by Month")

#try log transform
#looks more additive (apart from Feb 2014 exception)
log_monthly_sales_time_series <- log(monthly_sales_time_series)
plot.ts(log_monthly_sales_time_series, xlab = "Year", ylab = "Sales (log scale)")

#this series has a seasonal element, try decomposing
monthly_sales_time_series_components <- 
  decompose(monthly_sales_time_series, type = "multiplicative")

#flat between 2014 and 2015, then steady increase
#random doesn't look like observed suggesting seasonal is important
plot(monthly_sales_time_series_components)

#plot the trend without the seasonal element 
monthly_sales_time_series_seasonally_adjusted <- 
  monthly_sales_time_series - monthly_sales_time_series_components$seasonal

plot(monthly_sales_time_series_seasonally_adjusted, xlab = "Year", 
     ylab = "Sales")

#plot seasonal box plots
tibble(monthly_sales) %>% plot_seasonal_diagnostics(
                          .date_var = date,
                          .value= sales,
                          .interactive = FALSE
                           )

# Holt Winters ------------------------------------

#use Holt Winters for forecasts 
#alpha is 0.06 meaning past/recent data used equally
#beta is 0.05 meaning the trend slope doesn't change much over time
#gamma is 0.54 meaning the estimate of seasonal component uses more recent data
#s9, s11, s12 are highest - Sep/Nov/Dec as we saw, s2 Feb is lowest
monthly_sales_time_series_forecasts <- 
  HoltWinters(monthly_sales_time_series, seasonal = "multiplicative")

monthly_sales_time_series_forecasts

#plot to see original vs predictions
#not bad but looks better earlier on
plot(monthly_sales_time_series_forecasts, xlab = "Year", 
     main = "Holt Winters sales forecast")

#forecast next year worth of sales
monthly_sales_time_series_forecasts_future <- 
  forecast(monthly_sales_time_series_forecasts, h = 12)

#plot forecast
plot(monthly_sales_time_series_forecasts_future, xlab = "Year", 
     ylab = "Sales", main = "Holt Winters sales future forecast")
abline(a=100000, b = 0, lty = 2)
abline(a=120000, b = 0, lty = 2)

#test whether the residuals are autocorrelated i.e. correlation between 
# two sales values at different points in time
#graphically 1 is above significance bounds
acf(monthly_sales_time_series_forecasts_future$residuals, 
    lag.max = 20, na.action = na.pass, main = "Autocorrelation test")

#no autocorrelation
Box.test(monthly_sales_time_series_forecasts_future$residuals, 
         lag=20, type="Ljung-Box")

#check whether residuals are constant over time
plot.ts(monthly_sales_time_series_forecasts_future$residuals, 
        xlab= "Year", ylab = "Residual", main = "Holt Winters Residuals")           

#looks approx normal but good to test
hist(monthly_sales_time_series_forecasts_future$residuals,
     freq = FALSE, breaks = 10, 
     xlab = "Residuals", main = "Holt Winters Residual Distribution")

curve(dnorm(x, 
            mean = mean(monthly_sales_time_series_forecasts_future$residuals, 
                        na.rm = TRUE),
            sd = sd(monthly_sales_time_series_forecasts_future$residuals, 
                    na.rm = TRUE)),
      add = TRUE,
      col = "blue")

#test for normality, ok
shapiro.test(monthly_sales_time_series_forecasts_future$residuals)

# ARIMA model  ----------------------

#does our time series look stationary?
#no, mean is higher later on
plot(monthly_sales_time_series)

#try differencing the time series to get a stationary one
monthly_sales_time_series_difference_1 <-
  diff(monthly_sales_time_series, differences = 1)

#looks ok - 1 order differencing 
plot.ts(monthly_sales_time_series_difference_1, xlab = "Year", 
        ylab = "sales (difference 1)")

#determine p and q by looking at autocorrelations
# a few points are above the significance levels
acf(monthly_sales_time_series_difference_1, lag.max=24, 
    main = "Autocorrelation of 1 difference time series")    

pacf(monthly_sales_time_series_difference_1, lag.max=24, 
    main = "Partial autocorrelation of 1 difference time series") 

#this suggests ARIMA(0,1,1) as optimal (using AICc as default)
auto.arima(monthly_sales_time_series)

#fit an arima model
monthly_sales_time_series_arima <- 
  arima(monthly_sales_time_series,
        order= c(0,1,1),
        seasonal = list(order = c(0,1,1), period = 12))
monthly_sales_time_series_arima

#plot against actual
plot(monthly_sales_time_series - monthly_sales_time_series_arima$residuals, 
     xlab = "Year", ylab = "Observed / Fitted",
     main = "ARIMA sales forecast",
     col = "red")
lines(monthly_sales_time_series,
      col = "black")

#try forecast
monthly_sales_time_series_arima_forecasts <- 
  forecast(monthly_sales_time_series_arima, h = 12 )

#slightly lower forecast overall
plot(monthly_sales_time_series_arima_forecasts, 
     xlab = "Year", ylab = "Sales", main = "ARIMA sales future forecast")
abline(a = 100000, b = 0, lty = 2)
abline(a = 120000, b = 0, lty = 2)

#check whether residuals are constant over time
plot.ts(monthly_sales_time_series_arima_forecasts$residuals, 
        xlab= "Year", ylab = "Residual", main = "ARIMA Residuals")           

#looks approx normal but good to test
hist(monthly_sales_time_series_arima_forecasts$residuals,
     freq = FALSE, breaks = 10, 
     xlab = "Residuals", main = "ARIMA Residual Distribution")

curve(dnorm(x, 
            mean = mean(monthly_sales_time_series_arima_forecasts$residuals, 
                        na.rm = TRUE),
            sd = sd(monthly_sales_time_series_arima_forecasts$residuals, 
                    na.rm = TRUE)),
      add = TRUE,
      col = "blue")

#test for normality, not normal 
shapiro.test(monthly_sales_time_series_arima_forecasts$residuals)

# tidymodels approach --------------------------

#remove irrelevant columns
monthly_sales_simplified <- monthly_sales %>% select(year, date, sales)

#split data
splits <- initial_time_split(monthly_sales_simplified)

#test and train data
monthly_sales_simplified_train <- training(splits)
monthly_sales_simplified_test <- testing(splits)

#try ARIMA and exponential smoothing and compare auto to manual
arima_fit <- arima_reg() %>% set_engine("auto_arima") %>%
  fit(sales ~ date , data = monthly_sales_simplified_train)
  
arima_fit_manual <- 
  arima_reg(seasonal_period = 12, 
            non_seasonal_ar = 0,
            non_seasonal_differences = 1,
            non_seasonal_ma = 1,
            seasonal_ar = 0,
            seasonal_differences = 1,
            seasonal_ma = 1) %>%
  set_engine("arima") %>%
  fit(sales ~ date , data = monthly_sales_simplified_train)
  
exponential_fit <- exp_smoothing() %>% set_engine("ets")  %>%
  fit(sales ~ date , data = monthly_sales_simplified_train)
 
#note: tried to determine multiplicative/additive from visual
# but not all combinations are excepted
exponential_fit_manual <- 
  exp_smoothing(seasonal_period = 12,
                error = "multiplicative",
                trend = "multiplicative",
                season = "multiplicative"
                ) %>% 
  set_engine("ets")  %>%
  fit(sales ~ date , data = monthly_sales_simplified_train)

#add all models to a table
all_models <- modeltime_table(
  arima_fit,
  arima_fit_manual,
  exponential_fit,
  exponential_fit_manual
)

#calibrate models
calibrate_models <- all_models %>% 
  modeltime_calibrate(new_data = monthly_sales_simplified_test)

#plot forecasts together
calibrate_models %>% 
  modeltime_forecast(
    actual_data = tibble(monthly_sales_simplified),
    new_data = tibble(monthly_sales_simplified_test)
  ) %>% 
  plot_modeltime_forecast(
    .conf_interval_show = FALSE,
    .y_lab = "Sales"
  )


#compare models using metrics
#manual exponential is performing the best
calibrate_models %>% 
  modeltime_accuracy()

#refit models for predictions
refit_models <- calibrate_models %>% 
  modeltime_refit(data = monthly_sales_simplified)

#forecast one year in advance
#see how much difference assuming a multiplicative relationship
# makes to exponential - this is like a best case scenario
# also note that auto arima has been updated to my manual parameters so 
# green and red lines are the same
refit_models %>%
  modeltime_forecast(
    actual_data = tibble(monthly_sales_simplified),
    h = "1 year"
  ) %>% 
  plot_modeltime_forecast(
    .conf_interval_show = FALSE,
    .y_lab = "Sales", 
    .title = "Future Forecast Plot (1 year)"
  )

#understand more about how exponential smoothing / ARIMA work
#look at adjusting parameters
#update OneNote on AIC, BIC