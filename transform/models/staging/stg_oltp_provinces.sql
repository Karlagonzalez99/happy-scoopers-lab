with source as ( select * from {{ source('raw', 'provinces') }} )
select province_id, province_code, province_name, country_id, population
from source