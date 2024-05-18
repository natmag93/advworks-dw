with dimension_ids as (
    select
        purchase_id,
        vendor_id,
        employee_id,
        product_id,
        shipment_id,
        order_date,
        ship_status,
        shipment_date,
        due_date,
        orderqty,
        qty_received,
        unit_price,
        product_total,
        order_subtotal,
        tax_amount,
        freight,
        order_total
    from {{ ref('stg_purchasing') }}
),

surrogate_keys as (
    select
        purchase_id,
        vendor_id as sk_vendor,
        employee_id as sk_employee,
        product_id as sk_product,
        shipment_id as sk_shipment,
        order_date,
        ship_status,
        shipment_date,
        due_date,
        orderqty,
        qty_received,
        unit_price,
        product_total,
        order_subtotal,
        tax_amount,
        freight,
        order_total
    from dimension_ids
),

final as (
    select
        purchase_id,
        sk_vendor,
        sk_employee,
        sk_product,
        sk_shipment,
        order_date,
        ship_status,
        shipment_date,
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