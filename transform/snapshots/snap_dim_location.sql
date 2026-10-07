{% snapshot snap_dim_location %}

{{
    config(
      target_schema='snapshots', 
      unique_key='address_id', 
      strategy='check', 
      check_cols='all' 
    )
}}

SELECT * FROM {{ ref('dim_location') }}

{% endsnapshot %}