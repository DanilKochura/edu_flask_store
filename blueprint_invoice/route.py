import os

from flask import Blueprint, render_template, request, current_app, session, redirect, url_for
from database.db_context_manager import DBContextManager
from datetime import date
from database.db_work import select_dict, insert, select
from database.sql_provider import SQLProvider
from cache.wrapper import fetch_from_cache


blueprint_order = Blueprint('bp_order', __name__, template_folder='template', static_folder='static')

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@blueprint_order.route('/', methods=['GET', 'POST'])
def order_index():
    df_config = current_app.config['db_config']
    cache_config = current_app.config['cache_config']
    cached_select = fetch_from_cache('all_items_cached', cache_config)(select_dict) #явное задание декоратора
    if request.method == 'GET':
        sql = provider.get('all_items.sql')
        items = cached_select(df_config, sql)
        basket_items = session.get('blueprint_invoice', {})
        print('items', items)
        print('basket_items', basket_items)
        return render_template('basket_order_list.html', items=items, basket=basket_items)
    else:
        id_prod = request.form['id_prod']
        amount = request.form['amount']
        price = request.form['price']
        sql = provider.get('all_items.sql')
        items = select_dict(df_config, sql)

        if amount:
            add_to_basket(id_prod, items, int(amount), int(price))
        else:
            add_to_basket(id_prod, items, price_user=int(price))
        return redirect(url_for('bp_order.order_index'))


def add_to_basket(id_prod: str, items: dict, user_amount=1, price_user=1):
    item_description = [item for item in items if str(item['id_prod']) == str(id_prod)]
    print('item_description before=', item_description)
    item_description = item_description[0]
    curr_basket = session.get('blueprint_invoice', {})

    if id_prod in curr_basket:
        curr_basket[id_prod]['amount'] += user_amount
        curr_basket[id_prod]['price'] += user_amount*price_user
    else:
        if user_amount > 1:
            curr_basket[id_prod] = {
                'name': item_description['name'],
                'amount': user_amount,
                'price': price_user*user_amount
            }
        else:
            curr_basket[id_prod] = {
                'name': item_description['name'],
                'amount': 1,
                'price': price_user
            }

        session['blueprint_invoice'] = curr_basket
        session.permanent = True
    return True


@blueprint_order.route('/save-blueprint_invoice', methods=['GET', 'POST'])
def save_order():
    id_sup = session.get('supplier_id')
    current_basket = session.get('blueprint_invoice', {})
    print('current_basket', current_basket)
    price = 0
    for key in current_basket:
        price += current_basket[key]['price'] * current_basket[key]['amount']
    order_id = save_order_with_list(current_app.config['db_config'], id_sup, current_basket, price)
    if order_id:
        session.pop('blueprint_invoice')
        return render_template('result.html', order_id=order_id)
    else:
        return 'Errors'


def save_order_with_list(dbconfig: dict, id_sup: int, current_basket: dict, price: int):
    with DBContextManager(dbconfig) as cursor:
        if cursor is None:
            raise ValueError('Курсор не создан')
        today = date.today()
        print(today)
        _sql1 = provider.get('insert_order.sql', id_sup=int(id_sup), sum=price, today=today)
        result1 = cursor.execute(_sql1)
        if result1 == 1:
            _sql2 = provider.get('select_order_id.sql', id_sup=id_sup)
            cursor.execute(_sql2)
            invoice_id = cursor.fetchall()[0][0]
            print('invoice_id=', invoice_id)
            if invoice_id:
                # получаем id товаров которые уже есть на складе
                _sql = provider.get('product_from_stock.sql')
                all_id_prod, schema = select(current_app.config['db_config'], _sql)
                all_id = []
                for id_p in range(len(all_id_prod)):
                    all_id.append(all_id_prod[id_p][0])
                print(all_id)

                for key in current_basket:
                    print(key, current_basket[key]['amount'])
                    prod_amount = current_basket[key]['amount']
                    price = current_basket[key]['price']
                    _sql3 = provider.get('insert_order_list.sql', invoice_id=invoice_id, prod_id=key, prod_amount=prod_amount, price=price)
                    cursor.execute(_sql3)

                    if int(key) in all_id:
                        sql_up = provider.get('update_stock.sql', today=today, amount=prod_amount, id_prod=key)
                        cursor.execute(sql_up)
                    else:
                        sql_ins = provider.get('insert_stock.sql', id_prod=key, today=today, amount=prod_amount)
                        cursor.execute(sql_ins)

                return invoice_id


@blueprint_order.route('/clear-blueprint_invoice')
def clear_basket():
    if 'blueprint_invoice' in session:
        session.pop('blueprint_invoice')
    return redirect(url_for('bp_order.order_index'))
