select v.businessentityid as vendor_ID,
v.name as name,
v.accountnumber as account_number,
pv.standardprice as standard_price,
a.city,
sp.name as state_province,
cr.name as country
from {{ source("purchasing", "vendor") }} v
    left join {{ source("purchasing", "productvendor") }} pv on v.businessentityid = pv.businessentityid
    left join {{ source("person", "businessentity") }} be on be.businessentityid =v.businessentityid
    left join {{ source("person", "businessentityaddress") }} bea on bea.businessentityid = be.businessentityid
    left join {{ source("person", "address") }} a on a.addressid=bea.addressid
    left join {{ source("person", "stateprovince") }} sp on sp.stateprovinceid=a.stateprovinceid
    left join {{ source("person", "countryregion") }} cr on cr.countryregioncode=sp.countryregioncode