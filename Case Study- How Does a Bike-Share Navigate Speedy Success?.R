library(tidyverse)
library(lubridate)
library(janitor)
library(dplyr)
library(ggplot2)

trip22_Jul <- read.csv("~/Desktop/Cyclistic Datasets/July2022.csv")
trip22_Aug <- read.csv("~/Desktop/Cyclistic Datasets/August2022.csv")
trip22_Sep <- read.csv("~/Desktop/Cyclistic Datasets/September2022.csv")
trip22_Oct <- read.csv("~/Desktop/Cyclistic Datasets/October2022.csv")
trip22_Nov <- read.csv("~/Desktop/Cyclistic Datasets/November2022.csv")
trip22_Dec <- read.csv("~/Desktop/Cyclistic Datasets/December2022.csv")
trip23_Jan <- read.csv("~/Desktop/Cyclistic Datasets/January2023.csv")
trip23_Feb <- read.csv("~/Desktop/Cyclistic Datasets/February2023.csv")
trip23_Mar <- read.csv("~/Desktop/Cyclistic Datasets/March2023.csv")
trip23_Apr <- read.csv("~/Desktop/Cyclistic Datasets/April2023.csv")
trip23_May <- read.csv("~/Desktop/Cyclistic Datasets/May2023.csv")
trip23_Jun <- read.csv("~/Desktop/Cyclistic Datasets/June2023.csv")

combined_data <- rbind(trip22_Jul, trip22_Aug, trip22_Sep, trip22_Oct, trip22_Nov, trip22_Dec,
                       trip23_Jan, trip23_Feb, trip23_Mar, trip23_Apr, trip23_May, trip23_Jun)

View(combined_data)

combined_data <- combined_data %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng, start_station_id,end_station_id, end_station_name, start_station_name))


View(combined_data)

colnames(combined_data)
nrow(combined_data)
dim(combined_data) 
head(combined_data, 6) 
str(combined_data) 
summary(combined_data) 

View(combined_data)

combined_data$date <- as.Date(combined_data$started_at)
combined_data$month <- format(as.Date(combined_data$date), "%m")
combined_data$day <- format(as.Date(combined_data$date), "%d")
combined_data$year <- format(as.Date(combined_data$date), "%Y")
combined_data$day_of_week <- format(as.Date(combined_data$date), "%A")
combined_data$time <- format(combined_data$started_at, format= "%H:%M")
combined_data$time <- as.POSIXct(combined_data$time, format= "%H:%M")

View(combined_data)

combined_data$ride_length <- (as.double(difftime(combined_data$ended_at, combined_data$started_at))) /60

View(combined_data)

str(combined_data)
combined_data$ride_length <- as.numeric(as.character(combined_data$ride_length))

aggregate(combined_data$ride_length ~ combined_data$member_casual, FUN = mean)
aggregate(combined_data$ride_length ~ combined_data$member_casual, FUN = median)
aggregate(combined_data$ride_length ~ combined_data$member_casual, FUN = max)
aggregate(combined_data$ride_length ~ combined_data$member_casual, FUN = min)

combined_data$day_of_week <- ordered(combined_data$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

View(combined_data)

combined_data %>% 
  mutate(day_of_week = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, day_of_week ) %>% 
  summarise(number_of_rides = n())

#visualizations 

combined_data$day_of_week <- format(as.Date(combined_data$date), "%A")
combined_data$day_of_week <- factor(combined_data$day_of_week, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

combined_data %>%
  group_by(day_of_week) %>%
  summarise(number_of_rides = n()) %>%
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = day_of_week)) +
  geom_col() +
  labs(x = 'Day of Week', y = 'Total Number of Rides', title = 'Rides per Day of Week') +
  scale_fill_discrete(name = 'Day of Week')

  group_by(member_casual, month) %>%  
  summarise(total_rides = n(),`average_duration_(mins)` = mean(ride_length)) %>% 
  arrange(member_casual) %>% 
  ggplot(aes(x=month, y=total_rides, fill = member_casual)) + geom_col(position = "dodge") + 
  labs(x= "Month", y= "Total Number of Rides", title = "Rides per Month", fill = "Type of Membership") + 
  scale_y_continuous(breaks = c(100000, 200000, 300000, 400000), labels = c("100K", "200K", "300K", "400K")) + theme(axis.text.x = element_text(angle = 45))

combined_data %>%   
  ggplot(aes(x = rideable_type, fill = member_casual)) + geom_bar(position = "dodge") + 
  labs(x= 'Type of Bike', y='Number of Rentals', title='Which bike works the most', fill = 'Type of Membership') +
  scale_y_continuous(breaks = c(500000, 1000000, 1500000), labels = c("500K", "1Mil", "1.5Mil"))

combined_data %>% 
  mutate(day_of_week = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, day_of_week)  %>% 
  ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") + labs(x='Days of the week', y='Average duration - Hrs', title='Average ride time per week', fill='Type of Membership')
