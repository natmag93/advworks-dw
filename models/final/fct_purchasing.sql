with dimension_ids as (
    select
        pur.purchase_id,
        v.vendor_id,
        e.employee_id,
        p.product_id,
        sh.shipment_id,
        pur.order_date,
        pur.ship_status,
        pur.shipment_date,
        pur.due_date,
        pur.orderqty,
        pur.qty_received,
        pur.unit_price,
        pur.product_total,
        pur.order_subtotal,
        pur.tax_amount,
        pur.freight,
        pur.order_total
    from {{ ref('stg_purchasing') }} pur
        left join {{ ref('stg_vendor') }} v on pur.vendor_id=v.vendor_id
        left join {{ ref('stg_employee') }} e on pur.employee_id= e.employee_id
        left join {{ ref('stg_shipment') }} sh on pur.shipment_id=sh.shipment_id
        left join {{ ref('stg_product') }} p on pur.product_id= p.product_id
),


surrogate_keys as (
    select
        purchase_id,
        dvend.sk_vendor as sk_vendor,
        demp.sk_employee as sk_employee,
        dprod.sk_product as sk_product,
        dship.sk_shipment as sk_shipment,
        order_dd.sk_date as sk_order_date,
        ship_dd_sk_date as sk_shipment_date,
        ship_status,
        due_date,
        orderqty,
        qty_received,
        unit_price,
        product_total,
        order_subtotal,
        tax_amount,
        freight,
        order_total
    from dimension_ids dids
        join {{ ref('dim_date') }} order_dd on dids.order_date = order_dd.date
        left join {{ ref('dim_date') }} ship_dd on dids.shipment_date = ship_dd.date
        join {{ ref('dim_vendor') }} dvend on dids.vendor_id = dvend.vendor_id
            and dids.order_date between dcust.valid_from and dcust.valid_to
        left join {{ ref('dim_product') }} dprod on dids.product_id = dprod.product_id
            and dids.order_date between dprod.valid_from and dprod.valid_to
        left join {{ ref('dim_employee') }} demp on dids.employee_id = demp.employee_id
            and dids.order_date between demp.valid_from and demp.valid_to
        left join {{ ref('dim_shipment') }} dship on dids.shipment_id = dship.shipment_id
            and dids.order_date between demp.valid_from and demp.valid_to
),



final as (
    select
        purchase_id,
        sk_vendor,
        sk_employee,
        sk_product,
        sk_shipment,
        sk_order_date,
        sk_shipment_date,
        ship_status,
        due_date,
        orderqty,
        qty_received,
        unit_price,
        product_total,
        order_subtotal,
        tax_amount,
        freight,
        order_total
    from surrogate_keys
)

select
    *
from final