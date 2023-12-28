
# financia_fetch ------------------------

library(data.table)

TICKERS = c('ACQ.MI', 'AAPL')
INIT_DATE = '2018-01-01'
END_DATE = Sys.Date()


sym_data = tidyquant::tq_get(TICKERS,
                             get  = "stock.prices",
                             from = INIT_DATE,
                             to   = END_DATE)

if(!is.null(sym_data)) {
   data.table::setnames(sym_data, c("ticker", "index", "open", "high", "low", "close", "volume", "adjusted"))
   data.table::setDT(sym_data)
   }
   



# calc_agg ------------------------


dtw = sym_data[, c('ticker', 'index', 'adjusted')]
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

xtw = LISTA



## dt_tickersAgg ------------------------

# xtw = calc_agg(DT = dtw)

xts = xtw['price'][[1]]
xts_names = xtw['list_names'][[1]][[1]]
xts_names_na = xtw['list_names'][[1]][[2]]

### roll mean
# if(input$exp_dataCalc == 'calc_price') {
   xtss = copy(xts)
   dts = as.data.table(xtss)
   
   dts[, (xts_names_na) := lapply(.SD, function(x) fifelse(x == 0, NA_integer_, 1)), .SDcols = xts_names_na]
   prefixes = unique(gsub("_NA$", "", names(dts)[-1]))
   for (prefix in prefixes) {
      dts[, (prefix) := get(prefix) * get(paste0(prefix, "_NA"))]
      dts[, (paste0(prefix, "_NA")) := NULL]
   }
   
   dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
   dts[, value := round(value, digits = 2)]
# }
# if(input$exp_dataCalc == 'calc_ret') {
#    xtss = PerformanceAnalytics::Return.calculate(xts, method = 'log')
#    dts = as.data.table(xtss)
#    dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
#    dts[, value := round(value, digits = 2)]
# }
# if(input$exp_dataCalc == 'calc_cum_ret') {
#    xtw_ret = PerformanceAnalytics::Return.calculate(xts, method = 'log')
#    xtw_ret = na.omit(xtw_ret)
#    xtss = apply(xtw_ret, 2, cumsum)
#    indexx = zoo::index(xtss)
#    dts = as.data.table(xtss)
#    dts$index = indexx
#    dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
   dts[, value := round(value, digits = 2)]