{{ config(materialized='table') }}

with promotions as (
    select * from {{ ref('stg_oltp_promotions') }}
),

calculated as (
    select
        {{ dbt_utils.generate_surrogate_key(['promotion_id']) }} as promotion_key,
        promotion_id,
        deal_description,
        start_date,
        end_date,
        discount_amount,
        discount_percentage
    from promotions
),

unknown_member as (
    select
        '-1'::text as promotion_key,
        -1 as promotion_id,
        'Desconocido' as deal_description,
        null::timestamp as start_date,
        null::timestamp as end_date,
        0.00 as discount_amount,
        0.00 as discount_percentage
)

select * from unknown_member
union all
select * from calculated