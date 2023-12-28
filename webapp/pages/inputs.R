
# Inputs ================================================================================

## 01_explore --------------------------------------------------------


### Init --------------------------------------------------------

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

### Upload Name-Ticker List
in_exp_upload_ticker_list =
   fileInput(
      inputId = "exp_upload_tickerlist",
      label = span('Upload companies list', style = 'color: #75A5B7 ; font-weight: bold;'), 
      multiple = FALSE,
      accept = c(".csv", ".tsv"),
      width = '100%'
   )



### Select Tickers --------------------------------------------------------

### Tickers Search from list
in_exp_select_ticker =
   selectInput(
      inputId = 'exp_select_ticker',
      label = span('From list symbols', style = 'color: #75A5B7; font-weight: bold;'),
      # choices = engm_equities_list$name_company,
      choices = NULL, 
      multiple = TRUE,
      width = '100%'
   )

### Tickers Search from list
in_exp_insert_ticker =
   textInput(
      inputId = 'exp_insert_ticker',
      label = span('Manual symbols', style = 'color: #75A5B7; font-weight: bold;'),
      placeholder = 'Insert $TICKER',
      width = '100%'
   )

## Tickers Date Range Selector
in_exp_dateRange =
   dateRangeInput(
      inputId = 'exp_dateRange',
      label = span('Date range', style = 'color: #75A5B7; font-weight: bold;'),
      start = '2018-01-01', end = Sys.Date(),
      width = '100%'
   )


### Plots options --------------------------------------------------------

#### Price --------------------------------------------------------

## Tickers Type of Aggregation
in_exp_dataAgg =
   radioButtons(
      inputId = "exp_dataAgg",
      label = span('Data aggregation', style = 'color: #75A5B7; font-weight: bold;'),
      choices = c('Price' = 'price', 'Week' = 'last_week', 'Month' = 'last_month', 'Quarter' = 'last_quarter', 'YTD  ' = 'ytd', '52 Weeks' = 'last_year'),
      selected = 'price',
      width = '100%'
   )

## Tickers Type of Aggregation
in_exp_dataAgg =
   radioButtons(
      inputId = "exp_dataAgg",
      label = span('Data aggregation', style = 'color: #75A5B7; font-weight: bold;'),
      choices = c('Price' = 'price', 'Week' = 'last_week', 'Month' = 'last_month', 'Quarter' = 'last_quarter', 'YTD  ' = 'ytd', '52 Weeks' = 'last_year'),
      selected = 'price',
      width = '100%'
   )

### Choose Calculation
in_exp_dataCalc =
   radioButtons(
      inputId = "exp_dataCalc",
      label = span('Calculation', style = 'color: #75A5B7; font-weight: bold;'),
      choices = c('Price' = 'calc_price', 'Returns' = 'calc_ret', 'Cum. Return' = 'calc_cum_ret'),
      selected = 'calc_price',
      width = '100%'
   )

#### Financials --------------------------------------------------------




### Table options --------------------------------------------------------

#### Price --------------------------------------------------------

#### Financials --------------------------------------------------------

in_exp_select_tickerTable =
   selectInput(
      inputId = 'exp_select_tickerTable',
      label = span('From list symbols', style = 'color: #75A5B7; font-weight: bold;'),
      # choices = engm_equities_list$name_company,
      choices = NULL, 
      multiple = TRUE,
      width = '100%'
   )

in_exp_finTime =
   radioGroupButtons(
      inputId = "exp_finTime",
      label = span('Report time', style = 'color: #75A5B7; font-weight: bold;'),
      choices = c('Yearly' = 'table_yearly', 'Quarterly' = 'table_quarterly'),
      selected = 'table_yearly',
      justified = TRUE,
      size = 'sm',
      width = '100%'
   )

in_exp_finType =
   radioButtons(
      inputId = "exp_finType",
      label = span('Statement type', style = 'color: #75A5B7; font-weight: bold;'),
      choices = c('Balance sheet' = 'table_type_bs', 'Income statement' = 'table_type_in', 'Cashflow statement' = 'table_type_cs'),
      selected = 'table_type_bs',
      width = '100%'
   )



