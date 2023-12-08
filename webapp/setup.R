

# : ========================================================================================================================================================



## Packages ----------------------------------------------------------------

box::use(shiny[...])
box::use(bslib[...])
#box::use(waiter[...])
box::use(data.table[...])
box::use(quantmod[...])
box::use(reactable[...])
box::use(reactable.extras[...])
box::use(highcharter[...])
box::use(shinyWidgets[...])



## Additional Options ----------------------------------------------------------------

options(shiny.maxRequestSize = 200*1024^2)

cat('021 ADMP - LOADING: Please wait while app is getting ready in your default browser...')



## Euronext Growth Milan List ----------------------------------------------------------------
# 
# ### Load 
# engm_equities_list = setDT(read.csv2(file.path('data', 'Euronext_Equities_2023-12-06.csv')))
# 
# ### Clean & Create
# engm_equities_list[, id := .I]
# engm_equities_list[, ticker_code := paste0(Symbol, '.MI')]
# engm_equities_list = engm_equities_list[-c(1:3), .(id, Market, ticker_code, Symbol, Name, ISIN, last.Trade.MIC.Time)]
# names(engm_equities_list) = c('id', 'name_market', 'code_ticker', 'code_symbol', 'name_company', 'code_isin', 'date_lastTrade')
# 
# engm_equities_list[, date_lastTrade := as.Date(date_lastTrade, format = "%d/%m/%Y %H:%M")]
# engm_equities_list[, flag_active := fifelse(date_lastTrade > (Sys.Date() - 30), TRUE, FALSE)]
# 
# ### Export
# write.csv2(engm_equities_list, file.path('data', 'engm_equities_list.csv')) 
# 
# 
