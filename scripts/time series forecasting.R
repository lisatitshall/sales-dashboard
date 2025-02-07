#load packages
library(tidyverse)
library(readxl)
#time series
library(TTR)
library(forecast)

#read in data
all_sales <- read_xlsx("data/sales by month.xlsx", 
                            sheet = 1 )

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
plot.ts(monthly_sales_time_series, xlab = "Year", ylab = "Sales")

#try log transform
#looks more additive (apart from Feb 2014 exception)
log_monthly_sales_time_series <- log(monthly_sales_time_series)
plot.ts(log_monthly_sales_time_series, xlab = "Year", ylab = "Sales (log scale)")

#this series has a seasonal element, try decomposing
monthly_sales_time_series_components <- 
  decompose(monthly_sales_time_series, type = "multiplicative")

#flat between 2014 and 2015, then steady increase
plot(monthly_sales_time_series_components)

#plot the trend without the seasonal element 
monthly_sales_time_series_seasonally_adjusted <- 
  monthly_sales_time_series - monthly_sales_time_series_components$seasonal

plot(monthly_sales_time_series_seasonally_adjusted, xlab = "Year", 
     ylab = "Sales")

#use Holt Winters for forecasts 
#alpha is 0.06 meaning past/recent data used equally
#beta is 0.05 meaning the trend slope doesn't change much over time
#gamma is 0.54 meaning the estimate of seasonal component uses more recent data
#s9, s11, s12 are highest - Sep/Nov/Dec as we saw, s2(Feb) is lowest
monthly_sales_time_series_forecasts <- 
  HoltWinters(monthly_sales_time_series, seasonal = "multiplicative")

monthly_sales_time_series_forecasts

#plot to see original vs predictions
#not bad but looks better earlier on
plot(monthly_sales_time_series_forecasts, xlab = "Year")

#forecast next year worth of sales
monthly_sales_time_series_forecasts_future <- 
  forecast(monthly_sales_time_series_forecasts, h = 12)

#plot forecast
plot(monthly_sales_time_series_forecasts_future)
abline(a=100000, b = 0, lty = 2)
abline(a=120000, b = 0, lty = 2)


