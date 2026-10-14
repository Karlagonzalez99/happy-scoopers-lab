with source as ( select * from {{ source('raw', 'cities') }} )
select city_id, city_name, province_id, population
from source