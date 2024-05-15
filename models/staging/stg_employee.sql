select
    e.businessentityid as employee_id,
    e.jobtitle as job_title,
    e.birthdate as birth_date,
    e.gender,
    e.organizationnode as organization_node,
    e.rowguid as employee_row_guid,
    e.modifieddate as employee_last_update,
    p.firstname as first_name,
    p.middlename as middle_name,
    p.lastname as last_name,
    p.rowguid as person_row_guid,
    p.modifieddate as person_last_update,
    GREATEST(e.modifieddate, p.modifieddate) as last_update
from {{ source("humanresources", "employee") }} e
    left join {{ source("person", "person") }} p on e.businessentityid = p.businessentityid
