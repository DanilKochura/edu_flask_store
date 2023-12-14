import os  # работа с объектами операционной системы
import json

from flask import Blueprint, request, render_template, current_app, redirect, url_for  # глобальная переменная с конфигом app
from database.db_work import select
from database.sql_provider import SQLProvider
from access import group_required
from datetime import date

blueprint_query = Blueprint('bp_query', __name__, template_folder='templates')
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


with open('configs/queries_list.json', 'r', encoding='UTF-8') as f:
    queries_list = json.load(f)
with open('configs/queries_url.json', 'r') as f:
    queries_url = json.load(f)


@blueprint_query.route('/', methods=['GET'])
@group_required
def start_queries():
    print(queries_list, queries_url)
    return render_template('queries_result.html', queries_list=queries_list, queries_url=queries_url)



@blueprint_query.route('/queries1', methods=['GET', 'POST'])
@group_required
def queries1():
    _sql = provider.get('all_product.sql')
    product_result, schema = select(current_app.config['db_config'], _sql)
    all_product_k = product_result
    all_product = []
    for i in range(len(all_product_k)):
        all_product.append(all_product_k[i][0])
    if request.method == 'GET': # открыть форму для поиска продукта по названию

        print('all_product', all_product)
        return render_template('product_form.html', all_product=all_product)
    else:
        input_product = request.form.get('product_name')
        print("продукт", input_product)

        gal = request.form.get('subscribe')
        if gal == 'yes':
            _sql = provider.get('all_prod_stock.sql')
            product_result, schema = select(current_app.config['db_config'], _sql)
            if not product_result:
                return render_template('product_form.html', 'На складе нет товаров')
            title = ['Название товара', 'Количество', 'Единица измерения', 'Дата последней доставки']
            return render_template('product_form.html', schema=title, result=product_result,
                                   message='Количество товара на складе:',all_product=all_product)
        else:
            if input_product:
                _sql = provider.get('product.sql', input_product=input_product)
                product_result, schema = select(current_app.config['db_config'], _sql)
                if not product_result:
                    return render_template('product_form.html', message='На складе нет данного товара',all_product=all_product)
                print('product_result = ', product_result)
                print('schema = ', schema)
                title = ['Название товара', 'Количество', 'Единица измерения', 'Дата последней доставки']
                return render_template('product_form.html', all_product=all_product,schema=title, result=product_result, message='Количество товара '+input_product+'  на складе:')
            else:
                return render_template('product_form.html', all_product=all_product, error="Повторите Ввод!")


@blueprint_query.route('/queries2', methods=['GET', 'POST'])
@group_required
def queries2():
    _sql = provider.get('all_supplier.sql')
    supplier_result, schema = select(current_app.config['db_config'], _sql)
    all_supplier_k = supplier_result
    all_supplier = []
    for i in range(len(all_supplier_k)):
        all_supplier.append(all_supplier_k[i][0])
    if request.method == 'GET': # открыть форму для поиска продукта по названию
        print('all_product', all_supplier)
        today = date.today()
        max_year = str(today.year)
        return render_template('supplier_form.html', all_supplier=all_supplier, max_year=max_year, title='Средняя сумма поставок')
    else:
        input_supplier = request.form.get('supplier_name')
        input_year = request.form.get('year')

        gal = request.form.get('subscribe')
        if gal == 'yes':
            _sql = provider.get('sum_all_supplier.sql', input_year=input_year)
            product_result, schema = select(current_app.config['db_config'], _sql)
            if not product_result:
                return render_template('notfound.html', 'За выбранный год поставок нет')
            title = ['Название поставщика', 'Средняя сумма']
            return render_template('supplier_form.html', all_supplier=all_supplier, schema=title, result=product_result,
                                   message='Средняя сумма поставок за год:')
        else:
            print("поставщик, год", input_supplier, input_year)
            if input_year and input_supplier:
                _sql = provider.get('sum_supplier.sql', input_supplier=input_supplier, input_year=input_year)
                supplier_result, schema = select(current_app.config['db_config'], _sql)
                if not supplier_result or None in supplier_result[0]:
                    return render_template('supplier_form.html', all_supplier=all_supplier, message='За выбранный год от поставщика поставок нет')
                print('product_result = ', supplier_result)
                print('schema = ', schema)
                title = ['Название поставщика', 'Средняя сумма']
                return render_template('supplier_form.html', all_supplier=all_supplier, schema=title, result=supplier_result, message='Средняя сумма поставок за год:')
            else:
                return render_template('supplier_form.html', all_supplier=all_supplier,
                                       error='Повторите ввод!')


