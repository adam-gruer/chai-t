
#' # Rreports!
#' ## An introduction to using R for reporting
#' 
#' Adam Gruer 
#' Oct 27 2016
#' 
#' Last updated: `r Sys.time()`
#' 
#' ## Overview
#' This is a short demo on how R can be a very effective
#' tool for producing reports.  
#'  
#' ## Operating system and R version 
#'  Below are the details of the operating system and version of R used to 
#'  create this report.
#'  
version
#' ## Load packages
#' As always, the first step is to load all the necessary packages
#+ load-libs, include = TRUE
suppressPackageStartupMessages({
library(tidyverse)
library(lubridate)
})
#' ## Create some random test data for elective surgery waitlist report
#' 
waitlist <- tibble(
            month = seq.Date(
                            from = ymd("2015 Oct 31"),
                            to = ymd("2016 Oct 31"),
                            by = "month" ),
            patients_waiting = sample(
                                        1900:2000,
                                        size = 13,
                                        replace = TRUE),
            patients_admitted = sample(
                              600:900,
                              size = 13,
                              replace = TRUE)
            
            )
#' ## Imperial Little'uns Hospital, North Haverbrook 
#' ### Waitlist Data
knitr::kable(
            waitlist %>%
              arrange(desc(month)))

