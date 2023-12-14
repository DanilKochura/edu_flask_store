select name_sup, bank, phone, date_treaty from supplier_rep
where year(date_treaty)='$input_year' and month(date_treaty)='$input_month'