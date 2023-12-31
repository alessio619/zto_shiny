
# Tickers historical API ========================

fetch_tickers = function(TICKERS, INIT_DATE = '2021-01-01', END_DATE = Sys.Date()) {
   
   tryCatch({
      
      sym_data = tidyquant::tq_get(TICKERS,
                                   get  = "stock.prices",
                                   from = INIT_DATE,
                                   to   = END_DATE)
      
      if(!is.null(sym_data)) {
         data.table::setnames(sym_data, c("ticker", "index", "open", "high", "low", "close", "volume", "adjusted"))
         data.table::setDT(sym_data)
         }
      
   }, error = function(e) {

      sym_data = data.table(ticker = NA_character_, index = NA_integer_, open = NA_complex_, high = NA_complex_,
                            low = NA_complex_, close = NA_complex_, volume = NA_complex_, adjusted = NA_complex_)
      
      return(NULL)
   })
   
   return(sym_data)
   
}


# Aggregation Function ========================




calc_agg = function(DT) {
   
   dtw = DT[, c('ticker', 'index', 'adjusted')]
   dtw = data.table::dcast(dtw, index ~ ticker, value.var = 'adjusted')

   kc_cols = setdiff(names(dtw), "index")
   kc_cols_na = paste0(kc_cols, '_NA')
   
   dtw[, (paste0(kc_cols, '_NA')) := lapply(.SD, function(x) fifelse(is.na(x), 0, 1)), .SDcols = kc_cols]
   
   dtw[, (kc_cols) := lapply(.SD, nafill, type = "locf"), .SDcols = kc_cols]
   dtw[, (kc_cols) := lapply(.SD, nafill, type = "nocb"), .SDcols = kc_cols]   
   
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
   
   list_names = list(kc_cols, kc_cols_na)
   
   LISTA = list(xts_dtw_wk, xts_dtw_wk_ls_week, xts_dtw_wk_ls_month, xts_dtw_wk_ls_quarter, xts_dtw_wk_ls_weeks52, xts_dtw_wk_ls_ytd, list_names)
   names(LISTA) = c('price', 'last_week', 'last_month', 'last_quarter', 'last_year', 'ytd', 'list_names')
   
   return(LISTA)
   
}



# Financial Statements  ----------------------------------------------------------------


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




fetch_statements = function(TICKER) {
   
   list_ticker_a = fetch_statements_annual(TICKER)
   
   dtw_bs_a = get_financial_statements_annual(list_ticker_a, STMT = 'balance')
   dtw_in_a = get_financial_statements_annual(list_ticker_a, STMT = 'income')
   dtw_cs_a = get_financial_statements_annual(list_ticker_a, STMT = 'cash')
   
   ## Retrieve Quarterly data YF ---------------------------------
   list_ticker_q = fetch_statements_quarterly(TICKER)
   
   dtw_in_q = get_financial_statements_quarterly(list_ticker_q, STMT = 'income')
   dtw_cs_q = get_financial_statements_quarterly(list_ticker_q, STMT = 'cash')
   
   lista_stmt = list(dtw_bs_a, dtw_in_a, dtw_cs_a, dtw_in_q, dtw_cs_q)
   names(lista_stmt) = c('bs_y', 'in_y', 'cs_y', 'in_q', 'cs_q')
   
   return(lista_stmt)
   
}




get_statements = function(TICKERS) {
   
   result_list = list()
   
   for (i in TICKERS) {
      result_list[[i]] = fetch_statements(i)
   }
   
   return(result_list)
   
}




record_statements = function(DT, COMPANY) {
   
   DTT = copy(DT)
   
   DTS = DTT[[COMPANY]]
   
   DTW_bsy = copy(DTS[['bs_y']])
   DTW_iny = copy(DTS[['in_y']])
   DTW_csy = copy(DTS[['cs_y']])
   DTW_inq = copy(DTS[['in_q']])
   DTW_csq = copy(DTS[['cs_q']])
   
   dtw_bsy = melt(DTW_bsy[, type := 'annual'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
   dtw_iny = melt(DTW_iny[, type := 'annual'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
   dtw_csy = melt(DTW_csy[, type := 'annual'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
   dtw_inq = melt(DTW_inq[, type := 'quarter'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
   dtw_csq = melt(DTW_csq[, type := 'quarter'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
   
   dtw = rbindlist(list(dtw_bsy, dtw_iny, dtw_csy, dtw_inq, dtw_csq))
   
   setnames(dtw, 'id', 'company_id')
   
   return(dtw)
   
}
