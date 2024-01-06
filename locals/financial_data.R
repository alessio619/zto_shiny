

# financia_data ================================================================================

## Load setup --------------------------------------------------------

library(data.table)
source(file.path('webapp', 'financial.R'))

exp_select_AddCompany = c('ACQ.MI', 'AAPL')


## Fetch data --------------------------------------------------------

list_ticker = get_statements(exp_select_AddCompany)
list_ticker[[exp_select_AddCompany]]

#### Prepare data
new_records_fd = record_statements(list_ticker, exp_select_AddCompany)
new_records_fd[, index := as.character(Sys.Date())]