### Execution buttons --------------------------------------------------------

### Fetch Tickers button
in_exp_button_fetchTickers = 
   actionButton(
      inputId = 'exp_button_fetchTickers',
      label = 'Fetch price',
      class = 'btn-success',
      icon = shiny::icon("chart-line"),
      width = '100%'
   )

### Download Tickers Price data
in_exp_button_downloadPrice = 
   downloadButton(
      outputId = 'exp_button_downloadPrice',
      label = 'Download',
      class = 'btn-danger',
      icon = shiny::icon("floppy-disk"),
      style = 'width: 100%;'
   )


in_exp_button_downloadFinancials = 
   downloadButton(
      outputId = 'exp_button_downloadFinancials',
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

### Fetch Tickers button
in_exp_button_fetchFinancials = 
   actionButton(
      inputId = 'exp_button_fetchFinancials',
      label = 'Fetch Financials',
      class = 'btn-info',
      icon = shiny::icon("file-invoice-dollar"),
      width = '100%'
   )






## 00_Backend --------------------------------------------------------

### Add company --------------------------------------------------------

in_bck_add_company = 
   actionButton(
      inputId = "bck_add_company",
      label = "Add company record",
      class = 'btn-success',
      icon = shiny::icon("plus"),
      width = '100%')

in_bck_add_company_modal = 
   actionButton(
      inputId = "bck_addCompanyBtn",
      label = "Add company",
      class = 'btn-success',
      icon = shiny::icon("plus"),
      width = '100%')

bck_companySymbolInput =
   textInput(
      inputId = "companySymbolInput", 
      label = span('Company ID', style = 'color: #4C6279; font-weight: bold;'),
      width = '100%')

bck_companyNameInput =
   textInput(
      inputId = "companyNameInput", 
      label = span('Company Name', style = 'color: #4C6279; font-weight: bold;'),
      width = '100%')

bck_industryInput =
   selectInput(
      inputId = "industryInput", 
      label = span('Industry', style = 'color: #4C6279; font-weight: bold;'), choices = c("Technology", "Finance", "Other"),
      width = '100%')

bck_marketInput = 
   selectInput(
      inputId = "marketInput", 
      label = span('Market', style = 'color: #4C6279; font-weight: bold;'), choices = c("EURONEXT.G.MI", "NASDAQ", "NYSE"),
      width = '100%')

bck_headquartersInput = 
   textInput(
      inputId = "headquartersInput", 
      label = span('Headquarters', style = 'color: #4C6279; font-weight: bold;'),
      width = '100%')

bck_foundedYearInput = 
   numericInput("foundedYearInput", 
                label = span('Founded Year', style = 'color: #4C6279; font-weight: bold;'), value = 2000, min = 1800, max = 2023,
                width = '100%')

bck_statusInput = 
   selectInput(
      inputId = "statusInput", 
      label = span('Status', style = 'color: #4C6279; font-weight: bold;'), choices = c("Active", "Inactive", "Pending"),
      width = '100%')


## Edit / Remove company --------------------------------------------------------

### Refesh list
in_bck_refresh_backend =
   actionButton(
      inputId = "bck_refresh_backend",
      label = "Refesh",
      class = 'btn-secondary',
      icon = shiny::icon("reload"),
      width = '100%')

### Select list origin
in_bck_select_list =
   selectInput(
      inputId = "bck_select_list",
      label = span('List', style = 'color: #75A5B7; font-weight: bold;'), 
      choices = NULL,
      width = '100%'
   )


in_bck_edit_company =
   actionButton(
      inputId = "bck_edit_company",
      label = "Edit company data",
      class = 'btn-info',
      icon = shiny::icon("pen"),
      width = '100%')


in_bck_delete_company =
   actionButton(
      inputId = "bck_delete_company",
      label = "Delete company",
      class = 'btn-danger',
      icon = shiny::icon("xmark"),
      width = '100%')

