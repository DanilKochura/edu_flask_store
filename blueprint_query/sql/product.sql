select name, amount, units, date_up from stock join product on stock.id_product = product.id_prod where name='$input_product'