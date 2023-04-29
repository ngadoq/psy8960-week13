# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(RMariaDB)
library(tidyverse)

# Data Import and Cleaning
# Access MariaDB using keyring
conn <- dbConnect(MariaDB(),
                  user="do000100",
                  password=key_get("latis-mysql","do000100"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = 'mysql_hotel_umn_20220728_interm.cer'
)

# Show databases
databases_df <- dbGetQuery(conn, "SHOW DATABASES;")

# Choose database
dbExecute(conn, "USE cla_tntlab;")

# Create week13_tbl from SQL table
(week13_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_8960_table;")) %>% 
  # Save data
  write.csv("../data/week13.csv")

# Analysis
# Display the total number of managers
nrow(week13_tbl)

# Display the total number of unique managers (unique by id number)
week13_tbl %>% summarise(n_managers = n_distinct(employee_id))

# Display a summary of the number of managers split by location, but only include those who were not originally hired as managers
week13_tbl %>% filter(manager_hire == "N") %>% 
  count(city) 

# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top)
week13_tbl %>% group_by(performance_group) %>% 
  summarise(mean_yrs_employed = mean(yrs_employed),
            sd_yrs_employed = sd(yrs_employed))

# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3
week13_tbl %>% group_by(city) %>% 
  arrange(city, desc(test_score)) %>% 
  slice_max(test_score, n = 3) %>% 
  select(city, employee_id)


