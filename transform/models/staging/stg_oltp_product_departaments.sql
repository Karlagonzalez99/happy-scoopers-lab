with source as ( select * from {{ source('raw', 'product_departments') }} )
select department_id, name as department_name, description as department_description
from source