

# Queries ================================================================================

## Anagrafic --------------------------------------

insert_newcompany_query = 
   "INSERT INTO my_companies (company_id, company_name, industry, market, headquarters, founded_year, status, historical_data, historical_data_update, financial_data, financial_data_update, ratios_data, ratios_data_update) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

update_newcompany_query = 
   "UPDATE my_companies SET company_name = ?, industry = ?, market = ?, headquarters = ?, founded_year = ?, status = ? WHERE company_id = ?"

update_availabledata_query = 
   "UPDATE my_companies
                 SET historical_data = CASE
                   WHEN EXISTS (SELECT 1 FROM historical_price WHERE historical_price.company_id = my_companies.company_id)
                   THEN 1
                   ELSE 0
                 END,
    financial_data = CASE
                       WHEN EXISTS (SELECT 1 FROM financial_statements WHERE financial_statements.company_id = my_companies.company_id)
                       THEN 1
                       ELSE 0
                     END;"



## New Data --------------------------------------

insert_newhistoricaldata_query = 
   'INSERT INTO historical_price (company_id, date, closing_price, volume) VALUES (?, ?, ?, ?)'

insert_newfinancialdata_query = 
   'INSERT INTO financial_statements (id, company_id, date, stmt, type, voice, time, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?)'

update_historical_data_date_query = paste0("UPDATE my_companies SET historical_data_update = ? WHERE company_id = ?")
update_financial_data_date_query = paste0("UPDATE my_companies SET financial_data_update = ? WHERE company_id = ?")


