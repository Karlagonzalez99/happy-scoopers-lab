with source as ( select * from {{ source('raw', 'products') }} )
select
    product_id, product_name, product_code, product_description,
    subcategory_id, unit_of_measure_id, unit_price,
    case when discontinued then 'Sí' else 'No' end as is_discontinued
from source