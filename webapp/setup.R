

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


## Select Company
# id_ticker = 'ITD.MI'


## Retrieve Annual data YF ---------------------------------
# list_ticker_a = fc$fetch_statements_annual(id_ticker)

# dtw_in_a = fc$get_financial_statements_annual(list_ticker_a, STMT = 'income')
# dtw_bs_a = fc$get_financial_statements_annual(list_ticker_a, STMT = 'balance')
# dtw_cs_a = fc$get_financial_statements_annual(list_ticker_a, STMT = 'cash')

# write.csv2(dtw_in_a, 'data/annual_income_statement.csv')
# write.csv2(dtw_bs_a, 'data/annual_balance_sheet.csv')
# write.csv2(dtw_cs_a, 'data/annual_cashflow_statement.csv')
# 
# dtw_in_a = read.csv2('data/annual_income_statement.csv')
# dtw_bs_a = read.csv2('data/annual_balance_sheet.csv')
# dtw_cs_a = read.csv2('data/annual_cashflow_statement.csv')


# list_ticker_q = fc$fetch_statements_quarterly(id_ticker)

# dtw_in_q = fc$get_financial_statements_quarterly(list_ticker_q, STMT = 'income')
# dtw_cs_q = fc$get_financial_statements_quarterly(list_ticker_q, STMT = 'cash')

## Export
# write.csv2(dtw_in_q, 'data/quarterly_income_statement.csv')
# write.csv2(dtw_cs_q, 'data/quarterly_cashflow_statement.csv')
# 
# dtw_in_q = read.csv2('data/quarterly_income_statement.csv')
# dtw_cs_q = read.csv2('data/quarterly_cashflow_statement.csv')


