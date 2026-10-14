with source as (
    select * from {{ source('raw', 'payment_types') }}
),
renamed as (
    select
        payment_type_id,
        payment_type_name
    from source
)
select * from renamed