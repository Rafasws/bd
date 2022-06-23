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
        return render_template("error.html", error_message=e) 


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
        return render_template("error.html", error_message=e) 
    finally:
        cursor.close()
        dbConn.close()

@app.route("/Eliminar_categoria")
def render_eliminar_categoria():
    try:
        return render_template("eliminar_categoria.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error_message=e) 

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
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()



@app.route("/Inserir_categoria")
def nova_categoria():
    try:
        return render_template("inserir_categoria.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error_message=e) 


@app.route("/insert", methods=["POST"])
def inseir_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        categoria = request.form["categoria"]
        query = "INSERT INTO category VALUES (%s);"
        data = (categoria,)
        cursor.execute(query, data)
        return lista_categorias_edit()
    except Exception as e:
        return render_template("error.html", error_message=e) 
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
        return render_template("error.html", error_message=e) 
    finally:
        cursor.close()
        dbConn.close()


@app.route("/Eliminar_retalhista")
def render_eliminar_retalhsita():
    try:
        return render_template("eliminar_retalhista.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error_message=e) 

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
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/Inserir_retalhista")
def novo_retalhista():
    try:
        return render_template("inserir_retalhista.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error_message=e) 


@app.route("/insert_retalhista", methods=["POST"])
def inseir_retalhista():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        tin = request.form["tin"]
        nome =  request.form["nome"]
        query = "INSERT INTO retailer VALUES (%s, %s);"
        data = (tin, nome)
        cursor.execute(query, data)
        return query % data
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/escolhe_ivm")
def escolhe_ivm():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM ivm;"
        cursor.execute(query)
        return render_template("ivm.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        cursor.close()
        dbConn.close()

@app.route("/selecionar_ivm", methods=["POST"])
def listar_ER():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        ivm = request.form["ivm"]
        ivm_list = ivm.split(" ")
        manuf = ivm_list[1]
        serial = ivm_list[0]
        query = """SELECT cat, SUM(units)
                    FROM replenishment_event NATURAL JOIN has_category
                    WHERE serial_number = %s AND manufacturer=%s
                    GROUP BY cat;              
                """
        data = (serial, manuf)
        cursor.execute(query, data)
        return render_template("lista_er.html",cursor=cursor, ivm=ivm)
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/escolhe_categoria")
def escolhe_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_category;"
        cursor.execute(query)
        return render_template("super_categoria.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        cursor.close()
        dbConn.close()


@app.route("/listar_sub_categorias", methods=["POST"])
def listar_sub_categorias():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        super_categoria = request.form["super_categoria"]
        query = """WITH RECURSIVE sub_categories AS (
	                    SELECT
		                    category
	                    FROM
		                    has_other
	                    WHERE
		                    super_category = %s
	                    UNION
		                    SELECT
			                    e.category
		                    FROM
			                    has_other e
		                    INNER JOIN sub_categories s ON s.category = e.super_category
                        ) SELECT *
                        FROM
	                        sub_categories;              
                """
        data = (super_categoria,)
        cursor.execute(query, data)
        return render_template("lista_sub_categorias.html",cursor=cursor, super_categoria=super_categoria)
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

        
CGIHandler().run(app)
