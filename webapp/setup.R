

# : ========================================================================================================================================================



## Packages ----------------------------------------------------------------

library(shiny)
library(bslib)
library(data.table)
library(quantmod)
library(reactable)
library(reactable.extras)
library(highcharter)
library(fresh)
library(waiter)


### Additional Options

options(shiny.maxRequestSize = 200*1024^2)

cat('Macroeconomics Toolset - LOADING: Please wait while app is getting ready in your default browser...')


euronext_data = data.table(
  company_name = c('Comer Industries', 'Ferretti', 'Italian Design Brand'),
  company_ticker = c('COM.MI', 'YACHT.MI', 'IDB.MI')
)