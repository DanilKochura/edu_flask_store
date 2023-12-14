select product.name, sum(product_invoice.amount), product.units
from invoice join product_invoice join product join supplier
on product_invoice.id_Inv = invoice.id_inv and product_invoice.id_prod = product.id_prod
and supplier.id_Sup = invoice.id_Sup
where year(date_sup)='$input_year'
group by product_invoice.id_prod