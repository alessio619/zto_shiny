

# Queries ================================================================================

## Anagrafic --------------------------------------

insert_newcompany_query = 
   "INSERT INTO my_companies (company_id, company_name, industry, market, headquarters, founded_year, status, historical_data, findata_y_bs, findata_y_is, findata_y_cs, findata_q_is, findata_q_cs, ratios_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

update_newcompany_query = 
   "UPDATE my_companies SET company_name = ?, industry = ?, market = ?, headquarters = ?, founded_year = ?, status = ? WHERE company_id = ?"

update_availabledata_query = 
   "UPDATE my_companies
                 SET historical_data = CASE
                   WHEN EXISTS (SELECT 1 FROM historical_price WHERE historical_price.company_id = my_companies.company_id)
                   THEN 1
                   ELSE 0
                 END"



## New Data --------------------------------------

insert_newhistoricaldata_query = 
'INSERT INTO historical_price (company_id, date, closing_price, volume) VALUES (?, ?, ?, ?)'


