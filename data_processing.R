library(readxl)
library(ggplot2)
library(gridExtra)
library(dplyr)
# install.packages("dplyr")


# ECO DEM DATA
# Legend	
# Inflation	Average annual rate for the year
# Government overnight bank lending rate	Average annual rate for the year
# 1-yr risk free rate	Average annual rate for the year
# 10-yr risk free rate	Average annual rate for the year


# Research EMISSION

# Hazard data
# Legend	
# Region	Region where the hazard event occurred
# Hazard Event	The type of the hazard event
# Quarter	The quarter of the hazard event's occurence
# Year	The year of the hazard event's occurence
# Duration	Length of the hazard event expressed in number of days
# Fatalities	Count of people killed due to the hazard event
# Injuries	Count of people injured due to the hazard event
# Property Damage	Property damage in Ꝕ in the region as a result of the hazard event


hazard_data <- read_excel("data/2023-student-research-hazard-event-data.xlsx")

# Data visualisation:

# Create bar chart of Hazard Events by region
ggplot(data.frame(Hazard_Event = names(table(hazard_data$`Hazard Event`)), 
                    Count = as.vector(table(hazard_data$`Hazard Event`))), 
       aes(x = Count, y = Hazard_Event)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Hazard Event Count", x = "Hazard Event", y = "Count")

# Code for filtering by region:
hazard_filter <- hazard_data %>% 
  filter(Region == 1)

ggplot(data.frame(Hazard_Event = names(table(hazard_filter_1$`Hazard Event`)), 
                  Count = as.vector(table(hazard_filter_1$`Hazard Event`))), 
       aes(x = Count, y = Hazard_Event)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Hazard Event Count", x = "Hazard Event", y = "Count")


# Fatality and injury over time chart:
ggplot(hazard_data, aes(x = Year, group = 1)) +
  geom_line(aes(y = Fatalities, color = "Fatalities"), size = 1) +
  geom_line(aes(y = Injuries, color = "Injuries"), size = 1) +
  scale_color_manual(name = "Legend", values = c("Fatalities" = "red", "Injuries" = "blue")) +
  labs(title = "Fatalities and Injuries over Time", x = "Year", y = "Number of People") +
  theme_bw() + coord_flip()


# Fatilies and injuries by hazard event
ggplot(hazard_data, aes(x = `Hazard Event`)) +
  geom_bar(aes(y = hazard_data$`Hazard Event`), position = "stack", stat = "identity") +
  labs(title = "Fatalities and Injuries by Hazard Event", x = "Hazard Event", y = "Number of People") +
  theme_bw() + coord_flip()

# Fatalities and property damage
f_p_filtered_data <- hazard_data %>%
  filter(`Property Damage` < 2000000000)

ggplot(f_p_filtered_data, aes(x = Fatalities, y = `Property Damage`/1000000)) +
  geom_point(color = "blue") +
  labs(title = "Fatalities and Property Damage", x = "Number of Fatalities", y = "Property Damage (x1000000)") +
  theme_bw()

# Heatmap of Fatalities and Injuries by Region
# calculate the total number of Fatalities and Injuries by Region
fatalities_by_region <- aggregate(cbind(Fatalities, Injuries) ~ Region, hazard_data, sum)

# create a heatmap of Fatalities and Injuries by Region
ggplot(fatalities_by_region, aes(x = Region, y = "Fatalities and Injuries", fill = Fatalities + Injuries)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Fatalities and Injuries by Region", x = "Region", y = "") +
  theme_bw()


