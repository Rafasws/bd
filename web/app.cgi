#!/usr/bin/python3
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template
# PostgreSQL database adapter
import psycopg2
import psycopg2.extras
# SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="ist197343"
DB_DATABASE=DB_USER
DB_PASSWORD="pmnq6802"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)
app = Flask(__name__)
# Na raiz do site '/' vamos listar as contas
@app.route('/')
def product():
    dbConn=None
    cursor_product=None
    cursor_cat=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor_product = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        cursor_cat = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query_product = "SELECT * FROM product;"
        query_category = "SELECT * FROM category;"
        cursor_product.execute(query_product)
        cursor_cat.execute(query_category)
        return render_template("index.html", cursor=[cursor_product, cursor_cat])
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        cursor_product.close()
        cursor_cat.close()
        dbConn.close()
    
def categoty():
    dbConn=None
    cursor_category=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor_category = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM category;"
        cursor_category.execute(query)
        return render_template("index.html", cursor_category=cursor_category)
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        cursor_category.close()
        dbConn.close()

@app.route('/accounts')
def list_accounts_edit():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT account_number, branch_name, balance FROM account;"
        cursor.execute(query)
        return render_template("accounts.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()
 
CGIHandler().run(app)

