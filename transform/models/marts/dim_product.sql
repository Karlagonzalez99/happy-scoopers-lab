{{ config(materialized='table') }}

with p as (
    select * from {{ ref('stg_oltp_products') }}
),
sub as (
    select * from {{ ref('stg_oltp_product_subcategories') }}
),
cat as (
    select * from {{ ref('stg_oltp_product_categories') }}
),
dep as (
    select * from {{ ref('stg_oltp_product_departments') }}
),
uom as (
    select * from {{ ref('stg_oltp_units_of_measure') }}
),
joined as (
    select
        p.product_id,
        p.product_name,
        p.product_code,
        p.product_description,
        p.unit_price,
        p.is_discontinued,
        coalesce(uom.unit_of_measure_code, 'N/A') as unit_of_measure_code,
        coalesce(uom.unit_of_measure_name, 'N/A') as unit_of_measure_name,
        coalesce(sub.subcategory_name, 'N/A') as subcategory_name,
        coalesce(cat.category_name, 'N/A') as category_name,
        coalesce(dep.department_name, 'N/A') as department_name
    from p
    left join sub on p.subcategory_id = sub.product_subcategory_id
    left join cat on sub.product_category_id = cat.category_id
    left join dep on cat.department_id = dep.department_id
    left join uom on p.unit_of_measure_id = uom.unit_of_measure_id
),
final as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
        *
    from joined
),
unknown_member as (
    select
        '-1' as product_key,
        -1 as product_id,
        'Desconocido' as product_name,
        'N/A' as product_code,
        'N/A' as product_description,
        null::numeric as unit_price,
        'N/A' as is_discontinued,
        'N/A' as unit_of_measure_code,
        'N/A' as unit_of_measure_name,
        'N/A' as subcategory_name,
        'N/A' as category_name,
        'N/A' as department_name
)
select * from final
union all
select * from unknown_member