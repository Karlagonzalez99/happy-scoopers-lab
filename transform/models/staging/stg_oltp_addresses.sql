with source as ( select * from {{ source('raw', 'addresses') }} )
select address_id, address_line1, address_line2, city_id, postal_code
from source