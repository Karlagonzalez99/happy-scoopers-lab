with source as ( select * from {{ source('raw', 'employees') }} )
select
    employee_id, last_name, first_name, trim(title) as title,
    birth_date::date as birth_date, trim(gender) as gender,
    hire_date::date as hire_date, job_title,
    address_id, manager_id
from source