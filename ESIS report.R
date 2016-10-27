
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
#'  tool for producing reports.  
#'  
#' ## Operating system and R version 
#'  Below are the details of the operating system and version of R used to create this report
#'  
version
#' ## Load packages
#' As always, the first step is to load all the necessary packages
#+ load-libs, include = TRUE
suppressPackageStartupMessages({
library(tidyverse)
})
