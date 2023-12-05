server <- function(input, output) {

  output$text1 = renderPrint({
    
    dta = input$selectize1
    
    print(euronext_data[company_name  %in% dta]$company_ticker)
    
  })
  
}
