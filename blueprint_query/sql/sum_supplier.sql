select name, sum(sum_price)/count(*)
from invoice join supplier on invoice.id_Sup=supplier.id_Sup
where name='$input_supplier' and year(date_sup)='$input_year'