from flask import Blueprint, render_template, redirect, url_for, request, current_app
import os
import json
from datetime import date
from access import group_required
from database.db_work import call_proc, select, select_dict, insert
from database.sql_provider import SQLProvider


provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))
blueprint_confirmation = Blueprint('blueprint_invoice_suggest', __name__, template_folder='templates')





@blueprint_confirmation.route('/', methods=['GET', 'POST'])
@group_required
def confirmation():

    _sql = provider.get('unsuggested.sql')
    result = select_dict(current_app.config['db_config'], _sql)
    table = []
    for invoice in result:
        _sql_prod = provider.get('products_invoice.sql', id_inv=invoice['id_Inv'])
        invoice['order'], table = select(current_app.config['db_config'], _sql_prod)
    print(result)
    if request.method == 'POST':
        sql_confirm = provider.get("confirmation.sql", id_inv=request.form.get("id_Inv"))
        insert(current_app.config['db_config'], sql_confirm)
    if len(result) == 0:
        return render_template('invoices.html', message='Нет неподтвержденных накладных')
    else:
        return render_template('invoices.html', result=result, table=table)



