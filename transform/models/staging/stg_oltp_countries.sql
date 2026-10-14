with source as ( select * from {{ source('raw', 'countries') }} )
select country_id, country_name, formal_name, country_code, population, continent, region, subregion
from source