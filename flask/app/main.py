import psycopg2

from flask import Flask, render_template, request, url_for
# from flask_login import current_user
from configparser import ConfigParser
import datetime
import json


def correctdate(a):
    return datetime.datetime.strptime(a, "%Y-%m-%d").strftime("%d-%m-%Y")


app = Flask(__name__)

'''
Helper function for parsing database details
'''


def config(filename='app/database.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))
    return db


'''
Helper function for default serialization
'''


def default_serialize(s):
    return str(s)


'''
Helper function for query - returns (error_code, list of tuples)
'''


def request_query(queryfile, inputs, is_update=False, cols=None, raw=False):
    connection = None
    query_output = None
    try:
        database_parameters = config()
        connection = psycopg2.connect(**database_parameters)
        cur = connection.cursor()
        query = open(queryfile, 'r').read()
        # print(query)
        print('inputs:', inputs)
        cur.execute(query, inputs)
        if is_update:
            connection.commit()
        # print(cur.description)
        column_names = [desc[0] for desc in cur.description]
        # print(column_names)
        query_output = cur.fetchall()
        answer = {}
        for column_name in column_names:
            answer[column_name] = []
        for q_out in query_output:
            for column_name, value in zip(column_names, q_out):
                answer[column_name].append(value)
        query_output = answer
        cur.close()
    except psycopg2.DatabaseError as error:
        if is_update and connection is not None:
            connection.rollback()
        print(repr(error))
        query_output = {'error': repr(error)}
    finally:
        if connection is not None:
            connection.close()
    # print(query_output)
    if cols is not None:
        ret = {}
        for col in cols:
            ret[col] = query_output[col]
        query_output = ret
    if raw:
        return query_output
    return json.dumps(query_output, default=default_serialize)


'''
Webpage rendering
'''


@app.route('/')
@app.route('/dashboard')
def dashboard():
    return render_template('india.html', js=url_for('static', filename='js'), css=url_for('static', filename='css'))


@app.route('/states')
def state_dashboard():
    return render_template('states.html', js=url_for('static', filename='js'), css=url_for('static', filename='css'))


@app.route('/districts')
def district_dashboard():
    return render_template('districts.html', js=url_for('static', filename='js'), css=url_for('static', filename='css'))

# @app.route('/auth')
# @app.route('/admin')
# def login_page_or_admin_dashboard():
#     if current_user.is_authenticated:
#         return render_template('admin.html', js=url_for('static', filename='js'), css=url_for('static', filename='css'))
#     else:
#         return render_template('login.html', js=url_for('static', filename='js'), css=url_for('static', filename='css'))


@app.route('/auth')
def dummy_login_page():
    return render_template('login.html', js=url_for('static', filename='js'), css=url_for('static', filename='css'))


@app.route('/admin')
def dummy_admin_page():
    return render_template('admin.html', js=url_for('static', filename='js'), css=url_for('static', filename='css'))


'''
Queries
'''


@app.route('/api/india/summary')
def india_summary():
    fromdate = correctdate(request.args.get('from'))
    todate = correctdate(request.args.get('to'))
    return request_query('app/sql/india_summary.sql', (fromdate, todate))


@app.route('/api/india/daily')
def india_daily():
    statstype = request.args.get('type')
    statsparam = request.args.get('parameter')
    ndays = request.args.get('ndays')
    if statstype == 'Daily':
        ans = request_query('app/sql/india_daily_daily.sql', (ndays,))#, cols=(statsparam,))
    elif statstype == 'Cumulative':
        ans = request_query('app/sql/india_daily_cumulative.sql', (ndays,))#, cols=(statsparam,))
    else:
        ans = request_query('app/sql/india_daily_avg.sql', (ndays,))#, cols=(statsparam,))
    return ans


@app.route('/api/india/vaccine')
def india_vaccine():
    fromdate = correctdate(request.args.get('from'))
    todate = correctdate(request.args.get('to'))
    return request_query('app/sql/india_vaccine_summary.sql', (fromdate, todate))


@app.route('/api/india/analysis')
def india_analysis():
    granularity = request.args.get('granularity')  # dummy
    fromdate = correctdate(request.args.get('from'))
    todate = correctdate(request.args.get('to'))
    statstype = request.args.get('type')
    statsparam = request.args.get('parameter')
    query = request.args.get('query')  # not implemented
    if statstype == 'Daily':
        return request_query('app/sql/analysis_india_daily_daily.sql', (fromdate, todate, statstype))#, cols=(statsparam,))
    elif statstype == 'Cumulative':
        return request_query('app/sql/analysis_india_daily_cumulative.sql', (fromdate, todate, statstype))#, cols=(statsparam,))
    else:
        return request_query('app/sql/analysis_india_daily_avg.sql', (fromdate, todate, statstype))#, cols=(statsparam,))


@app.route('/api/india/liststates')
def india_liststates():
    sortcriteria = request.args.get('sortedby')
    order = request.args.get('sortedin')
    ans_ret = request_query('app/sql/list_state.sql', (sortcriteria,), raw=True)
    ans = {}
    if order == 'Descending':
        for k, v in ans_ret.items():
            ans[k] = list(reversed(v))
    else:
        ans = ans_ret
    return json.dumps(ans, default=default_serialize)

'''
Updates
'''


if __name__ == '__main__':
    # connect()
    app.run()
