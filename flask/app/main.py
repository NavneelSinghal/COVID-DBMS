import psycopg2

from flask import Flask, render_template, request, url_for
# from flask_login import current_user
from configparser import ConfigParser

app = Flask(__name__)

'''
Helper function for parsing database details
'''
def config(filename='database.ini', section='postgresql'):
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
Helper function for query - returns (error_code, list of tuples)
'''
def request_query(queryfile, inputs, is_update):
    connection = None
    query_output = None
    error_code = 0
    try:
        database_parameters = config()
        connection = psycopg2.connect(**database_parameters)
        cursor = connection.cursor()
        cursor.execute(open(queryfile, 'r').read(), inputs)
        if is_update:
            connection.commit()
        query_output = cursor.fetchall()
        cursor.close()
    except psycopg2.DatabaseError as error:
        if is_update and connection is not None:
            connection.rollback()
        query_output = [repr(error)]
        error_code = 1
    finally:
        if connection is not None:
            connection.close()
        return (error_code, query_output)

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
    # print(request.args.get(''))
    error_code, query_result = request_query(url_for('sql', filename='dummy.sql'), ())
    answer = {}
    if error_code == 0:
        # assumes at least 1
        answer['india-summary-column'] = query_result[0][0]
    else:
        answer['error'] = query_result[0]
    return answer

# implement the middle one later

@app.route('/api/india/vaccine')
def india_vaccine():
    print(request.args.get('from'))
    print(request.args.get('to'))
    error_code, query_result = request_query(url_for('sql', filename='dummy.sql'), (request.args.get('from'), request.args.get('to')))
    answer = {}
    if error_code == 0:
        # assumes at least 1
        answer['india-vaccine-column'] = query_result[0][0]
    else:
        answer['error'] = query_result[0]
    return answer

# implement the remaining ones later

'''
Updates
'''


if __name__ == '__main__':
    # connect()
    app.run()
