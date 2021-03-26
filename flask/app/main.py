import psycopg2

from flask import Flask, render_template, request
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

def connect():
    connection = None
    try:
        database_parameters = config()
        connection = psycopg2.connect(**database_parameters)
        cursor = connection.cursor()
        cursor.execute('SELECT version()')
        db_version = cursor.fetchone()
        print(db_version)
        cursor.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if connection is not None:
            connection.close()
            print('Closed connection successfully')

@app.route('/')
@app.route('/dashboard')
def dashboard():
    return render_template('templates/india.html')

@app.route('/states')
def state_dashboard():
    return render_template('templates/states.html')

@app.route('/districts')
def district_dashboard():
    return render_template('templates/districts.html')

# @app.route('/auth')
# @app.route('/admin')
# def login_page_or_admin_dashboard():
#     if current_user.is_authenticated:
#         return render_template('templates/admin.html')
#     else:
#         return render_template('templates/login.html')

@app.route('/auth')
def dummy_login_page():
    return render_template('templates/login.html')

@app.route('/admin')
def dummy_admin_page():
    return render_template('templates/admin.html')

if __name__ == '__main__':
    # connect()
    app.run()
