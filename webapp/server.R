
# Inputs ================================================================================

server_app = function(input, output, session) {

   ## 01_explorer --------------------------------------------------------
   
   ### Find TICKERS from NAMES
   ticker_list = eventReactive(input$exp_button_fetchTickers, {
      
      ita_list = engm_equities_list[name_company %in% input$exp_select_ticker]$code_ticker
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
      if(input$exp_dataCalc == 'calc_price') {xtss = copy(xts)}
      if(input$exp_dataCalc == 'calc_ret') {xtss = PerformanceAnalytics::Return.calculate(xts, method = 'log')}
      if(input$exp_dataCalc == 'calc_cumret') {
         xtw_ret = PerformanceAnalytics::Return.calculate(xts, method = 'log')
         xtw_ret = xtw_ret[-2]
         xtss = apply(xtw_ret, 2, cumsum)
         }
      if(input$exp_dataCalc == 'calc_roll_mean') {xtss = zoo::rollmean(PerformanceAnalytics::Return.calculate(xts, method = 'log'), k = 4)}
      
      dts = as.data.table(xtss)
      dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
      
      dts[, value := round(value, digits = 2)]
      
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
      round(max(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value), digits = 2)
   })
   
   output$calc_min_value = renderText({
      req(dt_tickersAgg())
      round(min(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value), digits = 2)
   })
   
   output$calc_mean_value = renderText({
      req(dt_tickersAgg())
      round(mean(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value), digits = 2)
   })   

   output$calc_median_value = renderText({
      req(dt_tickersAgg())
      round(median(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value), digits = 2)
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
   
   
   ### Table Retrieved companies data
   output$exp_table_tickersSeries = renderReactable({
      
      req(dt_tickersAgg())
      
      reactable(dt_tickersAgg(),
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
         write.csv(dt_tickersAgg(), file)
      }
   )   
   
   
   output$texto = renderPrint({
      
      c(input$exp_select_ticker, strsplit(input$exp_insert_ticker, ";")[[1]])
      
   })
   
   
   ## END --------------
  
}
