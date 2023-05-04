# Uber-Project

![image](https://user-images.githubusercontent.com/118494123/236112331-a23650fe-98e4-4f77-a798-e15c3d5df1d5.png)


# Introduction

- This project is all about analyzing the data related to Uber ride requests in different cities. The very first step in this project was to import and clean the Uber data so that it could be used for further analysis. I proceeded to create various visuals to gain insights from the data. These visualizations include time series plots of trip requests over different time periods, heat maps across different locations and times, and bar graphs and pie charts to display categorical data. I also used interactive mapping tools to explore the geospatial distribution of ride requests and to visualize the routes taken by drivers. These visuals helped me to uncover patterns and trends in the data and to draw meaningful conclusions from the Uber ride data.


# Cleaning the Data

- To begin the Uber data analysis, I imported the necessary packages and libraries that I will utilize in this project. To add some visual appeal to my plot, I created a color vector that I will use in my plotting functions.

```r
colors <- c("#CC1011", "#665555", "#05a399", "#cfcaca", "#f5e840", "#0683c9", "#e075b0")
```

- Next, I read the individual CSV files containing data from April 2014 to September 2014 and stored them into separate data frames for each month. After reading the files, I combined all the data into one dataframe, named "data_uber".

```r
           data_uber<- rbind(df_1,df_2,df_3,df_4,df_5,df)
           data_uber$Date.Time <- as.POSIXct(data_uber$Date.Time, format = "%m/%d/%Y %H:%M:%S")
           data_uber$Time <- format(as.POSIXct(data_uber$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")
           data_uber$Date.Time <- ymd_hms(data_uber$Date.Time)
           data_uber$day <- factor(day(data_uber$Date.Time))
           data_uber$month <- factor(format(data_uber$Date.Time, "%b"))
           data_uber$year <- factor(year(data_uber$Date.Time)) `
```

# Data Analysis 

- The analysis explores Uber trip data from April to September 2014 in order to gain insights into patterns of usage over time. The data is processed and transformed using various R packages such as dplyr, lubridate, readr and tidyr. The transformed data is then used to create several visualizations including a bar graph of trips by hour, a bar graph of trips by hour and month, a bar graph of trips by day, and a bar graph of trips by day and month. These visualizations provide an understanding of when Uber is most frequently used and how usage patterns vary by day, hour, and month.

# Filtering the Data and Creating Visuals

1. I created factor variables for the day of the week, hour, minute, and second in my dataset to make it easier to analyze and visualize the data by those time units. Factor variables are useful for categorical data like time units, and they can help with ordering and grouping the data appropriately.


```r                      
           data_uber$dayofweek <- factor(weekdays(data_uber$Date.Time), levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
           
           data_uber$hour <- factor(hour(parse_date_time(data_uber$Time, orders = "HM:S")))
           data_uber$minute <- factor(minute(parse_date_time(data_uber$Time, orders = "HM:S")))
           data_uber$second <- factor(second(parse_date_time(data_uber$Time, orders = "HM:S")))
           hour_data <- data_uber %>%
             group_by(hour) %>%
             dplyr::summarize(Total = n()) 
           datatable(hour_data)
           write.csv(hour_data, "hour_data.csv")
 ```          

# Geospatial leaflet map

<img width="881" alt="Screen Shot 2023-05-03 at 11 05 08 PM" src="https://user-images.githubusercontent.com/118494123/236110595-0546edf0-2ba4-4038-a617-d0ec4f079795.png">

