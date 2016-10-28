#' ---
#' title: "Wait list Slides"
#' author: Adam Gruer
#' date: October 28 2016
#' output: revealjs::revealjs_presentation
#' ---
#' 
#' # Load packages
#' As always, the first step is to load all the necessary packages
#+ load-libs, include = TRUE
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})
#' ## Create some random test data for elective surgery waitlist report
#' 
set.seed(198) #100
waitlist <- tibble(
  month = seq.Date(
    from = ymd("2015 Oct 01"),
    to = ymd("2016 Oct 01"),
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
#' Let's use the dplyr package to work out the patients added each month using 
#' the difference between the month and the previous month , **add back** the admissions
#' in the month.  We add this to out data table.
waitlist <- waitlist %>%
  mutate( patients_waiting_change =
            patients_waiting - lag(patients_waiting) ) %>%
  mutate( patients_added = 
            patients_waiting_change + patients_admitted) %>%
  replace_na(list(patients_added = 750L, patients_waiting_change = -12L))
#'
#' We will create some variables for the hospital name and city so we don't have to
#' type it everywhere - and when we get a new job we can bring this report with us
hospital_name <-  "Imperial Little'uns Hospital"
hospital_city <-  "North Haverbrook"

#'
#' # `r stringr::str_interp("${hospital_name}, ${hospital_city}")`
#' ### Waitlist Report
#+ kable, echo = FALSE
knitr::kable(
  waitlist %>%
    arrange(desc(month)))
#' ## Waitlist Trend
 
ggplot(data = waitlist) +
  geom_bar(mapping = aes(
    x = month,
    y = patients_waiting),
    stat  = "identity", fill ="steelblue1") +
  
  scale_x_date(date_breaks = "1 month",
               date_labels = "%b %y") +
  scale_y_continuous(name = "Patients Waiting") +
  theme_bw() +
  ggtitle(stringr::str_interp("${hospital_name} - Waiting List Trend"))

#+ commentary, echo = FALSE
commentary_month <- last(waitlist$month)

commentary_month_name <- as.character(month(commentary_month,
                                            label = TRUE,
                                            abbr = FALSE))
commentary_month_waitlist <- last(waitlist$patients_waiting)
commentary_month_admitted <- last(waitlist$patients_admitted)
prior_month_waitlist <- nth(waitlist$patients_waiting, -2L)
commentary_month_added <- last(waitlist$patients_added)

change <-  last(waitlist$patients_waiting_change)
change_percent <-  as.double(change) / as.double(prior_month_waitlist) * 100.0
change_description <- if (change < 0) {
  "decreased by"} else if (change > 0) {
    "increased by"} else {"remained unchanged"}

#' `r stringr::str_interp(
#'        c(
#'        "In ${commentary_month_name}, the waiting list for elective surgery ",
#'        "${change_description} ${change} ($[1.1f%%]{change_percent}) to ${commentary_month_waitlist}.",
#'        " There were ${commentary_month_admitted} admissions from the waiting list and ${commentary_month_added}",
#'          " children were added to the waiting list during the month."))`

 
#' # wait list change
ggplot(data = waitlist) +
  geom_bar(mapping = aes(
    x = month,
    y = patients_waiting_change,
    fill = (patients_waiting_change > 0) ),
    stat  = "identity",position = "dodge" ) +
  guides(fill = FALSE) +
  scale_x_date(date_breaks = "1 month",
               date_labels = "%b %y") +
  scale_y_continuous(name = "Change in waitlist") +
  theme_bw() +
  ggtitle(stringr::str_interp("${hospital_name} - Waiting List Monthly Change"))


#' # Monthly Admissions and Additions
#+ admissions_additios-plot, echo = FALSE
admissions_additions <- waitlist %>% 
  select(month,
         patients_added,
         patients_admitted) %>%
  gather(waitlist_action,number_patients, -month)

ggplot(admissions_additions) +
  geom_bar(mapping = aes(
    x = waitlist_action,
    y = number_patients ,
    fill = waitlist_action),
    position = "dodge",
    stat  = "identity") +
  facet_wrap(~month)+
  scale_y_continuous(name = "Patients", limits = c(0,1000)) +
  theme_bw() +
  theme(legend.position = "bottom") +
  ggtitle(stringr::str_interp("${hospital_name} - Monthly Waitlist Admissions and Additions"))

#' 
ggplot(admissions_additions) +
  geom_bar(mapping = aes(
    x = month,
    y = number_patients ,
    fill = waitlist_action),
    position = "dodge",
    stat  = "identity") +
  facet_wrap(~waitlist_action)+
  scale_x_date(date_breaks = "1 month",
               date_labels = "%b") +
  scale_y_continuous(name = "Patients") +
  theme_bw() +
  theme(legend.position = "bottom") +
  ggtitle(stringr::str_interp("${hospital_name} - Monthly Waitlist Admissions and Additions"))



