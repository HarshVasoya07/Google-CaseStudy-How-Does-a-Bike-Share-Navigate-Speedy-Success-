<h1>[Google] Case Study: How Does a Bike-Share Navigate Speedy Success?</h1>


<h2>Description</h2>

Business Objective/Task:
My objective for this project is to analyze the usage patterns and behavior of annual members and casual riders of Cyclistic bikes in order to design effective marketing strategies to convert casual riders into annual members.

As a junior data analyst at Cyclistic, I used the R programming language and several packages, including tidyverse, lubridate, janitor, dplyr, and ggplot2, to analyze and visualize the historical trip data. Here is a summary of the steps I followed:

First, I loaded the necessary packages:

R
Copy code
library(tidyverse)
library(lubridate)
library(janitor)
library(dplyr)
library(ggplot2)
Next, I imported the trip data from multiple CSV files for the previous 12 months and combined them into a single dataset:

R
Copy code
trip22_Jul <- read.csv("~/Desktop/Cyclistic Datasets/July2022.csv")
trip22_Aug <- read.csv("~/Desktop/Cyclistic Datasets/August2022.csv")
# ... loading data for other months ...

combined_data <- rbind(trip22_Jul, trip22_Aug, trip22_Sep, trip22_Oct, trip22_Nov, trip22_Dec,
                       trip23_Jan, trip23_Feb, trip23_Mar, trip23_Apr, trip23_May, trip23_Jun)
After combining the data, I cleaned it by removing unnecessary columns and renaming them:

R
Copy code
combined_data <- combined_data %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng, start_station_id, end_station_id, end_station_name, start_station_name))
Then, I transformed the data by adding new columns for date, month, day, year, day of the week, and ride length:

R
Copy code
combined_data$date <- as.Date(combined_data$started_at)
combined_data$month <- format(as.Date(combined_data$date), "%m")
combined_data$day <- format(as.Date(combined_data$date), "%d")
combined_data$year <- format(as.Date(combined_data$date), "%Y")
combined_data$day_of_week <- format(as.Date(combined_data$date), "%A")
combined_data$time <- format(combined_data$started_at, format = "%H:%M")
combined_data$time <- as.POSIXct(combined_data$time, format = "%H:%M")
combined_data$ride_length <- (as.double(difftime(combined_data$ended_at, combined_data$started_at))) / 60
With the data prepared, I conducted various analyses and created visualizations. Here are a few examples:

Total Number of Rides per Day of the Week:
R
Copy code
combined_data %>%
  group_by(day_of_week) %>%
  summarise(number_of_rides = n()) %>%
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = day_of_week)) +
  geom_col() +
  labs(x = 'Day of Week', y = 'Total Number of Rides', title = 'Rides per Day of Week') +
  scale_fill_discrete(name = 'Day of Week')
Total Number of Rides per Month by Membership Type:
R
Copy code
combined_data %>%
  group_by(member_casual, month) %>%
  summarise(total_rides = n(), average_duration = mean(ride_length)) %>%
  arrange(member_casual) %>%
  ggplot(aes(x = month, y = total_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(x = "Month", y = "Total Number of Rides", title = "Rides per Month", fill = "Type of Membership") +
  scale_y_continuous(breaks = c(100000, 200000, 300000, 400000), labels = c("100K", "200K", "300K", "400K")) +
  theme(axis.text.x = element_text(angle = 45))
Number of Rentals per Type of Bike by Membership Type:
R
Copy code
combined_data %>%
  ggplot(aes(x = rideable_type, fill = member_casual)) +
  geom_bar(position = "dodge") +
  labs(x = 'Type of Bike', y = 'Number of Rentals', title = 'Which Bike Works the Most', fill = 'Type of Membership') +
  scale_y_continuous(breaks = c(500000, 1000000, 1500000), labels = c("500K", "1Mil", "1.5Mil"))
Average Ride Duration per Day of the Week by Membership Type:
R
Copy code
combined_data %>%
  mutate(day_of_week = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, day_of_week) %>%
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>%
  arrange(member_casual, day_of_week) %>%
  ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(x = 'Days of the Week', y = 'Average Duration - Hrs', title = 'Average Ride Time per Week', fill = 'Type of Membership')
Finally, based on the analysis, I would make three recommendations to convert casual riders into annual members. These recommendations would be supported by the insights gained from the data analysis and visualizations.

This case study demonstrates my ability to analyze data, derive meaningful insights, and make data-driven recommendations to drive business decisions.

Stakeholders:

Lily Moreno (Director of Marketing):- As my manager, she initiated the project and is responsible for driving the growth and success of Cyclistic. Moreno will rely on the analysis and insights I provide to make data-driven marketing decisions.

Cyclistic Marketing Analytics Team:- My fellow data analysts will collaborate with me to perform the analysis, extract insights, and develop recommendations based on the data. We will work together to design effective marketing strategies.

Cyclistic Executive Team:- The executive team will review and evaluate the recommendations and strategies proposed by the marketing analytics team. They will make decisions based on the analysis to drive the company's growth and profitability.

The success of this project relies on the collaboration and coordination between the marketing team, analytics team, and the executive team. The insights gained from the analysis will guide the development of targeted marketing campaigns to convert casual riders into annual members, ultimately contributing to the overall success of Cyclistic as a bike-share program.
<br />


<h2>Languages and Utilities Used</h2>

- <b>R</b> 

<h2>Environments Used </h2>

- <b>RStudio, Powerpoint, Tableau</b>

