
select p.productid as product_ID,
p.name as product_name,
p.productnumber as product_number,
coalesce (nullif(pc.name,''), 'not available') as category,
coalesce (nullif(psc.name,''), 'not available') as subcategory,
coalesce (nullif(p.color,''), 'not available') as color,
coalesce (nullif(p.size,''), 'not available') as size,
coalesce (nullif(CAST (p.weight as text),''), 'not available')as weight
from {{ source("production", "product") }} p
	left join {{ source("production", "productsubcategory") }} psc on p.productsubcategoryid = psc.productsubcategoryid
	left join {{ source("production", "productcategory") }} pc on psc.productcategoryid = pc.productcategoryid