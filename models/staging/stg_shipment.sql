select s.shipmethodid as shipment_ID,
            s.name as name,
        s.shipbase as min_ship_charge,
        s.shiprate as pound_ship_charge,
        DATE(s.modifieddate) as modified_date
from {{ source("purchasing", "shipmethod") }} s