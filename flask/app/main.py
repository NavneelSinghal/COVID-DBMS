import psycopg2

from flask import Flask, render_template, request, url_for
# from flask_login import current_user
from configparser import ConfigParser

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
Helper function for query - returns (error_code, list of tuples)
'''
def request_query(queryfile, inputs, is_update=False):
    connection = None
    query_output = None
    try:
        database_parameters = config()
        connection = psycopg2.connect(**database_parameters)
        cursor = connection.cursor()
        cursor.execute(open(queryfile, 'r').read(), inputs)
        if is_update:
            connection.commit()
        column_names = [desc[0] for desc in cursor.description]
        # print(column_names)
        query_output = cursor.fetchall()
        answer = {}
        for column_name in column_names:
            answer[column_name] = []
        for q_out in query_output:
            for column_name, value in zip(column_names, q_out):
                answer[column_name].append(value)
        query_output = answer
        cursor.close()
    except psycopg2.DatabaseError as error:
        if is_update and connection is not None:
            connection.rollback()
        print(repr(error))
        query_output = {'error': repr(error)}
    finally:
        if connection is not None:
            connection.close()
    return query_output

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
    return request_query(url_for('static', filename='sql/dummy.sql'), ())

# implement the middle one later

@app.route('/api/india/vaccine')
def india_vaccine():
    print(request.args.get('from'))
    print(request.args.get('to'))
    return request_query(url_for('static', filename='sql/dummy.sql'), (request.args.get('from'), request.args.get('to')))

# implement the remaining ones later

'''
Updates
'''


if __name__ == '__main__':
    # connect()
    app.run()
