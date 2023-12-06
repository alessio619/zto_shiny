
# Inputs ================================================================================

## 01_explorer --------------------------------------------------------

### Tickers Search from list
in_exp_select_ticker =
   selectInput(
      inputId = 'exp_select_ticker',
      label = NULL,
      choices = engm_equities_list$company_name,
      multiple = TRUE
   )

### Fetch Tickers button
in_exp_button_fetchTickers = 
   actionButton(
      inputId = 'exp_button_fetchTickers',
      label = 'Fetch',
      class = 'btn-primary',
      icon = shiny::icon("download"),
      width = '100%'
   )