import psycopg2

from flask import Flask, render_template, request, url_for
# from flask_login import current_user
from configparser import ConfigParser

app = Flask(__name__)

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

def request_query(query: str, is_update: bool):
    connection = None
    query_output = None
    try:
        database_parameters = config()
        connection = psycopg2.connect(**database_parameters)
        cursor = connection.cursor()
        if is_update:
            cursor.execute(query)
            connection.commit()
        else:
            cursor.execute(query)
        query_output = cursor.fetchall()
        cursor.close()
    except psycopg2.DatabaseError as error:
        if is_update:
            connection.rollback()
        print(error)
    finally:
        if connection is not None:
            connection.close()
        return query_output # change this to format stuff correctly

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

if __name__ == '__main__':
    # connect()
    app.run()
