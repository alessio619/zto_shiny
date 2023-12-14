

# : ========================================================================================================================================================



## Packages ----------------------------------------------------------------

box::use(shiny[...])
box::use(bslib[...])
#box::use(waiter[...])
box::use(data.table[...])
box::use(quantmod[...])
box::use(xts[...])
box::use(PerformanceAnalytics[...])
box::use(reactable[...])
box::use(reactable.extras[...])
box::use(highcharter[...])
box::use(shinyWidgets[...])
box::use(bsicons[...])


## Additional Options ----------------------------------------------------------------

options(shiny.maxRequestSize = 200*1024^2)

cat('021 ADMP - LOADING: Please wait while app is getting ready in your default browser...')



## Euronext Growth Milan List ----------------------------------------------------------------

### Load
engm_equities_list = setDT(read.csv2(file.path('data', 'engm_equities_list.csv')))








