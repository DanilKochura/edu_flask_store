from typing import List
from database.db_context_manager import DBContextManager


def select(db_config: dict, sql: str):
    result = []
    with DBContextManager(db_config) as cursor:
        if cursor is None:
            raise ValueError('Курсор не создан')
        cursor.execute(sql)
        schema = [column[0] for column in cursor.description]
        result = cursor.fetchall()
    return result, schema


def select_dict(db_config: dict, _sql: str):
    with DBContextManager(db_config) as cursor:
        if cursor is None:
            raise ValueError('Cursor not found')
        cursor.execute(_sql)
        result = []
        schema = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            result.append(dict(zip(schema, row)))

    return result


def insert(dbconfig: dict, _sql: str):
    with DBContextManager(dbconfig) as cursor:
        if cursor is None:
            raise ValueError('Курсор не создан')
        result = cursor.execute(_sql)
        return result


def call_proc(db_config: dict, proc_name: str, *args):
    with DBContextManager(db_config) as cursor:
        if cursor is None:
            raise ValueError('Cursor not found')
        param_list = []
        for arg in args:
            print('arg = ', arg)
            param_list.append(arg)
        print('param_list =', param_list)
        res = cursor.callproc(proc_name, param_list)

        return res
