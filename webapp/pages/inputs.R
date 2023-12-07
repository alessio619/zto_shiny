
# Inputs ================================================================================

## 01_explorer --------------------------------------------------------

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

## Tickers Type of Data granularity
in_exp_dataType =
   shinyWidgets::radioGroupButtons(
      inputId = 'exp_dataType',
      label = NULL,
      choices = c('Daily  ' = 'daily', 'Weekly' = 'weekly', 'Monthly' = 'monthly'),
      selected = 'weekly',
      width = '100%',
      justified = TRUE
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
   actionButton(
      inputId = 'exp_button_download',
      label = 'Download',
      class = 'btn-danger',
      icon = shiny::icon("floppy-disk"),
      width = '100%'
   )