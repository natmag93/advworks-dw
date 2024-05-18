select distinct
oh.purchaseorderid as purchase_id,
DATE(oh.orderdate) as order_date,
CASE
	WHEN oh.status =1 THEN 'Pending'
	WHEN oh.status =2 THEN 'Approved'
	WHEN oh.status =3 THEN 'Rejected'
	ELSE 'Complete'
END as ship_status,
DATE(oh.shipdate) as shipment_date,
DATE(od.duedate) as due_date,
od.orderqty:: numeric(8,2),
od.receivedqty as qty_received,
ROUND(od.unitprice,2) as unit_price,
nullif(od.orderqty*od.unitprice,(0.00)) as product_total,
ROUND(oh.subtotal,2) as order_subtotal,
ROUND(oh.taxamt,2) as tax_amount,
ROUND(oh.freight,2) as freight,
ROUND(nullif((oh.subtotal+oh.taxamt+oh.freight),(0)),2) as order_total
from {{ source("purchasing", "purchaseorderheader") }} oh
    left join {{ source("purchasing", "purchaseorderdetail") }} od on od.purchaseorderid=oh.purchaseorderid
order by purchase_id
