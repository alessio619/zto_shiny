req(dt_fetchedTickers())

dtw = dt_fetchedTickers()

xtw = calc_agg(DT = dtw)

xts = xtw[input$exp_dataAgg][[1]]
xts_names = xtw['list_names'][[1]][[1]]
xts_names_na = xtw['list_names'][[1]][[2]]

### roll mean
if(input$exp_dataCalc == 'calc_price') {
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
}
if(input$exp_dataCalc == 'calc_ret') {
   xtss = PerformanceAnalytics::Return.calculate(xts, method = 'log')
   dts = as.data.table(xtss)
   dts[, (xts_names_na) := lapply(.SD, function(x) fifelse(x == 0, NA_integer_, 1)), .SDcols = xts_names_na]
   prefixes = unique(gsub("_NA$", "", names(dts)[-1]))
   for (prefix in prefixes) {
      dts[, (prefix) := get(prefix) * get(paste0(prefix, "_NA"))]
      dts[, (paste0(prefix, "_NA")) := NULL]
   }
   dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
   dts[, value := round(value, digits = 2)]
}
if(input$exp_dataCalc == 'calc_cum_ret') {
   xtw_ret = PerformanceAnalytics::Return.calculate(xts, method = 'log')
   xtw_ret = na.omit(xtw_ret)
   xtss = apply(xtw_ret, 2, cumsum)
   indexx = zoo::index(xtss)
   dts = as.data.table(xtss)
   dts[, (xts_names_na) := lapply(.SD, function(x) fifelse(x == 0, NA_integer_, 1)), .SDcols = xts_names_na]
   prefixes = unique(gsub("_NA$", "", names(dts)[-1]))
   for (prefix in prefixes) {
      dts[, (prefix) := get(prefix) * get(paste0(prefix, "_NA"))]
      dts[, (paste0(prefix, "_NA")) := NULL]
   }
   dts$index = indexx
   dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
   dts[, value := round(value, digits = 2)]
} 

return(dts)