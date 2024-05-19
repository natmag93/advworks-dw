with dimension_ids as (
    select
        purhd.purchase_id,
        v.vendor_id,
        e.employee_id,
        p.product_id,
        sh.shipment_id,
        purhd.order_date,
        purhd.ship_status,
        purhd.shipment_date,
        purdt.due_date,
        purdt.orderqty,
        purdt.qty_received,
        purdt.unit_price,
        purdt.product_total,
        purhd.order_subtotal,
        purhd.tax_amount,
        purhd.freight,
        purhd.order_total
    from {{ ref('stg_purchasing_header') }} purhd
        left join {{ ref('stg_vendor') }} v on purhd.vendor_id=v.vendor_id
        left join {{ ref('stg_employee') }} e on purhd.employee_id= e.employee_id
        left join {{ ref('stg_shipment') }} sh on purhd.shipment_id=sh.shipment_id
        left join {{ ref('stg_purchasing_detail') }} purdt on purhd.purchase_id= purdt.purchase_id
        left join {{ ref('stg_product') }} p on purdt.product_id= p.product_id
        
),


surrogate_keys as (
    select
        purchase_id,
        dvend.sk_vendor as sk_vendor,
        demp.sk_employee as sk_employee,
        dprod.sk_product as sk_product,
        dship.sk_shipment as sk_shipment,
        order_dd.sk_date as sk_order_date,
        ship_dd.sk_date as sk_shipment_date,
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
            and dids.order_date between dvend.valid_from and dvend.valid_to
        left join {{ ref('dim_product') }} dprod on dids.product_id = dprod.product_id
            and dids.order_date between dprod.valid_from and dprod.valid_to
        left join {{ ref('dim_employee') }} demp on dids.employee_id = demp.employee_id
            and dids.order_date between demp.valid_from and demp.valid_to
        left join {{ ref('dim_shipment') }} dship on dids.shipment_id = dship.shipment_id
            and dids.order_date between dship.valid_from and dship.valid_to
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