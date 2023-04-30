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


# Choose database
dbExecute(conn, "USE cla_tntlab;")

# Display the total number of managers.
dbGetQuery(conn, "SELECT COUNT(employee_id) AS n_managers
                  FROM datascience_8960_table;")

# Display the total number of unique managers (unique by id number)
dbGetQuery(conn, "SELECT COUNT(DISTINCT employee_id) AS n_managers_unique
                  FROM datascience_8960_table;")

# Display a summary of the number of managers split by location, but only include those who were not originally hired as managers
dbGetQuery(conn, "SELECT city, COUNT(employee_id) AS n_managers_city
                  FROM datascience_8960_table
                  WHERE manager_hire = 'N'
                  GROUP BY city;")

# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top)
dbGetQuery(conn, "SELECT performance_group, AVG(yrs_employed) AS mean_yrs_employed, STDDEV(yrs_employed) AS sd_yrs_employed
                  FROM datascience_8960_table
                  GROUP BY performance_group;")

# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 

dbGetQuery(conn, "WITH rank_manager AS (
  SELECT *, 
  RANK() OVER(PARTITION BY city ORDER BY test_score DESC) AS rank_number
  FROM datascience_8960_table)
  SELECT city, employee_id
  FROM rank_manager
  WHERE rank_number IN (1,2,3);")



