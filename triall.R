### PRICING CALCULATIONS
# last week performance
# last month performance
# last quarter performance

### VOLUMES CALCULATIONS
# weekly price
# monthly price
# last week performance
# last month performance
# last quarter performance
# YTD performance
# last 52 weeks performance

library(tidyquant)
library(data.table)
library(xts)
library(PerformanceAnalytics)


TICKERS = c("AAPL", "AMZN")
INIT_DATE = '2021-01-01'
END_DATE = Sys.Date()


dts = fetch_tickers(TICKERS)

dtw = dts[, c('ticker', 'index', 'adjusted')]
dtw = dcast(dtw, index ~ ticker, value.var = 'adjusted')

xts_dtw = xts::as.xts(dtw)

xts_dtw_mn = to.monthly(xts_dtw, OHLC = FALSE)
xts_dtw_wk = to.weekly(xts_dtw, OHLC = FALSE)

ls_week = end(xts_dtw_wk) - weeks(1)
ls_month = end(xts_dtw_wk) - months(1)
ls_quarter = end(xts_dtw_wk) - months(3)
ls_weeks52 = end(xts_dtw_wk) - months(12)
ls_ytd = as.Date(paste0(year(Sys.Date()), '-01', '-01'))

xts_dtw_ls_wk = window(xts_dtw_wk, start = ls_week)
xts_dtw_ls_mn = window(xts_dtw_wk, start = ls_month)
xts_dtw_ls_qr = window(xts_dtw_wk, start = ls_quarter)
xts_dtw_ls_52 = window(xts_dtw_wk, start = ls_weeks52)
xts_dtw_ls_ytd = window(xts_dtw_wk, start = ls_ytd)


xts_dtw_ls_ret_ann = PerformanceAnalytics::Return.annualized(xts_dtw_ls_52)
xts_dtw_ls_ret = PerformanceAnalytics::Return.calculate(xts_dtw_ls_52, method = 'log')
PerformanceAnalytics::Return.cumulative(xts_dtw_ls_ret)




# -----

calc_agg = function(type_agg, DT, cum = FALSE) {
   
   dtw = dts[, c('ticker', 'index', 'adjusted')]
   dtw = dcast(dtw, index ~ ticker, value.var = 'adjusted')
   
   xts_dtw = xts::as.xts(dtw)
   
   xts_dtw_wk = to.weekly(xts_dtw, OHLC = FALSE)
   
   ls_week = end(xts_dtw_wk) - weeks(1)
   ls_month = end(xts_dtw_wk) - months(1)
   ls_quarter = end(xts_dtw_wk) - months(3)
   ls_weeks52 = end(xts_dtw_wk) - months(12)
   ls_ytd = as.Date(paste0(year(Sys.Date()), '-01', '-01'))
   
   if(type_agg == 'ls_week') {xtw = window(xts_dtw_wk, start = ls_week)}
   if(type_agg == 'ls_month') {xtw = window(xts_dtw_wk, start = ls_month)}
   if(type_agg == 'ls_quarter') {xtw = window(xts_dtw_wk, start = ls_quarter)}
   if(type_agg == 'ls_weeks52') {xtw = window(xts_dtw_wk, start = ls_weeks52)}
   if(type_agg == 'ls_ytd') {xtw = window(xts_dtw_wk, start = ls_ytd)}
   
   xtw_ret = PerformanceAnalytics::Return.calculate(xtw, method = 'log')
   xtw_ret[-1]
   
   if(cum == TRUE) {xtw_ret = xts(apply(xtw_ret[-1], 2, cumsum), order.by = index(xtw_ret[-1]))}
   
   return(xtw_ret)

}

xts = calc_agg('ls_month', DT = dts, cum = TRUE)

xts = as.data.table(xts)
dts = melt(xts, id.vars = 'index', variable.name = 'ticker', value.name = 'price') 

hchart(dts,
       "line",
       hcaes(x = index, y = price, group = ticker)) |> 
   hc_xAxis(title = '', lineWidth = 0) |> 
   hc_yAxis(title = '')  |> 
   hc_legend(align = "left", verticalAlign = "top", layout = "horizontal")