@blueprint_query.route('/queries3', methods=['GET', 'POST'])
@group_required
def queries3():
    _sql = provider.get('all_supplier.sql')
    supplier_result, schema = select(current_app.config['db_config'], _sql)
    all_supplier_k = supplier_result
    all_supplier = []
    today = date.today()
    max_year = str(today.year)
    for i in range(len(all_supplier_k)):
        all_supplier.append(all_supplier_k[i][0])
    if request.method == 'GET': # открыть форму для поиска продукта по названию
        print('all_product', all_supplier)

        return render_template('supplier_form.html', all_supplier=all_supplier, max_year=max_year, title='Поставленные товары')
    else:
        input_supplier = request.form.get('supplier_name')
        input_year = request.form.get('year')

        gal = request.form.get('subscribe')
        print('GALOCH', gal)
        if gal == 'yes':
            _sql = provider.get('prod_all_supplier.sql', input_year=input_year)
            product_result, schema = select(current_app.config['db_config'], _sql)
            if not product_result:
                return render_template('supplier_form.html',  all_supplier=all_supplier, max_year=max_year, message='За выбранный год поставок нет')
            title = ['Название товара', 'Количество', 'Единица измерения']
            return render_template('supplier_form.html',all_supplier=all_supplier, max_year=max_year, schema=title, result=product_result,
                                   message='Список поставленных товаров поставщиком за год:')
        else:
            print("поставщик, год", input_supplier, input_year)
            if input_year and input_supplier:
                _sql = provider.get('prod_supplier.sql', input_supplier=input_supplier, input_year=input_year)
                supplier_result, schema = select(current_app.config['db_config'], _sql)
                if not supplier_result:
                    return render_template('supplier_form.html',all_supplier=all_supplier, max_year=max_year, message='За выбранный год поставщик не сделал ни одной поставки')
                print('product_result = ', supplier_result)
                print('schema = ', schema)
                title = ['Название товара', 'Количество', 'Единица измерения']
                return render_template('supplier_form.html',all_supplier=all_supplier, max_year=max_year, schema=title, result=supplier_result, message='Список поставленных товаров поставщиком за год:')
            else:
                return render_template('supplier_form.html', all_supplier=all_supplier, max_year=max_year,
                                       error='Повторите ввод!')

@blueprint_query.route('/queries4', methods=['GET', 'POST'])
@group_required
def queries4():
    _sql = provider.get('all_product.sql')
    product_result, schema = select(current_app.config['db_config'], _sql)
    all_product_k = product_result
    all_product = []
    for i in range(len(all_product_k)):
        all_product.append(all_product_k[i][0])
    if request.method == 'GET': # открыть форму для поиска продукта по названию

        print('all_product', all_product)
        return render_template('product_form.html', all_product=all_product)
    else:
        input_product = request.form.get('product_name')
        print("продукт", input_product)
        if input_product:
            _sql = provider.get('product_invoices.sql', input_product=input_product)
            product_result, schema = select(current_app.config['db_config'], _sql)
            if not product_result:
                return render_template('product_form.html', message='Не было поставок данного товара',all_product=all_product)
            print('product_result = ', product_result)
            print('schema = ', schema)
            title = ['Поставщик', 'Количество', 'Сумма', 'Дата последней поставки']
            return render_template('product_form.html', all_product=all_product,schema=title, result=product_result, message='Поставки товара '+input_product+' на склад:')
        else:
            return render_template('product_form.html', all_product=all_product, error="Повторите Ввод!")

