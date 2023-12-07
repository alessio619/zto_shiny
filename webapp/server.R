
# Inputs ================================================================================

server_app = function(input, output) {

   ## 01_explorer --------------------------------------------------------
   
   ### Find TICKERS from NAMES
   ticker_list = eventReactive(input$exp_button_fetchTickers, {
      
      return(engm_equities_list[name_company %in% input$exp_select_ticker]$code_ticker)
      
   })
   
   ### Fetch and Retrieve Tickers Data
   dt_fetchedTickers = eventReactive(input$exp_button_fetchTickers, {
      
      req(ticker_list())
      
      dt_sym_wk = fetch_tickers(TICKERS = ticker_list(),
                                INIT_DATE = input$exp_dateRange[1], END_DATE = input$exp_dateRange[2],
                                TYPE = input$exp_dataType)
      
      return(dt_sym_wk)
      
   })
   
   ### Plot Tickers Data
   output$exp_plot_tickersSeries = renderHighchart({
     
      req(dt_fetchedTickers())
     
      hchart(dt_fetchedTickers(),
             "line",
             hcaes(x = index, y = price, group = ticker)) |> 
         hc_xAxis(title = '', lineWidth = 0) |> 
         hc_yAxis(title = '')  |> 
         hc_legend(align = "left", verticalAlign = "top", layout = "horizontal")
    
  })
   
   
   ### Table Retrieved companies data
   output$exp_table_tickersSeries = renderReactable({
      
      req(dt_fetchedTickers())
      
      reactable(dt_fetchedTickers(),
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
         write.csv(dt_fetchedTickers(), file)
      }
   )   
   
   
   
   ## END --------------
  
}
