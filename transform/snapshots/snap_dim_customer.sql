{% snapshot snap_dim_customer %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['full_name', 'phone_number', 'email', 'delivery_location_key', 'billing_location_key'],
    )
}}

select * from {{ ref('dim_customer') }}

{% endsnapshot %}