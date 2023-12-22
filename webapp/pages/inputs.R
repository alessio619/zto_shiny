
# Inputs ================================================================================

## 01_pricing --------------------------------------------------------

### Upload Name-Ticker List
in_exp_upload_ticker_list =
   fileInput(
      inputId = "exp_upload_tickerlist",
      label = span('Upload companies list', style = 'color: #75A5B7 ; font-weight: bold;'), 
      multiple = FALSE,
      accept = c(".csv", ".tsv"),
      width = '100%'
   )

### Select list origin
in_exp_select_list =
   radioGroupButtons(
      inputId = "exp_select_list",
      label = span('List origin', style = 'color: #75A5B7; font-weight: bold;'), 
      choices = c('Base' = 'list_base', 'Upload' = 'list_upload', 'Both' = 'list_both'),
      selected = 'list_base',
      justified = TRUE,
      width = '100%',
      size = 'sm'
   )


### Tickers Search from list
in_exp_select_ticker =
   selectInput(
      inputId = 'exp_select_ticker',
      label = NULL,
      # choices = engm_equities_list$name_company,
      choices = NULL, 
      multiple = TRUE
   )

### Tickers Search from list
in_exp_insert_ticker =
   textInput(
      inputId = 'exp_insert_ticker',
      label = span('Manual symbols', style = 'color: #75A5B7; font-weight: bold;'),
      placeholder = 'Insert $TICKER'
   )

## Tickers Date Range Selector
in_exp_dateRange =
   dateRangeInput(
      inputId = 'exp_dateRange',
      label = span('Date range', style = 'color: #75A5B7; font-weight: bold;'),
      start = '2018-01-01', end = Sys.Date(),
      width = '100%'
   )

## Tickers Type of Aggregation
in_exp_dataAgg =
   radioGroupButtons(
      inputId = "exp_dataAgg",
      label = span('Data aggregation', style = 'color: #75A5B7; font-weight: bold;'),
      choices = c('Price' = 'price', 'Week' = 'last_week', 'Month' = 'last_month', 'Quarter' = 'last_quarter', 'YTD  ' = 'ytd', '52 Weeks' = 'last_year'),
      selected = 'price',
      justified = TRUE,
      width = '100%',
      size = 'sm'
   )

### Fetch Tickers button
in_exp_button_fetchTickers = 
   actionButton(
      inputId = 'exp_button_fetchTickers',
      label = 'Fetch',
      class = 'btn-primary',
      icon = shiny::icon("chevron-down"),
      width = '100%'
   )

### Choose Calculation
in_exp_dataCalc =
   radioGroupButtons(
      inputId = "exp_dataCalc",
      label = span('Calculation', style = 'color: #75A5B7; font-weight: bold;'),
      choices = c('Price' = 'calc_price', 'Returns' = 'calc_ret', 'Cum. Return' = 'calc_cum_ret'),
      selected = 'calc_price',
      justified = TRUE,
      width = '100%',
      size = 'sm'
   )

### Download Tickers Price data
in_exp_button_download = 
   downloadButton(
      outputId = 'exp_button_download',
      label = 'Download',
      class = 'btn-danger',
      icon = shiny::icon("floppy-disk"),
      style = 'width: 100%;'
   )


### Select Time range
in_exp_select_ticker_boxes =
   selectInput(
      inputId = 'exp_select_ticker_boxes',
      label = NULL,
      choices = NULL,
      multiple = FALSE
   )



## 02_Financials --------------------------------------------------------

### Tickers Search from list
in_fin_select_ticker =
   selectInput(
      inputId = 'fin_select_ticker',
      label = NULL,
      # choices = engm_equities_list$name_company,
      choices = NULL, 
      multiple = TRUE
   )

### Tickers Search from list
in_fin_insert_ticker =
   textInput(
      inputId = 'fin_insert_ticker',
      label = span('Manual symbols', style = 'color: #75A5B7; font-weight: bold;'),
      placeholder = 'Insert $TICKER'
   )

### Fetch Tickers button
in_fin_button_fetchTickers = 
   actionButton(
      inputId = 'fin_button_fetchTickers',
      label = 'Fetch',
      class = 'btn-primary',
      icon = shiny::icon("chevron-down"),
      width = '100%'
   )

### Download Tickers Financials data
in_fin_button_download = 
   downloadButton(
      outputId = 'fin_button_download',
      label = 'Download',
      class = 'btn-danger',
      icon = shiny::icon("floppy-disk"),
      style = 'width: 100%;'
   )
