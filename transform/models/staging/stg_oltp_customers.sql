with source as (
    select * from {{ source('raw', 'customers') }}
),
renamed as (
    select
        customer_id,
        first_name,
        last_name,
        COALESCE(full_name, first_name || ' ' || last_name) as full_name,
        title,
        COALESCE(phone_number, 'N/A') as phone_number,
        COALESCE(email, 'N/A') as email,
        delivery_address_id,
        billing_address_id,
        modified_date
    from source
)
select * from renamed