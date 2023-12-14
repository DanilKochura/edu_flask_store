import json

from flask import Flask, render_template, session, redirect, url_for
from blueprint_auth.routes import blueprint_auth
from blueprint_report.routes import blueprint_report
from blueprint_query.route import blueprint_query
from blueprint_invoice.route import blueprint_order
from access import login_required, group_required
from typing import List, Callable


app = Flask(__name__)
app.secret_key = 'SuperKey'

app.register_blueprint(blueprint_auth, url_prefix='/blueprint_auth')
app.register_blueprint(blueprint_report, url_prefix='/blueprint_report')
app.register_blueprint(blueprint_query, url_prefix='/queries')
app.register_blueprint(blueprint_order, url_prefix='/order')

app.config['db_config'] = json.load(open('configs/db.json'))
app.config['access_config'] = json.load(open('configs/access.json'))
app.config['cache_config'] = json.load(open('configs/cache.json'))


# функция, которая принимает другую функцию в качестве аргумента и возвращает ещё одну функцию
@app.route('/')
@login_required
def menu_choice():
    if session.get('user_group', None) == 'supplier':       #возвращает значения ключа сессии user_group
        return render_template('external_user_menu.html')
    return render_template('internal_user_menu.html')


@app.route('/exit')
@login_required
def exit_func():
    session.clear()
    return redirect(url_for("blueprint_auth.start_auth"))
    # return render_template('exit.html')


def add_blueprint_access_handler(app: Flask, blueprint_names: List[str], handler: Callable) -> Flask:
    for view_func_name, view_func in app.view_functions.items():#цикл по всем доступным обработчикам
        print('view_func_name=', view_func_name) #имя функции
        print('view_func', view_func)#сама функция
        view_func_parts = view_func_name.split('.')
        if len(view_func_parts)> 1:
            view_blueprint = view_func_parts[0] #имя блюпринта
            if view_blueprint in blueprint_names:
                view_func = handler(view_func)# функция оборачивается в декоратор
                app.view_functions[view_func_name] = view_func
    return app


if __name__ == '__main__':
    app = add_blueprint_access_handler(app, ['bp_report'], group_required)
    app.run(host='127.0.0.1', port=5002)
