{% snapshot sp_product %}

{{
    config(
        target_schema='snapshots',
        unique_key='product_id',
        strategy='check',
        check_cols=['category',  'subcategory', 'color', 'size', 'weight']
    )
}}

select
    *
from {{ ref('stg_product') }}

{% endsnapshot %}


