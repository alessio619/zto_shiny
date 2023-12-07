
# Inputs ================================================================================

server_app = function(input, output) {

   ## 01_explorer --------------------------------------------------------
   
   ### Find TICKERS from NAMES
   ticker_list = eventReactive(input$exp_button_fetchTickers, {
      
      return(engm_equities_list[name_company %in% input$exp_select_ticker]$code_ticker)
      
   })
   
   ### Fetch and Retrieve Data
   dt_fetchedTickers = eventReactive(input$exp_button_fetchTickers, {
      
      req(ticker_list())
      
      dt_sym_wk = fetch_tickers(TICKERS = ticker_list(),
                                INIT_DATE = input$exp_dateRange[1], END_DATE = input$exp_dateRange[2],
                                TYPE = input$exp_dataType)
      
      return(dt_sym_wk)
      
   })
   
   ### Plot Time Series
   output$exp_plot_tickersSeries = renderHighchart({
     
      req(dt_fetchedTickers())
     
      hchart(dt_fetchedTickers(),
             "line",
             hcaes(x = index, y = price, group = ticker))
    
  })
   
   
   
   ## END --------------
  
}
