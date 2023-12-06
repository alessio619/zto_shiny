
# Financial API ========================

fetch_tickers = function(TICKERS, INIT_DATE = '2021-01-01', END_DATE = Sys.Date(), TYPE = 'weekly') {
   
   data_list = lapply(TICKERS, function(sym) {
      
      tryCatch({
         sym_data = quantmod::getSymbols(sym, src = "yahoo", from = INIT_DATE, to = END_DATE, auto.assign = FALSE)
         
         if(TYPE == 'weekly') {
            sym_data = xts::to.weekly(sym_data, OHLC=FALSE)
         } else if(TYPE == 'monthly') {
            sym_data = xts::to.monthly(sym_data, OHLC=FALSE)
         } else if(TYPE == 'yearly') {
            sym_data = xts::to.yearly(sym_data, OHLC=FALSE)
         } else {
            sym_data = sym_data
         }
         
         price_data = as.data.table(sym_data[, 6, drop = FALSE])
         vol_data = as.data.table(sym_data[, 5, drop = FALSE])
         ticker = rep(sym, nrow(price_data))
         
         DT = data.table(as.data.table(price_data)[,1], ticker, price = price_data[, 2, with = FALSE], volume = vol_data[, 2, with = FALSE])
         setnames(DT, c("index", "ticker", "price", "volume"))
         
      }, error = function(e) {
         cat("Error for $TICKERS", sym, ":", conditionMessage(e), "\n")
         return(NULL)
      })
      
   })
   
   # Remove NULL entries (symbols with errors)
   data_list = Filter(Negate(is.null), data_list)
   
   if (length(data_list) == 0) {
      cat("No $TICKERS retrieved.\n")
      return(NULL)
   }
   
   if (length(data_list) == length(TICKERS)) {
      cat("All $TICKERS successfully fetched.\n")
      return(NULL)
   }   
   
   final_data = rbindlist(data_list)
   return(final_data)
   
}