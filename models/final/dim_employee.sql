with first_version as (
    select
        dbt_scd_id,
        employee_id,
        job_title,
        birth_date,
        gender,
        organization_node,
        employee_row_guid,
        employee_last_update,
        title,
        first_name,
        middle_name,
        last_name,
        person_row_guid,
        person_last_update,
        last_update,
        dbt_valid_from,
        dbt_valid_to,
        dbt_updated_at,
        row_number() over(partition by employee_id order by dbt_valid_from) as row_nr
    from {{ ref('sp_employee') }}
)
select
    dbt_scd_id as sk_employee,
    employee_id,
    job_title,
    birth_date,
    gender,
    organization_node,
    employee_row_guid,
    employee_last_update,
    first_name,
    middle_name,
    last_name,
    person_row_guid,
    person_last_update,   
    case
        when row_nr = 1 then '1970-01-01'
        else dbt_valid_from
    end as valid_from,
    coalesce(dbt_valid_to, '2200-01-01') as valid_to,
    dbt_updated_at as last_updated_at
from first_version
