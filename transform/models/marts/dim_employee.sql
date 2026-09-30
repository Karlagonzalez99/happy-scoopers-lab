{{ config(materialized='table') }}

with e   as ( select * from {{ ref('stg_oltp_employees') }} ),
     mgr as ( select employee_id, first_name, last_name from {{ ref('stg_oltp_employees') }} ),
     adr as ( select * from {{ ref('stg_oltp_addresses') }} ),
     cit as ( select * from {{ ref('stg_oltp_cities') }} ),
     prv as ( select * from {{ ref('stg_oltp_provinces') }} ),
     cou as ( select * from {{ ref('stg_oltp_countries') }} ),

joined as (
    select
        e.employee_id, e.last_name, e.first_name, e.title,
        e.birth_date, e.gender, e.hire_date, e.job_title,
        coalesce(adr.address_line1, 'N/A') as address_line,
        coalesce(cit.city_name,      'N/A') as city,
        coalesce(cou.country_name,   'N/A') as country,
        e.manager_id,
        coalesce(mgr.first_name || ' ' || mgr.last_name, 'Sin jefe') as manager_name
    from e
    left join adr on e.address_id = adr.address_id
    left join cit on adr.city_id  = cit.city_id
    left join prv on cit.province_id = prv.province_id
    left join cou on prv.country_id = cou.country_id
    left join mgr on e.manager_id = mgr.employee_id    -- self-join: el jefe
),

final as (
    select {{ dbt_utils.generate_surrogate_key(['employee_id']) }} as employee_key, * from joined
),

-- Fila "desconocido"
unknown_member as (
    select '-1' as employee_key, -1 as employee_id, 'Desconocido' as last_name,
           'N/A' as first_name, 'N/A' as title, null::date as birth_date, 'N/A' as gender,
           null::date as hire_date, 'N/A' as job_title, 'N/A' as address_line, 'N/A' as city,
           'N/A' as country, null::int as manager_id, 'N/A' as manager_name
)

select * from final
union all
select * from unknown_member