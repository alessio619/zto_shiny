
# Inputs ================================================================================

server_app = function(input, output, session) {

   ## 01_explorer --------------------------------------------------------
   
   ### Ticker list
   tickers_full_list = eventReactive(input$exp_select_list, {
      engm_equities_lista = NULL  # Initialize outside the conditions
      
      if (input$exp_select_list == 'list_base') {
         engm_equities_lista = setDT(read.csv2(file.path('data', 'engm_equities_list.csv')))
      }
      
      if (input$exp_select_list == 'list_upload') {
         if (!is.null(input$exp_upload_tickerlist$datapath)) {
            engm_equities_lista = fread(input$exp_upload_tickerlist$datapath)
         } else {
            showNotification("Attention: No data uploaded", type = "error")
         }
      }
      
      if (input$exp_select_list == 'list_both') {
         if (!is.null(input$exp_upload_tickerlist$datapath)) {
            engm_equities_list_1 = fread(input$exp_upload_tickerlist$datapath)
            engm_equities_list_2 = setDT(read.csv2(file.path('data', 'Euronext_Equities_2023-12-06.csv')))
            engm_equities_lista = rbind(engm_equities_list_1, engm_equities_list_2, fill = TRUE)
         } else {
            engm_equities_lista = setDT(read.csv2(file.path('data', 'engm_equities_list.csv')))
            showNotification("Attention: No data uploaded", type = "error")
         }
      }
      
      return(engm_equities_lista)
   })
   
   
   ### Update selector
   observe({

      req(tickers_full_list())

      x = tickers_full_list()$name_company
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'exp_select_ticker',
                        label = NULL,
                        choices = unique(x)
      )
   })
   
   
   ### Update selector
   observe({
      
      req(tickers_full_list())
      
      ita_list = tickers_full_list()[name_company %in% input$exp_select_ticker]$code_ticker
      full_list = c(ita_list, strsplit(input$exp_insert_ticker, ";")[[1]])
      
      x = full_list
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'exp_select_tickerTable',
                        label = NULL,
                        choices = unique(x)
      )
   })   
   
   
   
   ### Find TICKERS from NAMES
   ticker_list = eventReactive(input$exp_button_fetchTickers | input$exp_button_fetchFinancials, {

      req(tickers_full_list())
      ita_list = tickers_full_list()[name_company %in% input$exp_select_ticker]$code_ticker
      full_list = c(ita_list, strsplit(input$exp_insert_ticker, ";")[[1]])
      return(full_list)

   })
   
   ### Fetch and Retrieve Tickers Data
   dt_fetchedTickers = eventReactive(input$exp_button_fetchTickers, {
      req(ticker_list())
      
      dt_sym_wk = fetch_tickers(TICKERS = ticker_list(),
                                INIT_DATE = input$exp_dateRange[1],
                                END_DATE = input$exp_dateRange[2])
      
      return(dt_sym_wk)
      
   })
   
   ### Calculations on Tickers:
   dt_tickersAgg = reactive({
      
      req(dt_fetchedTickers())
      
      dtw = copy(dt_fetchedTickers())
      
      xtw = calc_agg(DT = dtw)
      
      xts = xtw[input$exp_dataAgg][[1]]
      
      ### roll mean
      if(input$exp_dataCalc == 'calc_price') {
         xtss = copy(xts)
         dts = as.data.table(xtss)
         dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
         dts[, value := round(value, digits = 2)]
         }
      if(input$exp_dataCalc == 'calc_ret') {
         xtss = PerformanceAnalytics::Return.calculate(xts, method = 'log')
         dts = as.data.table(xtss)
         dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
         dts[, value := round(value, digits = 2)]
         }
      if(input$exp_dataCalc == 'calc_cum_ret') {
         xtw_ret = PerformanceAnalytics::Return.calculate(xts, method = 'log')
         xtw_ret = na.omit(xtw_ret)
         xtss = apply(xtw_ret, 2, cumsum)
         indexx = zoo::index(xtss)
         dts = as.data.table(xtss)
         dts$index = indexx
         dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
         dts[, value := round(value, digits = 2)]
         } 
      
      return(dts)
      
   })
   
   observe({
      x = dt_tickersAgg()$ticker
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'exp_select_ticker_boxes',
                        label = NULL,
                        choices = unique(x),
                        selected = head(unique(x), 1)
      )
   })
   
   ### Calculation Value Boxes
   output$calc_max_value = renderText({
      req(dt_tickersAgg())
      round(max(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, na.rm = TRUE), digits = 2)
   })
   
   output$calc_min_value = renderText({
      req(dt_tickersAgg())
      round(min(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, na.rm = TRUE), digits = 2)
   })
   
   output$calc_mean_value = renderText({
      req(dt_tickersAgg())
      round(mean(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, na.rm = TRUE), digits = 2)
   })   

   output$calc_median_value = renderText({
      req(dt_tickersAgg())
      round(median(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, na.rm = TRUE), digits = 2)
   })   
   
   
   ### Plot Tickers Data
   output$exp_plot_tickersSeries = renderHighchart({
     
      req(dt_tickersAgg())
     
      hchart(dt_tickersAgg(),
             "line",
             hcaes(x = index, y = value, group = ticker)) |> 
         hc_xAxis(title = '', lineWidth = 0) |> 
         hc_yAxis(title = '')  |> 
         hc_legend(align = "left", verticalAlign = "top", layout = "horizontal")
    
  })
   
   
   ### Calculations Tickers Data.table:
   dt_tickersTable = reactive({
      
      req(dt_fetchedTickers())
      
      dtw = copy(dt_fetchedTickers())
      xtw = calc_agg(DT = dtw)
      xtw = xtw[input$exp_dataAgg][[1]]
      
      ### Returns
      xtw_ret = PerformanceAnalytics::Return.calculate(xtw, method = 'log')
      xtw_ret[is.na(xtw_ret)] = 0
      xtw_ret_cum = apply(xtw_ret, 2, cumsum)
      indexx = zoo::index(xtw_ret)
      
      dts_p = as.data.table(xtw)
      dts_r = as.data.table(xtw_ret)
      dts_rc = as.data.table(xtw_ret_cum)
      dts_rc$index = indexx
      
      dts_p = melt(dts_p, id.vars = 'index', variable.name = 'ticker', value.name = 'price')
      dts_r = melt(dts_r, id.vars = 'index', variable.name = 'ticker', value.name = 'return')
      dts_rc = melt(dts_rc, id.vars = 'index', variable.name = 'ticker', value.name = 'return_cum')
      
      dts = Reduce(function(x, y) merge(x, y, by = c("index", 'ticker')), list(dts_p, dts_r, dts_rc))
      setDT(dts)   
      dts[, (c('price', 'return', 'return_cum')) := lapply(.SD, function(x) round(x, 2)), .SDcols = c('price', 'return', 'return_cum')]
      
      return(dts)
      
   })
   
   ### Table Retrieved companies historical data
   output$exp_table_tickersSeries = renderReactable({
      
      req(dt_tickersTable())
      
      DTW = copy(dt_tickersTable())
      setnames(DTW, old = names(DTW), new = toupper(names(DTW)))
      
      reactable(DTW,
                highlight = TRUE,
                outlined = FALSE,
                compact = TRUE,
                wrap = FALSE,
                defaultPageSize = 12)
      
   })
   
   
   ### Download Tickers Data
   output$exp_button_download = downloadHandler(
      
      filename = function() {
         # Use the selected dataset as the suggested file name
         paste0('dataset', ".csv")
      },
      content = function(file) {
         # Write the dataset to the `file` that will be downloaded
         write.csv(dt_tickersTable(), file)
      }
   )   
   
   
   ### Fetch and Retrieve Tickers Data
   dt_fetchedFinancials = eventReactive(input$exp_button_fetchFinancials, {
      
      req(ticker_list())
      
      print('INIT')
      
      list_ticker_a = fc$fetch_statements_annual(ticker_list()[1])
      dtw_bs_a = fc$get_financial_statements_annual(list_ticker_a, STMT = 'balance')
      dtw_in_a = fc$get_financial_statements_annual(list_ticker_a, STMT = 'income')
      dtw_cs_a = fc$get_financial_statements_annual(list_ticker_a, STMT = 'cash')
      
      list_ticker_q = fc$fetch_statements_quarterly(ticker_list()[1])
      dtw_in_q = fc$get_financial_statements_quarterly(list_ticker_q, STMT = 'income')
      dtw_cs_q = fc$get_financial_statements_quarterly(list_ticker_q, STMT = 'cash')
      
      dt_sym_wk = list(dtw_bs_a, dtw_in_a, dtw_cs_a, dtw_in_q, dtw_cs_q)
      return(dt_sym_wk)
      print('END')
      
   })
   
   
   ### Table Retrieved companies data
   output$exp_table_tickersFinancials = renderReactable({
      
      req(dt_fetchedFinancials())
      
      print('DETECTED')
      
      DTS = copy(dt_tickersTable())
      # setnames(DTW, old = names(DTW), new = toupper(names(DTW)))
      
      if(input$exp_finTime == 'table_yearly') {
         
         if(input$exp_finType == 'table_type_bs') {DTW = copy(DTS[1])}
         if(input$exp_finType == 'table_type_in') {DTW = copy(dtw_in_a)}
         if(input$exp_finType == 'table_type_cs') {DTW = copy(dtw_cs_a)}
         
      } else if(input$exp_finTime == 'table_quarterly') {
         
         if(input$exp_finType == 'table_type_in') {DTW = copy(dtw_in_q)}
         if(input$exp_finType == 'table_type_cs') {DTW = copy(dtw_cs_q)}
         
      }
      
      reactable(DTW,
                highlight = TRUE,
                outlined = FALSE,
                compact = TRUE,
                wrap = FALSE,
                defaultPageSize = 12)
      
   })
   
   
   # ## 02_financials --------------------------------------------------------

   
   
   ## END --------------
   
   output$texto = renderPrint({

      dt_fetchedFinancials()
      
   })
  
}
