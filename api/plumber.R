# plumber.R — API Layer for Founder's Flight Deck
# Author: Erwin Maurice McDonald
# Description: Exposes RESTful endpoints for RShiny dashboard data access

library(plumber)
library(DBI)
library(odbc)
library(jsonlite)

#* @apiTitle Founder's Flight Deck API
#* @apiDescription Modular API endpoints for Defense, Fintech, and Nonprofit dashboards

# Establish DB connection
con <- dbConnect(odbc::odbc(),
                 Driver = "ODBC Driver 17 for SQL Server",
                 Server = "5CD147L68L\\Veteran",
                 Database = "FlightDeckDB",
                 Trusted_Connection = "Yes")

#* Health Check
#* @get /health
function() {
  list(status = "ok", time = Sys.time())
}

#* Get Pipeline Data
#* @get /pipeline
function() {
  data <- dbReadTable(con, "PipelineData")
  return(toJSON(data, dataframe = "rows", pretty = TRUE, auto_unbox = TRUE))
}

#* Get Compliance Data
#* @get /compliance
function() {
  data <- dbReadTable(con, "ComplianceData")
  return(toJSON(data, dataframe = "rows", pretty = TRUE, auto_unbox = TRUE))
}

#* Get Fintech Data
#* @get /fintech
function() {
  data <- dbReadTable(con, "FintechData")
  return(toJSON(data, dataframe = "rows", pretty = TRUE, auto_unbox = TRUE))
}

#* Get Nonprofit Data
#* @get /nonprofit
function() {
  data <- dbReadTable(con, "NonprofitData")
  return(toJSON(data, dataframe = "rows", pretty = TRUE, auto_unbox = TRUE))
}
