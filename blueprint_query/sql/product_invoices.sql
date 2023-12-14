SELECT supplier.name, product_invoice.amount, product_invoice.price * product_invoice.amount, invoice.date_sup
FROM `product_invoice`
         join product on product_invoice.id_prod = product.id_prod
         join invoice on product_invoice.id_Inv = invoice.id_Inv
         join supplier on supplier.id_Sup = invoice.id_Sup
where product.name = '$input_product'