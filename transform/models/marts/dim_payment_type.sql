{{ config(materialized='table') }}

with payment_types as (
    select * from {{ ref('stg_oltp_payment_types') }}
),

calculated as (
    select
        {{ dbt_utils.generate_surrogate_key(['payment_type_id']) }} as payment_type_key,
        payment_type_id,
        payment_type_name
    from payment_types
),

unknown_member as (
    select
        '-1'::text as payment_type_key,
        -1 as payment_type_id,
        'Desconocido' as payment_type_name
)

select * from unknown_member
union all
select * from calculated