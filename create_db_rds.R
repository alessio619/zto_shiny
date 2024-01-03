
# DB Management ================================================================================


# Load the RSQLite package
library(data.table)
source(file.path('webapp', 'financial.R'))

exp_select_AddCompany = c('YPF')


# 1. Create database --------------------------------------------------------------------------
# 
# ### My companies
# dt_database_mc = data.table(
#    company_id = NA_character_,
#    company_name = NA_character_,
#    industry =  NA_character_,
#    market =  NA_character_,
#    headquarters =  NA_character_,
#    founded_year =  NA_integer_,
#    status =  NA_character_,
#    historical_data =  NA_integer_,
#    historical_data_update =  NA_character_,
#    financial_data =  NA_integer_,
#    financial_data_update =  NA_character_,
#    ratios_data =  NA_integer_,
#    ratios_data_update =  NA_character_
# )
# 
# setkey(dt_database_mc, 'company_id')
# saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
# 
# 
# ### Historical price
# dt_database_hp = data.table(
#    company_id = NA_character_,
#    index = NA_character_,
#    closing =  NA_complex_,
#    volume =  NA_complex_
# )
# 
# setkeyv(dt_database_hp, cols = c('company_id', 'index'))
# saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
# 
# 
# ### Financial data
# dt_database_fd = data.table(
#    company_id = NA_character_,
#    index = NA_character_,
#    stmt  = NA_character_,
#    type  = NA_character_,
#    voice  = NA_character_,
#    time  = NA_character_,
#    value  = NA_character_
# )
# 
# setkeyv(dt_database_fd, cols = c('company_id', 'index', 'voice', 'time'))
# saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))
# 




# 2. CRUD  --------------------------------------------------------------------------

## A. Write into the tables --------------------------------------


### New company----------------------------------------

new_data_mc = data.table(
   company_id = exp_select_AddCompany,
   company_name = 'YPF',
   industry =  'ENERGY',
   market =  'NYSE',
   headquarters =  'Argentina',
   founded_year =  2000,
   status =  'Inactive',
   historical_data =  0,
   historical_data_update =  NA_character_,
   financial_data =  0,
   financial_data_update =  NA_character_,
   ratios_data =  0,
   ratios_data_update =  NA_character_
)


#### Add the data to the DB
dt_database_mc = rbind(dt_database_mc, new_data_mc)
dt_database_mc = dt_database_mc[!is.na(dt_database_mc$company_id)]

#### Export
saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))



### New historical data----------------------------------------

dt_fetchedTickers = fetch_tickers(TICKERS = exp_select_AddCompany,
                                  INIT_DATE = '2021-01-01',
                                  END_DATE = Sys.Date())


#### Prepare data
new_records_hp = dt_fetchedTickers[ticker %in% exp_select_AddCompany]
new_records_hp = new_records_hp[, .(company_id = ticker, index = as.character(index), closing = adjusted, volume = volume)]

#### Add the data to the DB
dt_database_hp = rbind(dt_database_hp, new_records_hp)
dt_database_hp = dt_database_hp[!is.na(dt_database_hp$company_id)]

#### Update date on my_companies
dt_database_mc[company_id %in% exp_select_AddCompany]$historical_data_update = as.character(Sys.Date())
dt_database_mc[company_id %in% exp_select_AddCompany]$historical_data = 1

#### Export
saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))



### New Financial data----------------------------------------

list_ticker = get_statements(exp_select_AddCompany)
list_ticker[[exp_select_AddCompany]]

#### Prepare data
new_records_fd = record_statements(list_ticker, exp_select_AddCompany)
new_records_fd[, index := as.character(Sys.Date())]

#### Add the data to the DB
dt_database_fd = rbind(dt_database_fd, new_records_fd)
dt_database_fd = dt_database_fd[!is.na(dt_database_fd$company_id)]

#### Update date on my_companies
dt_database_mc[company_id %in% exp_select_AddCompany]$financial_data_update = as.character(Sys.Date())
dt_database_mc[company_id %in% exp_select_AddCompany]$financial_data = 1

#### Export
saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))
saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))





## B. Edit --------------------------------------------------------------------------

dt_database_mc = readRDS(file = file.path('data', 'zto_database_my_companies.rds'))
dt_database_hp = readRDS(file = file.path('data', 'zto_database_historical_price.rds'))
dt_database_fd = readRDS(file = file.path('data', 'zto_database_financial_data.rds'))



### Delete----------------------------------------

# exp_select_AddCompany = c('YPF')
# 
# #### Remove records
# dt_database_mc = dt_database_mc[!company_id %in% exp_select_AddCompany] 
# dt_database_hp = dt_database_hp[!company_id %in% exp_select_AddCompany] 
# dt_database_fd = dt_database_fd[!company_id %in% exp_select_AddCompany] 
# 
# #### Export
# saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
# saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
# saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))




### Update ----------------------------------------

exp_select_AddCompany = c('YPF')


### My Company
dt_database_mc[company_id %in% exp_select_AddCompany]$company_name = 'Yacimientos Petroliferos Fiscales'

#### Export
saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))



### Historical data 

dt_fetchedTickers = fetch_tickers(TICKERS = exp_select_AddCompany,
                                  INIT_DATE = '2021-01-01',
                                  END_DATE = Sys.Date())


#### Prepare data
new_records_hp = dt_fetchedTickers[ticker %in% exp_select_AddCompany]
new_records_hp = new_records_hp[, .(company_id = ticker, index = as.character(index), closing = adjusted, volume = volume)]

#### Remove olda data from DB
dt_database_hp = dt_database_hp[!company_id %in% exp_select_AddCompany]

#### Add the data to the DB
dt_database_hp = rbind(dt_database_hp, new_records_hp)
dt_database_hp = dt_database_hp[!is.na(dt_database_hp$company_id)]

#### Update date on my_companies
dt_database_mc[company_id %in% exp_select_AddCompany]$historical_data_update = as.character(Sys.Date())
dt_database_mc[company_id %in% exp_select_AddCompany]$historical_data = 1

#### Export
saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))



### Financial data 
#### AS HISTORICAL DATA