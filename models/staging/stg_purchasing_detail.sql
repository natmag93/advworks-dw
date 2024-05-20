select distinct
od.purchaseorderid as purchase_id,
DATE(od.duedate) as due_date,
od.productid as product_id,
od.orderqty:: numeric(8,2),
od.receivedqty as qty_received,
ROUND(od.unitprice,2) as unit_price,
ROUND(nullif(od.orderqty*od.unitprice,(0.00)),2) as product_total
from {{ source("purchasing", "purchaseorderdetail") }} od
order by purchase_id