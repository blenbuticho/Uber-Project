# Uber-Project

# Introduction

The Uber data contains information on ride requests in various cities. This project starts by importing and cleaning the Uber data, and then proceeds to create various visualizations and insights based on the data. It covers a range of data analysis techniques, from basic descriptive statistics and time series analysis to more advanced topics like geospatial data visualization and machine learning.

# Data Analysis 

The analysis explores Uber trip data from April to September 2014 in order to gain insights into patterns of usage over time. The data is processed and transformed using various R packages such as dplyr, lubridate, readr and tidyr. The transformed data is then used to create several visualizations including a bar graph of trips by hour, a bar graph of trips by hour and month, a bar graph of trips by day, and a bar graph of trips by day and month. These visualizations provide an understanding of when Uber is most frequently used and how usage patterns vary by day, hour, and month.



# Cleaning The Data 

          ` data_uber <- rbind(df_1,df_2,df_3,df_4,df_5,df)
           data_uber$Date.Time <- as.POSIXct(data_uber$Date.Time, format = "%m/%d/%Y %H:%M:%S")
           data_uber$Time <- format(as.POSIXct(data_uber$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")
           data_uber$Date.Time <- ymd_hms(data_uber$Date.Time)
           data_uber$day <- factor(day(data_uber$Date.Time))
           data_uber$month <- factor(format(data_uber$Date.Time, "%b"))
           data_uber$year <- factor(year(data_uber$Date.Time)) `




