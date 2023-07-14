<h1>[Google] Case Study: How Does a Bike-Share Navigate Speedy Success?</h1>
<h2>Business Objective/Task</h2>
Design a marketing strategy to increase the conversion rate of casual riders to annual members in order to maximize the number of annual memberships and drive long-term growth for Cyclistic.
<br />

<h2>Ask</h2>

- As a junior data analyst at Cyclistic, my task is to understand how annual members and casual riders use Cyclistic bikes differently. By analyzing the historical trip data, I aim to provide insights that will guide the design of a marketing strategy to convert casual riders into annual members.
<br />

<h2>Prepare</h2>

- To begin the analysis, I downloaded the previous 12 months(July 2022 - June 2023) of 'Cyclistic' trip data and stored it appropriately on my local machine. I created separate subfolders for the 'CSV' and 'XLS' files and saved the downloaded files accordingly. This ensures proper organization and easy access to the data.

- Next, I loaded the data into R using the 'read.csv' function. I imported each monthly dataset into separate data frames, such as 'trip22_Jul', 'trip22_Aug', etc. Then, I combined all the monthly data frames into one consolidated data frame called c'ombined_data' using the 'rbind' function.

- To ensure data cleanliness and efficiency, I selected only the relevant columns for analysis using the select function. I removed unnecessary columns such as 'latitude', 'longitude', 'station IDs', and 'station names'.

- I also prepared the data for further analysis by converting the "started_at" column to a date format using the 'as.Date' function. This will allow me to analyze the data based on dates.

```r
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

```
  
<br />

<h2>Process</h2>

- With the data prepared, I now move on to the data processing step. In this step, I will check the data for any errors, choose appropriate tools for analysis, transform the data, and document the cleaning process.

- I'll start by checking the data for any errors or inconsistencies that may affect the analysis. This includes checking for missing values, outliers, or any other anomalies that need to be addressed.

- Next, I'll choose the appropriate tools for analysis. In this case, I'll be using R and various packages such as 'tidyverse', 'lubridate', and 'ggplot2' for data manipulation, analysis, and visualization.

- To transform the data, I'll calculate additional variables such as month, day, year, and day of the week. These variables will provide more insights into the patterns and trends of bike usage by annual members and casual riders.

- Throughout the cleaning and manipulation process, I'll document each step to ensure transparency and reproducibility. This documentation will serve as a reference for reviewing and sharing the results.

```r
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

```
<br />

<h2>Analyze</h2>

 - With the data processed, I will now analyze it to identify trends and relationships between annual members and casual riders. I'll organize the data for effective analysis and perform calculations to derive meaningful insights.

- To analyze the data, I'll calculate descriptive statistics such as mean, median, maximum, and minimum ride lengths for annual members and casual riders. This will give me an understanding of the typical ride duration for each user group.

- I'll also explore the number of rides by day of the week for each user type. This will help identify any patterns or preferences in bike usage based on the day of the week.

```r
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
```


<br />

<h2>Share</h2>

- To share my findings effectively, I'll create visualizations using the 'ggplot2' package in R. These visualizations will help communicate the insights and trends discovered during the analysis.

- I'll create bar charts comparing the number of rides by day of the week and by month for annual members and casual riders. These visualizations will provide a clear understanding of the differences in bike usage patterns between the two user groups.

- Additionally, I'll create visualizations showcasing the usage of different types of bikes by user type. This will help identify any preferences or trends in bike type preferences among annual members and casual riders.

- The visualizations will be polished and professional, with clear labels and appropriate titles. They will be included in the report to the Cyclistic executive team.
```r
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
```
<br />

<h2>Act/Recommendations</h2>

- Personalized Membership Offers:

  --> Analyze historical trip data to identify preferences and usage patterns of casual riders.
  
  --> Tailor membership packages based on their specific needs and preferences.
  
  --> Offer incentives such as discounted rates or additional services to encourage the upgrade to annual memberships.
  

- Enhanced User Experience for Annual Members:

  --> Streamline the bike reservation process for annual members.
  
  --> Ensure seamless availability of bikes at popular stations.
  
  --> Provide personalized recommendations for popular routes or bike trails.

- Targeted Marketing Campaigns:

  --> Develop targeted marketing campaigns to reach casual riders.
  
  --> Highlight the cost-effectiveness and convenience of annual memberships.
  
  --> Use persuasive messaging and attractive visuals to encourage the conversion to annual memberships.
  
<br />

<h2>Stakeholders</h2>

Lily Moreno (Director of Marketing):- As my manager, she initiated the project and is responsible for driving the growth and success of Cyclistic. Moreno will rely on the analysis and insights I provide to make data-driven marketing decisions.

Cyclistic Marketing Analytics Team:- My fellow data analysts will collaborate with me to perform the analysis, extract insights, and develop recommendations based on the data. We will work together to design effective marketing strategies.

Cyclistic Executive Team:- The executive team will review and evaluate the recommendations and strategies proposed by the marketing analytics team. They will make decisions based on the analysis to drive the company's growth and profitability.

The success of this project relies on the collaboration and coordination between the marketing team, analytics team, and the executive team. The insights gained from the analysis will guide the development of targeted marketing campaigns to convert casual riders into annual members, ultimately contributing to the overall success of Cyclistic as a bike-share program.
<br />


<h2>Languages and Utilities Used</h2>

- <b>R</b> 

<h2>Environments Used </h2>

- <b>RStudio, Powerpoint, Tableau</b>

