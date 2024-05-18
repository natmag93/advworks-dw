select
    e.businessentityid as employee_id,
	p.firstname as first_name,
	coalesce (nullif(p.middlename,''), '') as middle_name,
    p.lastname as last_name,
    e.birthdate as birth_date,
    e.gender,
	ph.phonenumber as phone_number,
	ea.emailaddress as email,
	e.jobtitle as job_title,
    e.organizationnode as organization_node
from {{ source("humanresources", "employee") }} e
    left join {{ source("person", "person") }} p on e.businessentityid = p.businessentityid
    left join {{ source("person", "personphone") }} ph on ph.businessentityid = p.businessentityid
    left join {{ source("person", "emailaddress") }} ea on ea.businessentityid = p.businessentityid
