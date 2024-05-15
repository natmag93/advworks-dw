{% snapshot sp_employee %}

{{
    config(
        target_schema='snapshots',
        unique_key='employee_id',
        strategy='check',
        check_cols=['job_title',  'organization_node', 'employee_row_guid', 'employee_last_update', 'last_name', 'person_row_guid', 'person_last_update']
    )
}}

select
    *
from {{ ref('stg_employee') }}

{% endsnapshot %}