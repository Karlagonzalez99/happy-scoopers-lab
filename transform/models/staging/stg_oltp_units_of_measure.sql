with source as (
    select * from {{ source('raw', 'units_of_measure') }}
)
select 
    unit_of_measure_id, 
    unit_measure_code as unit_of_measure_code, 
    name as unit_of_measure_name
from source