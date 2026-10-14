{{ config(materialized='table') }}

with customers as (
    select * from {{ ref('stg_oltp_customers') }}
),

locations as (
    select * from {{ ref('dim_location') }}
),

calculated as (
    select
        {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }} as customer_key,
        c.customer_id,
        c.first_name,
        c.last_name,
        c.full_name,
        c.title,
        c.phone_number,
        c.email,
        -- Role-playing para la dirección de entrega (delivery)
        COALESCE(del_loc.location_key, '-1'::text) as delivery_location_key,
        -- Role-playing para la dirección de facturación (billing)
        COALESCE(bill_loc.location_key, '-1'::text) as billing_location_key
    from customers c
    left join locations del_loc on c.delivery_address_id = del_loc.address_id
    left join locations bill_loc on c.billing_address_id = bill_loc.address_id
),

unknown_member as (
    select
        '-1'::text as customer_key,
        -1 as customer_id,
        'Desconocido' as first_name,
        'Desconocido' as last_name,
        'Desconocido' as full_name,
        'N/A' as title,
        'N/A' as phone_number,
        'N/A' as email,
        '-1'::text as delivery_location_key,
        '-1'::text as billing_location_key
)

select * from unknown_member
union all
select * from calculated