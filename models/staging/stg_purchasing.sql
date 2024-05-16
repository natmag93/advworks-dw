select distinct
oh.purchaseorderid as purchase_id,
v.businessentityid as vendor_id,
e.businessentityid as employee_id,
p.productid as product_id,
sh.shipmethodid as shipment_id,
DATE(oh.orderdate) as order_date,
CASE
	WHEN oh.status =1 THEN 'Pending'
	WHEN oh.status =2 THEN 'Approved'
	WHEN oh.status =3 THEN 'Rejected'
	ELSE 'Complete'
END as ship_status,
DATE(oh.shipdate) as shipment_date,
DATE(od.duedate) as due_date,
od.orderqty,
od.receivedqty as qty_received,
od.unitprice as unit_price,
nullif(od.orderqty*od.unitprice,(0.00)) as product_total,
oh.subtotal,
oh.taxamt as tax_amount,
oh.freight,
nullif((oh.subtotal+oh.taxamt+oh.freight),(0)) as total_due
from {{ source("purchasing", "purchaseorderheader") }} oh
    left join {{ source("purchasing", "vendor") }} v on v.businessentityid=oh.vendorid
    left join {{ source("humanresources", "employee") }} e on oh.employeeid= e.businessentityid
    left join {{ source("purchasing", "purchaseorderdetail") }} od on od.purchaseorderid=oh.purchaseorderid
    left join {{ source("purchasing", "productvendor") }} p on p.productid= od.productid
    left join {{ source("purchasing", "shipmethod") }} sh on sh.shipmethodid=oh.shipmethodid
order by purchase_id
