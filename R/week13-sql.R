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

