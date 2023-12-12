
# Financial API ========================

fetch_tickers = function(TICKERS, INIT_DATE = '2021-01-01', END_DATE = Sys.Date()) {
   
      tryCatch({
         
         sym_data = tidyquant::tq_get(TICKERS,
                           get  = "stock.prices",
                           from = INIT_DATE,
                           to   = END_DATE)
         
         data.table::setnames(sym_data, c("ticker", "index", "open", "high", "low", "close", "volume", "adjusted"))
         
      }, error = function(e) {
         cat("Error for $TICKERS", ":", conditionMessage(e), "\n")
         return(NULL)
      })
      
   data.table::setDT(sym_data)
   
   return(sym_data)
   
}


# Aggregation Function ========================

calc_agg = function(type_agg, DT, cum = FALSE) {
   
   dtw = DT[, c('ticker', 'index', 'adjusted')]
   dtw = dcast(dtw, index ~ ticker, value.var = 'adjusted')
   
   xts_dtw = xts::as.xts(dtw)
   
   xts_dtw_wk = to.weekly(xts_dtw, OHLC = FALSE)
   
   ls_week = end(xts_dtw_wk) - lubridate::weeks(1)
   ls_month = end(xts_dtw_wk) - months(1)
   ls_quarter = end(xts_dtw_wk) - months(3)
   ls_weeks52 = end(xts_dtw_wk) - months(12)
   ls_ytd = as.Date(paste0(year(Sys.Date()), '-01', '-01'))
   
   if(type_agg == 'ls_week') {xtw = xts_dtw_wk}
   if(type_agg == 'ls_month') {xtw = window(xts_dtw_wk, start = ls_month)}
   if(type_agg == 'ls_quarter') {xtw = window(xts_dtw_wk, start = ls_quarter)}
   if(type_agg == 'ls_52') {xtw = window(xts_dtw_wk, start = ls_weeks52)}
   if(type_agg == 'ls_ytd') {xtw = window(xts_dtw_wk, start = ls_ytd)}
   
   xtw_ret = PerformanceAnalytics::Return.calculate(xtw, method = 'log')
   xtw_ret[-1]
   
   if(cum == TRUE) {xtw_ret = xts(apply(xtw_ret[-1], 2, cumsum), order.by = index(xtw_ret[-1]))}
   
   return(xtw_ret)
   
}