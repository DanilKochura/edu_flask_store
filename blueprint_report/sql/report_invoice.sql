select name_sup, sum_sup, date_sup
from invoie_rep
where year(date_sup)='$input_year' and month(date_sup)='$input_month'