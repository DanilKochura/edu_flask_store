select name, sum(sum_price)/count(*)
from invoice join supplier on invoice.id_Sup=supplier.id_Sup
where year(date_sup)='$input_year'
group by invoice.id_Sup