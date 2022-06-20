#!/usr/bin/python3
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request
import psycopg2
import psycopg2.extras

## SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist197343"
DB_DATABASE = DB_USER
DB_PASSWORD = "pmnq6802"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

app = Flask(__name__)


@app.route("/")
def list_accounts():
    try:
        return render_template("index.html")
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route("/categorias")
def lista_categorias_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM category;"
        cursor.execute(query)
        return render_template("categorias.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route("/Inserir_categoria")
def nova_categoria():
    try:
        return render_template("inserir_categoria.html", params=request.args)
    except Exception as e:
        return str(e)


@app.route("/insert", methods=["POST"])
def inseir_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        categoria = request.form["categoria"]
        query = "insert into category values (%s);"
        data = (categoria,)
        cursor.execute(query, data)
        return query % categoria
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


CGIHandler().run(app)
