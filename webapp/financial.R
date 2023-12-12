
# Tickers historical API ========================

#' @export

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


#' @export

calc_agg = function(DT) {
   
   dtw = DT[, c('ticker', 'index', 'adjusted')]
   dtw = data.table::dcast(dtw, index ~ ticker, value.var = 'adjusted')
   
   xts_dtw = xts::as.xts(dtw)
   
   xts_dtw_wk = xts::to.weekly(xts_dtw, OHLC = FALSE)
   
   ls_week = stats::end(xts_dtw_wk) - lubridate::weeks(1)
   ls_month = stats::end(xts_dtw_wk) - months(1)
   ls_quarter = stats::end(xts_dtw_wk) - months(3)
   ls_weeks52 = stats::end(xts_dtw_wk) - months(12)
   ls_ytd = as.Date(paste0(data.table::year(Sys.Date()), '-01', '-01'))
   
   xts_dtw_wk_ls_week = stats::window(xts_dtw_wk, start = ls_week)
   xts_dtw_wk_ls_month = stats::window(xts_dtw_wk, start = ls_month)
   xts_dtw_wk_ls_quarter = stats::window(xts_dtw_wk, start = ls_quarter)
   xts_dtw_wk_ls_weeks52 = stats::window(xts_dtw_wk, start = ls_weeks52)
   xts_dtw_wk_ls_ytd = stats::window(xts_dtw_wk, start = ls_ytd)
   
   LISTA = list(xts_dtw_wk, xts_dtw_wk_ls_week, xts_dtw_wk_ls_month, xts_dtw_wk_ls_quarter, xts_dtw_wk_ls_weeks52, xts_dtw_wk_ls_ytd)
   names(LISTA) = c('price', 'last_week', 'last_month', 'last_quarter', 'last_year', 'ytd')
   
   return(LISTA)
   
}



# Financial Statements  ----------------------------------------------------------------


#' @export

fetch_statements_annual = function(SYMBOL) {
   
   yahoo = reticulate::import("yahoofinancials")
   yf = yahoo$YahooFinancials
   
   id_ticker = SYMBOL
   
   yfo = yf(id_ticker)
   ann_in = yfo$get_financial_stmts('annual', 'income')
   ann_bs = yfo$get_financial_stmts('annual', 'balance')
   ann_cs = yfo$get_financial_stmts('annual', 'cash')   
   
   return(list(ann_in, ann_bs, ann_cs))
   
}


#' @export

get_financial_statements_annual = function(TICKER_LIST, STMT) {
   
   ticker_list = TICKER_LIST
   
   ticker_symbol = names(ticker_list[[1]][[1]])
   
   if(STMT == 'income') {
      ann_in_list = ticker_list[[1]][[1]][[1]]
      statement = names(ticker_list[[1]])
   }
   if(STMT == 'balance') {
      ann_in_list = ticker_list[[2]][[1]][[1]]
      statement = names(ticker_list[[2]])
   }
   if(STMT == 'cash') {
      ann_in_list = ticker_list[[3]][[1]][[1]]
      statement = names(ticker_list[[3]])
   }
   
   
   LISTA = list()
   
   for (i in 1:length(ann_in_list)) {
      year_x = paste0('Y', data.table::year(names(ann_in_list[[i]])))
      list_x = ann_in_list[[i]][[1]]
      dt_x = data.table::as.data.table(list_x)
      dt_x = data.table::melt(dt_x, variable.name = 'voice', value.name = 'value')
      
      dt_x[, value := round(value, digits = 2)]
      dt_x$voice.1 = NULL
      
      data.table::setnames(dt_x, c('voice', year_x))
      
      LISTA[[i]] = dt_x
      
   }
   
   dtw = Reduce(merge, LISTA)
   
   dtw[, id := ticker_symbol]
   dtw[, stmt := statement]
   
   data.table::setcolorder(dtw, neworder = c('id', 'stmt', 'voice'))
   
   return(dtw)
   
}



#' @export

fetch_statements_quarterly = function(SYMBOL) {
   
   yahoo = reticulate::import("yahoofinancials")
   yf = yahoo$YahooFinancials
   
   id_ticker = SYMBOL
   
   yfo = yf(id_ticker)
   ann_in = yfo$get_financial_stmts('quarterly', 'income')
   ann_bs = yfo$get_financial_stmts('quarterly', 'balance')
   ann_cs = yfo$get_financial_stmts('quarterly', 'cash')   
   
   return(list(ann_in, ann_bs, ann_cs))
   
}



#' @export

get_financial_statements_quarterly = function(TICKER_LIST, STMT) {
   
   ticker_list = TICKER_LIST
   
   ticker_symbol = names(ticker_list[[1]][[1]])
   
   if(STMT == 'income') {
      ann_in_list = ticker_list[[1]][[1]][[1]][[1]]
      statement = names(ticker_list[[1]])
   }
   
   if(STMT == 'cash') {
      ann_in_list = ticker_list[[3]][[1]][[1]][[1]]
      statement = names(ticker_list[[3]])
   }
   
   
   LISTA = list()
   
   year_x = paste0('TTM', names(ann_in_list))
   list_x = ann_in_list[[1]]
   dt_x = data.table::as.data.table(list_x)
   dt_x = data.table::melt(dt_x, variable.name = 'voice', value.name = 'value')
   
   dt_x[, value := round(value, digits = 2)]
   dt_x$voice.1 = NULL
   
   data.table::setnames(dt_x, c('voice', year_x))
   
   dt_x[, id := ticker_symbol]
   dt_x[, stmt := statement]
   
   data.table::setcolorder(dt_x, neworder = c('id', 'stmt', 'voice'))
   
   return(dt_x)
   
}
