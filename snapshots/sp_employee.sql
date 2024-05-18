{% snapshot sp_employee %}

{{
    config(
        target_schema='snapshots',
        unique_key='employee_id',
        strategy='check',
        check_cols=['job_title',  'organization_node', 'first_name', 'phone_number', 'email']
    )
}}

select
    *
from {{ ref('stg_employee') }}

{% endsnapshot %}