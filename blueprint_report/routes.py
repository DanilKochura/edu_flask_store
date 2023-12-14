from flask import Blueprint, render_template, redirect, url_for, request, current_app
import os
import json
from datetime import date
from access import group_required
from database.db_work import call_proc, select
from database.sql_provider import SQLProvider


provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))
blueprint_report = Blueprint('blueprint_report', __name__, template_folder='templates')


with open('configs/report_list.json', 'r', encoding='UTF-8') as f:
    report_list = json.load(f)
with open('configs/report_url.json', 'r') as f:
    report_url = json.load(f)


@blueprint_report.route('/', methods=['GET', 'POST'])
@group_required
def start_report():
    if request.method == 'GET':
        return render_template('report_result.html', report_list=report_list,  report_url=report_url)


@blueprint_report.route('/create_rep1', methods=['GET', 'POST'])
@group_required
def create_rep1():
    today = date.today()
    max_date = str(today.year) + '-' + str(today.month)
    if request.method == 'GET':
        return render_template('report.html', max=max_date)
    else:
        input_month = request.form.get('month')
        input_year = input_month[:4]
        input_month = input_month[5:]
        print(input_month, input_year)
        # проверка на то, что такого отчета еще нет
        _sql = provider.get('report_invoice.sql', input_month=input_month, input_year=input_year)
        invoice_result, schema = select(current_app.config['db_config'], _sql)
        print('invoice_result', invoice_result)
        if input_year and input_month and len(invoice_result) == 0:
            _proc = call_proc(current_app.config['db_config'], 'invoice_rep', input_month, input_year)
            print('процедура', _proc)
            _sql = provider.get('report_invoice.sql', input_month=input_month, input_year=input_year)
            invoice_result, schema = select(current_app.config['db_config'], _sql)
            if len(invoice_result) == 0:
                return render_template('report.html', message='За данный период нет поставок')
            else:
                return render_template('report.html', message='Отчет успешно создан!')
        elif not input_year or not input_month:
            return render_template('report.html', error='Все поля должны быть заполнены.')
        else:
            return render_template('report.html', message='Такой отчет уже существует.')


@blueprint_report.route('/create_rep2', methods=['GET', 'POST'])
@group_required
def create_rep2():
    today = date.today()
    max_date = str(today.year) + '-' + str(today.month)
    if request.method == 'GET':
        return render_template('report.html', max=max_date)
    else:
        input_month = request.form.get('month')
        input_year = input_month[:4]
        input_month = input_month[5:]
        print(input_month, input_year)
        # проверка на то, что такого отчета еще нет
        _sql = provider.get('supplier.sql', input_month=input_month, input_year=input_year)
        invoice_result, schema = select(current_app.config['db_config'], _sql)
        print('invoice_result', invoice_result)
        if input_year and input_month and len(invoice_result) == 0:
            _proc = call_proc(current_app.config['db_config'], 'supplier_rep', input_month, input_year)
            print('процедура', _proc)
            return render_template('report.html', message='Отчет успешно создан!')
        elif not input_year or not input_month:
            return render_template('report.html', error='Все поля должны быть заполнены.')
        else:
            return render_template('report.html', message='Такой отчет уже существует.')


@blueprint_report.route('/view_rep1', methods=['GET', 'POST'])
@group_required
def view_rep1():
    today = date.today()
    max_date = str(today.year) + '-' + str(today.month)
    print(max_date)
    if request.method == 'GET':
        return render_template('report.html', max=max_date)
    else:
        input_month = request.form.get('month')
        input_year = input_month[:4]
        input_month = input_month[5:]
        print(input_month, input_year)
        if input_month and input_year:
            _sql = provider.get('report_invoice.sql', input_month=input_month, input_year=input_year)
            product_result, schema = select(current_app.config['db_config'], _sql)
            if not product_result:
                return render_template('report.html', message='За данный период нет поставок')
            col = ['Поставщик', 'Сумма поставки', 'Дата поставки']
            return render_template('report.html', schema=col, result=product_result)
        else:
            return render_template('report.html', error='Все поля должны быть заполнены.')


@blueprint_report.route('/view_rep2', methods=['GET', 'POST'])
@group_required
def view_rep2():
    today = date.today()
    max_date = str(today.year) + '-' + str(today.month)
    print(max_date)
    if request.method == 'GET':
        return render_template('report.html', max=max_date)
    else:
        input_month = request.form.get('month')
        input_year = input_month[:4]
        input_month = input_month[5:]
        print(input_month, input_year)
        if input_month and input_year:
            _sql = provider.get('supplier.sql', input_month=input_month, input_year=input_year)
            product_result, schema = select(current_app.config['db_config'], _sql)
            if not product_result:
                return render_template('report.html', message='За данный период не было заключено контрактов')
            col = ['Поставщик', 'Банк', 'Телефон', 'Дата заключения контракта']
            return render_template('report.html', schema=col, result=product_result)
        else:
            return render_template('report.html', error='Все поля должны быть заполнены.')