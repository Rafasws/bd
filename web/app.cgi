#!/usr/bin/python3
from wsgiref.handlers import CGIHandler
from flask import Flask, redirect
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
def home():
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
        return redirect("/ist197343/app.cgi/")
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
        query = """ 
                BEGIN TRANSACTION;
                    INSERT INTO category VALUES (%s);
                    INSERT INTO simple_category VALUES (%s);
                COMMIT;    
                """
        data = (categoria, categoria)
        cursor.execute(query, data)
        return lista_categorias_edit()
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()
        
@app.route("/Adicionar_sub_categoria")
def adicionar_sub_categoria():
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        return render_template("inserir_sub_categoria.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.close()

@app.route("/inserir_sub_categoria", methods=["POST"])
def inserir_sub_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        categoria = request.form["categoria"]
        super_categoria = request.form["super_categoria"]
        query =""" 
        BEGIN TRANSACTION;
            DO $$
            DECLARE 
                cat varchar(80) = %s;
                super_cat varchar(80) = %s;
            BEGIN
                IF cat IN(
                    SELECT category FROM has_other
                )
                THEN    
                    RAISE EXCEPTION 'Category already has super';         
                END IF;  
                IF cat NOT IN(
                    SELECT category_name FROM category
                )
                THEN 
                    INSERT INTO category VALUES (cat);
                    INSERT INTO simple_category VALUES (cat);  
                END IF;     
                IF super_cat IN(
                    SELECT simple_name FROM simple_category
                )
                THEN 
                    DELETE FROM simple_category
                        WHERE simple_name = super_cat;
                    INSERT INTO super_category VALUES (super_cat);
                END IF;
                INSERT INTO has_other VALUES(cat, super_cat);    
            END;
            $$ LANGUAGE plpgsql; 
        COMMIT;"""
        data = (categoria, super_categoria)
        cursor.execute(query, data)
        return redirect("/ist197343/app.cgi/")
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
        return redirect("/ist197343/app.cgi/")
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
def inserir_retalhista():
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
        return redirect("/ist197343/app.cgi/")
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/escolhe_ivm")
def escolher_ivm():
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
    cursor2 = None
    cursor1 = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor1 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor2 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        ivm = request.form["ivm"]
        ivm_list = ivm.split(" ")
        manuf = ivm_list[1]
        serial = ivm_list[0]
        query1 = """SELECT *
                    FROM replenishment_event
                    WHERE serial_number = %s AND manufacturer=%s
                 """
        query2 = """SELECT cat, SUM(units)
                    FROM replenishment_event NATURAL JOIN has_category
                    WHERE serial_number = %s AND manufacturer=%s
                    GROUP BY cat;              
                """
        data = (serial, manuf)
        cursor1.execute(query1, data)
        cursor2.execute(query2, data)
        return render_template("lista_er.html", cursor1=cursor1, cursor2=cursor2, ivm=ivm)
    except Exception as e:
        return render_template("error.html", error_message=e) 
    finally:
        dbConn.commit()
        cursor1.close()
        cursor2.close()
        dbConn.close()

@app.route("/escolhe_categoria")
def escolher_categoria():
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