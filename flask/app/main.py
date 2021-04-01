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
        if inputs is None:
            cur.execute(query)
        else:
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
        ans = request_query('app/sql/india_daily_daily.sql', (ndays,), raw=True)
    elif statstype == 'Cumulative':
        ans = request_query('app/sql/india_daily_cumulative.sql', (ndays,), raw=True)
    else:
        ans = request_query('app/sql/india_daily_avg.sql', (ndays,), raw=True)
    for k, v in ans.items():
        ans[k] = list(reversed(v))
    return json.dumps(ans, default=default_serialize)


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
    query = request.args.get('query')
    if query == 'Maximum':
        query = 'DSC'
    else:
        query = 'ASC'
    if statstype == 'Daily':
        return request_query('app/sql/analysis_india_daily_daily.sql', (fromdate, todate, statsparam, query))
    elif statstype == 'Cumulative':
        return request_query('app/sql/analysis_india_daily_cumulative.sql', (fromdate, todate, statsparam, query))
    else:
        return request_query('app/sql/analysis_india_daily_avg.sql', (fromdate, todate, statsparam, query))


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


@app.route('/api/states/list')
def state_list():
    return request_query('app/sql/states_list.sql', None)


@app.route('/api/states/summary')
def state_summary():
    fromdate = correctdate(request.args.get('from'))
    todate = correctdate(request.args.get('to'))
    stateid = request.args.get('stateid')
    return request_query('app/sql/state_summary.sql', (fromdate, todate, stateid))


@app.route('/api/states/daily')
def state_daily():
    statstype = request.args.get('type')
    statsparam = request.args.get('parameter')
    ndays = request.args.get('ndays')
    stateid = request.args.get('stateid')
    if statstype == 'Daily':
        ans = request_query('app/sql/state_daily_daily.sql', (ndays, stateid), raw=True)
    elif statstype == 'Cumulative':
        ans = request_query('app/sql/state_daily_cumulative.sql', (ndays, stateid), raw=True)
    else:
        ans = request_query('app/sql/state_daily_avg.sql', (ndays, stateid), raw=True)
    for k, v in ans.items():
        ans[k] = list(reversed(v))
    return json.dumps(ans, default=default_serialize)


@app.route('/api/states/vaccine')
def state_vaccine():
    stateid = request.args.get('stateid')
    fromdate = correctdate(request.args.get('from'))
    todate = correctdate(request.args.get('to'))
    return request_query('app/sql/state_vaccine_summary.sql', (fromdate, todate, stateid))


@app.route('/api/states/analysis')
def state_analysis():
    stateid = request.args.get('stateid')
    granularity = request.args.get('granularity')  # dummy
    fromdate = correctdate(request.args.get('from'))
    todate = correctdate(request.args.get('to'))
    statstype = request.args.get('type')
    statsparam = request.args.get('parameter')
    query = request.args.get('query')
    if query == 'Maximum':
        query = 'DSC'
    else:
        query = 'ASC'
    if statstype == 'Daily':
        return request_query('app/sql/analysis_state_daily_daily.sql', (stateid, fromdate, todate, statsparam, query))
    elif statstype == 'Cumulative':
        return request_query('app/sql/analysis_state_daily_cumulative.sql', (stateid, fromdate, todate, statsparam, query))
    else:
        return request_query('app/sql/analysis_state_daily_avg.sql', (stateid, fromdate, todate, statsparam, query))


@app.route('/api/states/listdistricts')
def state_listdistricts():
    stateid = request.args.get('stateid')
    sortcriteria = request.args.get('sortedby')
    order = request.args.get('sortedin')
    ans_ret = request_query('app/sql/list_district.sql', (stateid, sortcriteria), raw=True)
    ans = {}
    if order == 'Descending':
        for k, v in ans_ret.items():
            ans[k] = list(reversed(v))
    else:
        ans = ans_ret
    return json.dumps(ans, default=default_serialize)


@app.route('/api/districts/list')
def district_list():
    try:
        stateid = request.args.get('stateid')
        return request_query('app/sql/district_list_statewise.sql', (stateid,))
    except:
        return request_query('app/sql/district_list.sql', None)


@app.route('/api/districts/summary')
def district_summary():
    fromdate = correctdate(request.args.get('from'))
    todate = correctdate(request.args.get('to'))
    districtid = request.args.get('districtid')
    return request_query('app/sql/district_summary.sql', (fromdate, todate, districtid))


