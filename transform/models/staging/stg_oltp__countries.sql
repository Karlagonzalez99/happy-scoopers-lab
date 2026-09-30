with source as ( select * from {{ source('raw', 'countries') }} )
select country_id, country_name, formal_name, country_code, continent, region, subregion
from source