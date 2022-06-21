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

@app.route("/Eliminar_categoria")
def render_eliminar_categoria():
    try:
        return render_template("eliminar_categoria.html", params=request.args)
    except Exception as e:
        return str(e)

@app.route("/delete_categoria", methods=["POST"])
def eliminar_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        categoria = request.form["categoria"]
        query = "DELETE FROM category WHERE category_name = %s;"
        data = (categoria,)
        cursor.execute(query, data)
        return query % categoria
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
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
        return lista_categorias_edit()
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/retalhistas")
def lista_retalhistas_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM retailer;"
        cursor.execute(query)
        return render_template("retalhistas.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route("/Eliminar_retalhista")
def render_eliminar_retalhsita():
    try:
        return render_template("eliminar_retalhista.html", params=request.args)
    except Exception as e:
        return str(e)

@app.route("/delete_retalhista", methods=["POST"])
def eliminar_retalhista():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        retalhista = request.form["retalhista"]
        query = """ BEGIN TRANSACTION;
                    DELETE FROM responsible_for WHERE tin=%s;
                    DELETE FROM replenishment_event WHERE tin=%s;
                    DELETE FROM retailer WHERE tin=%s;
                    COMMIT;"""
        data = (retalhista, retalhista, retalhista)
        cursor.execute(query, data)
        return query % (retalhista, retalhista, retalhista)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()



CGIHandler().run(app)
