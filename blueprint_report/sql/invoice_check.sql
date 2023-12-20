select *
from invoice
where year(date_sup)='$input_year' and month(date_sup)='$input_month'