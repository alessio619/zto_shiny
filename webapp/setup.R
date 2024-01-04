

# : ========================================================================================================================================================



## Packages ----------------------------------------------------------------

box::use(shiny[...])
box::use(bslib[...])
box::use(waiter[...])
box::use(data.table[...])
box::use(quantmod[...])
box::use(xts[...])
box::use(PerformanceAnalytics[...])
box::use(reactable[...])
box::use(reactable.extras[...])
box::use(highcharter[...])
box::use(shinyWidgets[...])
box::use(bsicons[...])
box::use(shinymanager[...])



## Additional Options ----------------------------------------------------------------

options(shiny.maxRequestSize = 200*1024^2)

cat('021 ADMP - LOADING: Please wait while app is getting ready in your default browser...')


## Load SQLite DB ----------------------------------------------------------------

# connn = dbConnect(SQLite(), dbname = "data/zto_database.db")
# dt_connn = data.table::data.table(dbReadTable(connn, "my_companies"))


## Euronext Growth Milan List ----------------------------------------------------------------

### Load
engm_equities_list = setDT(read.csv2(file.path('data', 'engm_equities_list.csv')))



## Credentials ----------------------------------------------------------------

credentials <- data.frame(
   user = c("master", "nic", 'guest'), # mandatory
   password = c("azerty", "azerty", 'D10S'), # mandatory
   start = c("2024-01-01", '2024-01-01', '2024-01-01'), # optinal (all others)
   expire = c(NA, NA, NA),
   admin = c(TRUE, FALSE, FALSE),
   comment = "",
   stringsAsFactors = FALSE
)

