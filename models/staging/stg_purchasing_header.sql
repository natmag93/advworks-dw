select distinct
oh.purchaseorderid as purchase_id,
oh.vendorid as vendor_id,
oh.employeeid as employee_id,
oh.shipmethodid as shipment_id,
DATE(oh.orderdate) as order_date,
CASE
	WHEN oh.status =1 THEN 'Pending'
	WHEN oh.status =2 THEN 'Approved'
	WHEN oh.status =3 THEN 'Rejected'
	ELSE 'Complete'
END as ship_status,
DATE(oh.shipdate) as shipment_date,
ROUND(oh.subtotal,2) as order_subtotal,
ROUND(oh.taxamt,2) as tax_amount,
ROUND(oh.freight,2) as freight,
ROUND(nullif((oh.subtotal+oh.taxamt+oh.freight),(0)),2) as order_total
from {{ source("purchasing", "purchaseorderheader") }} oh
order by purchase_id
