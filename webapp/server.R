
# Inputs ================================================================================

server_app = function(input, output) {

   ## 01_explorer --------------------------------------------------------
   
   ticker_list = eventReactive(input$exp_button_fetchTickers, {
      
      return(engm_equities_list[company_name %in% input$exp_select_ticker]$ticker_code)
      
   })
   
  output$exp_plot_tickersSeries = renderHighchart({
     
     req(ticker_list())
     
        dt_sym_wk = fetch_tickers(TICKERS = ticker_list())
     
     hchart(dt_sym_wk,
            "line",
            hcaes(x = index, y = price, group = ticker))
    
  })
  
}