@app.route('/api/districts/daily')
def district_daily():
    statstype = request.args.get('type')
    statsparam = request.args.get('parameter')
    ndays = request.args.get('ndays')
    districtid = request.args.get('districtid')
    if statstype == 'Daily':
        ans = request_query('app/sql/district_daily_daily.sql', (ndays, districtid), raw=True)
    elif statstype == 'Cumulative':
        ans = request_query('app/sql/district_daily_cumulative.sql', (ndays, districtid), raw=True)
    else:
        ans = request_query('app/sql/district_daily_avg.sql', (ndays, districtid), raw=True)
    for k, v in ans.items():
        ans[k] = list(reversed(v))
    return json.dumps(ans, default=default_serialize)


@app.route('/api/districts/values')
def district_values():
    districtid = request.args.get('districtid')
    date = request.args.get('date')
    return request_query('app/sql/district_values.sql', (districtid, date))


@app.route('/api/states/values')
def state_values():
    stateid = request.args.get('stateid')
    date = request.args.get('date')
    return request_query('app/sql/state_values.sql', (stateid, date))


@app.route('/api/states/vaccinevalues')
def state_vaccinevalues():
    stateid = request.args.get('stateid')
    date = request.args.get('date')
    return request_query('app/sql/vaccine_values.sql', (stateid, date))


'''
UPDATES
'''

def update_query(queryfile, inputs):
    connection = None
    query_output = -1
    status = 200
    try:
        database_parameters = config()
        connection = psycopg2.connect(**database_parameters)
        cur = connection.cursor()
        query = open(queryfile, 'r').read()
        print('inputs:', inputs)
        if inputs is None:
            cur.execute(query)
        else:
            cur.execute(query, inputs)
        connection.commit()
        query_output = {'rowcount' : cur.rowcount}
        cur.close()
    except psycopg2.DatabaseError as error:
        if connection is not None:
            connection.rollback()
        print(repr(error))
        query_output = {'error': repr(error)}
        status = 400
    finally:
        if connection is not None:
            connection.close()
    return (query_output, status)


@app.route('/api/management/newdistrict', methods=['POST'])
def newdistrict():
    content = request.json
    stateid = content['stateid']
    districtname = content['districtname']
    population = content['population']
    return update_query('app/sql/new_district.sql', (stateid, districtname, population))


@app.route('/api/management/updatedistrict', methods=['POST'])
def updatedistrict():
    content = request.json
    districtid = content['districtid']
    newname = content['newname']
    return update_query('app/sql/updated_district.sql', (districtid, newname))


@app.route('/api/management/deletedistrict', methods=['POST'])
def deletedistrict():
    content = request.json
    districtid = content['districtid']
    return update_query('app/sql/delete_district.sql', (districtid,))


@app.route('/api/update/newcases', methods=['POST'])
def newcases():
    content = request.json
    stateid = content['stateid']
    districtid = content['districtid']
    date = content['date']
    confirmed = content['confirmed']
    recovered = content['recovered']
    deceased = content['deceased']
    tested = content['tested']
    other = 0
    output, status = update_query('app/sql/update_cases.sql', (stateid, districtid, date, confirmed, recovered, deceased, other, tested))
    if status == 400:
        return output, status # no need to update state
    if output['rowcount'] == 0:
        output, status = update_query('app/sql/insert_cases.sql', (stateid, districtid, date, confirmed, recovered, deceased, other, tested))
    _, _ = update_query('app/sql/update_state_cases.sql', (stateid, districtid, date, confirmed, recovered, deceased, other, tested))
    return output, status


@app.route('/api/update/newvaccinations', methods=['POST'])
def newvaccinations():
    content = request.json
    stateid = content['stateid']
    date = content['date']
    sessions = content['sessions']
    indivregistered = content['indivregistered']
    males = content['males']
    females = content['females']
    trans = content['trans']
    firstdose = content['firstdose']
    seconddose = content['seconddose']
    totaldose = content['totaldose']
    covaxin = content['covaxin']
    covishield = content['covishield']
    sites = content['sites']
    output, status = update_query('app/sql/update_vaccinations.sql', (stateid, date, sessions, indivregistered, males, females, trans, firstdose, seconddose, totaldose, covaxin, covishield, sites))
    if status == 400:
        return output, status
    if output['rowcount'] == 0:
        output, status = update_query('app/sql/insert_vaccinations.sql', (stateid, date, sessions, indivregistered, males, females, trans, firstdose, seconddose, totaldose, covaxin, covishield, sites))
    return output, status


@app.route('/api/update/refreshfull', methods=['POST'])
def refreshfull():
    return update_query('app/sql/refresh.sql')

if __name__ == '__main__':
    # connect()
    app.run()
