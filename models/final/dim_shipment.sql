with first_version as (
    select
        dbt_scd_id,
        shipment_id,
        name,
        min_ship_charge,
        pound_ship_charge,
        modified_date,
        dbt_valid_from,
        dbt_valid_to,
        dbt_updated_at,
        row_number() over(partition by shipment_id order by dbt_valid_from) as row_nr
    from {{ ref('sp_shipment') }}
)
select
    dbt_scd_id as sk_shipment,
    shipment_id,
    name,
    min_ship_charge,
    pound_ship_charge,
    modified_date,  
    case
        when row_nr = 1 then '1970-01-01'
        else dbt_valid_from
    end as valid_from,
    coalesce(dbt_valid_to, '2200-01-01') as valid_to,
    dbt_updated_at as last_updated_at
from first_version
