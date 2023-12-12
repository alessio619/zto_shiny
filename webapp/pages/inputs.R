
# Inputs ================================================================================

## 01_pricing --------------------------------------------------------

### Tickers Search from list
in_exp_select_ticker =
   selectInput(
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
   radioButtons(
      inputId = 'exp_dataAgg',
      label = NULL,
      choices = c('Price' = 'ls_week', 'YTD  ' = 'ls_ytd', '52 Weeks' = 'ls_52', 'Quarter' = 'ls_quarter', 'Month' = 'ls_month'),
      selected = 'ls_week',
      width = '100%'
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

in_exp_button_download = 
   downloadButton(
      outputId = 'exp_button_download',
      label = 'Download',
      class = 'btn-danger',
      icon = shiny::icon("floppy-disk"),
      style = 'width: 100%;'
   )