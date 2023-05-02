library(tidyr)
library(plyr)
library(dplyr)
library(tidyverse)
library(readxl)
library(lubridate)
library(ggplot2)
library(hrbrthemes)
library(viridis)
library(tidyverse)
library(dplyr)
library(readxl)
library(lubridate)
library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggplot2)
library(glmnet)
library(pROC)
library(corrplot)
library(ggplot2)
library(gridExtra)
library(ggcorrplot)
library(shiny)
library(data.table)
library(datatable)
library(DT)
library(scales)
library(RColorBrewer)
library(thememap)
library(ggthemes)


rm(list =ls())
colors <- c("#CC1011", "#665555", "#05a399", "#cfcaca", "#f5e840", "#0683c9", "#e075b0")

setwd("~/Documents/Data 331")

df <-read.csv("~/Documents/Data 331/uber-raw-data-apr14 (3).csv")
df_1 <-read.csv("~/Documents/Data 331/uber-raw-data-aug14.csv")
df_2 <-read.csv("~/Documents/Data 331/uber-raw-data-jul14.csv")
df_3 <-read.csv("~/Documents/Data 331/uber-raw-data-sep14.csv")
df_4 <-read.csv("~/Documents/Data 331/uber-raw-data-jun14.csv")
df_5 <-read.csv("~/Documents/Data 331/uber-raw-data-may14.csv")

data_blen <- rbind(df_1,df_2,df_3,df_4,df_5,df)

data_blen$Date.Time <- as.POSIXct(data_blen$Date.Time, format = "%m/%d/%Y %H:%M:%S")

data_blen$Time <- format(as.POSIXct(data_blen$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")

data_blen$Date.Time <- ymd_hms(data_blen$Date.Time)

data_blen$day <- factor(day(data_blen$Date.Time))
data_blen$month <- factor(format(data_blen$Date.Time, "%b"))

data_blen$year <- factor(year(data_blen$Date.Time))


# Create a factor variable for the day of the week
data_blen$dayofweek <- factor(weekdays(data_blen$Date.Time), levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))



# Create factor variables for the hour and minute
data_blen$hour <- factor(hour(parse_date_time(data_blen$Time, orders = "HM:S")))
data_blen$minute <- factor(minute(parse_date_time(data_blen$Time, orders = "HM:S")))



data_blen$second <- factor(second(parse_date_time(data_blen$Time, orders = "HM:S")))
hour_data <- data_blen %>%
  group_by(hour) %>%
  dplyr::summarize(Total = n()) 
datatable(hour_data)

ggplot(hour_data, aes(hour, Total)) + 
  geom_bar(stat = "identity", fill = "#4B6A88", color = "#4B6A88", alpha = 0.8) +
  ggtitle("Trips Every Hour") +
  xlab("Hour of the Day") + ylab("Total Trips") +
  theme(legend.position = "none") +
  scale_y_continuous(breaks = seq(0, 700000, 50000), labels = comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        panel.grid.major.y = element_line(color = "gray70"),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.line.x = element_line(color = "gray70"),
        axis.line.y = element_line(color = "gray70"))




month_hour <- data_blen %>%
  group_by(month, hour) %>%
  dplyr::summarize(Total = n())

ggplot(month_hour, aes(hour, Total, fill = month)) + 
  geom_bar(stat = "identity") +
  ggtitle("Trips by Hour and Month") +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")) +
  theme_minimal()

day_group <- data_blen %>%
  group_by(day) %>%
  dplyr::summarize(Total = n()) 
datatable(day_group)
ggplot(day_group, aes(day, Total)) + 
  geom_bar(stat = "identity", fill = "firebrick3") +
  ggtitle("Trips Every Day") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = comma)




day_month_group <- data_blen %>%
  group_by(month, day) %>%
  dplyr::summarize(Total = n())

ggplot(day_month_group, aes(day, Total, fill = month)) + 
  geom_bar(stat = "identity") +
  ggtitle("Trips by Day and Month") +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"))



# Define UI ----
ui <- fluidPage(
  titlePanel("Trips by Day and Month"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "month",
                  label = "Select month:",
                  choices = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"))
    ),
    mainPanel(
      plotOutput("day_plot"),
      plotOutput("day_month_plot")
    )
  )
)

# Define server ----
server <- function(input, output) {
  
  # Create day data
  day_group <- data.frame(day = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), 
                          Total = sample(1000:5000, 7))
  
  # Filter data by selected month
  day_month_group <- reactive({
    data.frame(day = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), 
               month = input$month,
               Total = sample(1000:5000, 7))
  })
  
  # Render plots
  output$day_plot <- renderPlot({
    ggplot(day_group, aes(day, Total)) + 
      geom_bar(stat = "identity", fill = "firebrick3") +
      ggtitle(paste("Trips Every Day -", input$month)) +
      theme(legend.position = "none") +
      scale_y_continuous(labels = comma)
  })
  
  output$day_month_plot <- renderPlot({
    ggplot(day_month_group(), aes(day, Total, fill = month)) + 
      geom_bar(stat = "identity") +
      ggtitle(paste("Trips by Day and Month -", input$month)) +
      scale_y_continuous(labels = comma) +
      scale_fill_manual(values = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"))
  })
}

# Run app ----
shinyApp(ui, server)

