
# Inputs ================================================================================

## 01_pricing --------------------------------------------------------

### Upload Name-Ticker List
in_exp_upload_ticker_list =
   fileInput(
      inputId = "upload",
      label = span('Upload companies list', style = 'color: ; font-weight: bold;'), 
      multiple = FALSE,
      accept = c(".csv", ".tsv"),
      width = '100%'
   )

### Tickers Search from list
in_exp_insert_ticker =
   textInput(
      inputId = 'exp_insert_ticker',
      label = NULL,
      placeholder = 'Insert $TICKER'
   )

### Tickers Search from list
in_exp_select_ticker =
   selectizeInput(
      inputId = 'exp_select_ticker',
      label = NULL,
      choices = engm_equities_list$name_company,
      multiple = TRUE
   )

## Tickers Date Range Selector
in_exp_dateRange =
   dateRangeInput(
      inputId = 'exp_dateRange',
      label = NULL,
      start = '2018-01-01', end = Sys.Date(),
      width = '100%'
   )

## Tickers Type of Aggregation
in_exp_dataAgg =
   radioGroupButtons(
      inputId = "exp_dataAgg",
      label = NULL,
      choices = c('Price' = 'price', 'Week' = 'last_week', 'Month' = 'last_month', 'Quarter' = 'last_quarter', 'YTD  ' = 'ytd', '52 Weeks' = 'last_year'),
      selected = 'price',
      justified = TRUE,
      width = '100%',
      size = 'sm'
   )

in_exp_dataCalc =
   radioGroupButtons(
      inputId = "exp_dataCalc",
      label = NULL,
      choices = c('Price' = 'calc_price', 'Returns' = 'calc_ret', 'Cum. Return' = 'calc_cum_ret'),
      selected = 'calc_price',
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

###  Select Value boxes
in_exp_select_ticker_boxes =
   selectizeInput(
      inputId = 'exp_select_ticker_boxes',
      label = NULL,
      choices = NULL,
      multiple = FALSE
   )

in_exp_button_download = 
   downloadButton(
      outputId = 'exp_button_download',
      label = 'Download',
      class = 'btn-danger',
      icon = shiny::icon("floppy-disk"),
      style = 'width: 100%;'
   )