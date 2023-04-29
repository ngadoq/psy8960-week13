# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(RMariaDB)

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
week13_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_8960_table;")

