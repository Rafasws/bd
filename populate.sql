DROP TABLE category cascade;
DROP TABLE simple_category cascade;
DROP TABLE super_category cascade;
DROP TABLE has_other cascade;
DROP TABLE product cascade;
DROP TABLE has_category cascade;
DROP TABLE ivm cascade;
DROP TABLE installed_at cascade;
DROP TABLE retail_point cascade;
DROP TABLE shelve cascade;
DROP TABLE planogram cascade;
DROP TABLE retailer cascade;
DROP TABLE responsible_for cascade;
DROP TABLE replenishment_event cascade;

----------------------------------------
-- Table Creation
----------------------------------------

CREATE TABLE category
    (category_name 	varchar(80),
    constraint pk_category primary key(category_name));

CREATE TABLE simple_category
    (simple_name 	varchar(80),
    constraint pk_simple_category primary key(simple_name),
    constraint fk_simple_category foreign key(simple_name) references category(category_name));

CREATE TABLE super_category
    (super_name 	varchar(80),
    constraint pk_super_category primary key(super_name),
    constraint fk_super_category foreign key(super_name) references category(category_name));

CREATE TABLE has_other
    (category 	varchar(80),
     super_category 	varchar(80)	not null,
     constraint pk_has_other primary key(category),
     constraint fk_has_other_category foreign key(category) references category(category_name),
     constraint fk_has_other_super_category foreign key(super_category) references super_category(super_name));

CREATE TABLE product
    (ean integer,
     cat varchar(80) not null,
     descr varchar(500) not null,
     constraint pk_product_ean primary key(ean),
     constraint fk_product_category foreign key(cat) references category(category_name));


CREATE TABLE has_category
    (ean integer not null,
     cat varchar(80) not null,
     constraint pk_has_category primary key(ean, cat),
     constraint fk_has_category_ean foreign key(ean) references product(ean),
     constraint fk_has_category_cat foreign key(cat) references category(category_name));


CREATE TABLE ivm
    (serial_number 	integer not null,
     manufacturer varchar(80) not null,
     constraint pk_ivm primary key(serial_number, manufacturer));


CREATE TABLE retail_point
    (retail_name 	varchar(80),
     district       varchar(80) not null,
     council        varchar(80) not null,
     constraint pk_retail_point primary key(retail_name));


CREATE TABLE installed_at
    (serial_number 	integer not null,
     manufacturer   varchar(80) not null,
     retail_point   varchar(80) not null,
     constraint pk_installed_at primary key(serial_number, manufacturer),
     constraint fk_installed_at_serial_number foreign key(serial_number, manufacturer) references ivm(serial_number, manufacturer),
     constraint fk_installed_at_retail_point foreign key(retail_point) references retail_point(retail_name));

CREATE TABLE shelve
    (nro varchar(80) not null,
     serial_number integer not null,
     manufacturer varchar(80) not null,
     category_name varchar(80)	not null,
     heigth  numeric(16,4) not null,
     constraint pk_shelve primary key(nro, serial_number, manufacturer),
     constraint fk_shelve_serial_number foreign key(serial_number, manufacturer) references ivm(serial_number, manufacturer),
     constraint fk_shelve_category_name foreign key(category_name) references category(category_name));


CREATE TABLE planogram 
    (ean integer not null,
    nro varchar(80) not null,
    serial_number integer not null,
    manufacturer   varchar(80) not null,
    faces integer not null,
    units integer not null,
    loc varchar(80) not null,
    constraint pk_planogram primary key(ean, nro, serial_number, manufacturer),
    constraint fk_planogram_ean foreign key(ean) references product(ean),
    constraint fk_planogram_shelve foreign key(nro, serial_number, manufacturer) references shelve(nro, serial_number, manufacturer));

CREATE TABLE retailer
    (tin integer,
    retailer_name varchar(80) not null unique,
    constraint pk_retailer primary key(tin));

CREATE TABLE responsible_for
    (category_name varchar(80) not null,
    tin integer not null,
    serial_number integer not null,
    manufacturer   varchar(80) not null,
    constraint pk_responsible_for primary key(serial_number, manufacturer),
    constraint fk_responsible_for_category foreign key(category_name) references category(category_name),
    constraint fk_responsible_for_ivm foreign key(serial_number, manufacturer) references ivm(serial_number, manufacturer),
    constraint fk_responsible_retailer foreign key(tin) references retailer(tin));


CREATE TABLE replenishment_event
    (ean integer not null,
    nro varchar(80) not null,
    serial_number integer not null,
    manufacturer   varchar(80) not null,
    units integer not null,
    tin integer not null,
    instant timestamp not null,
    constraint pk_replenishment_event primary key(ean, nro, serial_number, manufacturer, instant),
    constraint fk_replenishment_event_planogram foreign key(ean, nro, serial_number, manufacturer) references planogram(ean, nro, serial_number, manufacturer),
    constraint fk_responsible_for_retailer foreign key(tin) references retailer(tin));


INSERT INTO category VALUES ('Sandes');
INSERT INTO category VALUES ('Sandes Baguete');
INSERT INTO category VALUES ('Sandes Pão-forma');
INSERT INTO category VALUES ('Bebidas');
INSERT INTO category VALUES ('Sumos');
INSERT INTO category VALUES ('Batidos');
INSERT INTO category VALUES ('Refrigerantes');
INSERT INTO category VALUES ('Refrigerantes sem gás');
INSERT INTO category VALUES ('Refrigerantes com gás');
INSERT INTO category VALUES ('Fruta');

INSERT INTO simple_category VALUES ('Sandes Baguete');
INSERT INTO simple_category VALUES ('Sandes Pão-forma');
INSERT INTO simple_category VALUES ('Sumos');
INSERT INTO simple_category VALUES ('Batidos');
INSERT INTO simple_category VALUES ('Refrigerantes sem gás');
INSERT INTO simple_category VALUES ('Refrigerantes com gás');
INSERT INTO simple_category VALUES ('Fruta');

INSERT INTO super_category VALUES ('Sandes');
INSERT INTO super_category VALUES ('Bebidas');
INSERT INTO super_category VALUES ('Refrigerantes');

INSERT INTO has_other VALUES ('Sandes Baguete','Sandes');
INSERT INTO has_other VALUES ('Sandes Pão-forma','Sandes');
INSERT INTO has_other VALUES ('Sumos','Bebidas');
INSERT INTO has_other VALUES ('Batidos','Bebidas');
INSERT INTO has_other VALUES ('Refrigerantes sem gás','Refrigerantes');
INSERT INTO has_other VALUES ('Refrigerantes com gás','Refrigerantes');
INSERT INTO has_other VALUES ('Refrigerantes','Bebidas');

INSERT INTO product VALUES (1,'Sandes Baguete', 'ATUM');
INSERT INTO product VALUES (2,'Sandes Baguete', 'FRANGO');
INSERT INTO product VALUES (3,'Sumos', 'COMPAL');
INSERT INTO product VALUES (4,'Sumos', 'NECTAR');
INSERT INTO product VALUES (5,'Refrigerantes sem gás', 'ICETEA PESSEGO');
INSERT INTO product VALUES (6,'Refrigerantes sem gás', 'ICETEA LIMÃO');
INSERT INTO product VALUES (7,'Refrigerantes com gás', 'COCA-COLA');
INSERT INTO product VALUES (8,'Refrigerantes com gás', 'SUMOL');
INSERT INTO product VALUES (9,'Refrigerantes com gás', '7-UP');
INSERT INTO product VALUES (10,'Fruta', 'MAÇA');
INSERT INTO product VALUES (11,'Fruta', 'BANANA');
INSERT INTO product VALUES (12,'Fruta', 'MARACUJÁ');
INSERT INTO product VALUES (13,'Fruta', 'PHYSALLIS');

INSERT INTO has_category VALUES (1,'Sandes Baguete');
INSERT INTO has_category VALUES (1,'Sandes Pão-forma');
INSERT INTO has_category VALUES (2,'Sandes Baguete');
INSERT INTO has_category VALUES (2,'Sandes Pão-forma');
INSERT INTO has_category VALUES (3,'Sumos');
INSERT INTO has_category VALUES (4,'Sumos');
INSERT INTO has_category VALUES (5,'Refrigerantes sem gás');
INSERT INTO has_category VALUES (6,'Refrigerantes sem gás');
INSERT INTO has_category VALUES (7,'Refrigerantes com gás');
INSERT INTO has_category VALUES (8,'Refrigerantes com gás');
INSERT INTO has_category VALUES (9,'Refrigerantes com gás');
INSERT INTO has_category VALUES (10,'Fruta');
INSERT INTO has_category VALUES (11,'Fruta');
INSERT INTO has_category VALUES (12,'Fruta');
INSERT INTO has_category VALUES (13,'Fruta');

INSERT INTO ivm VALUES (11111, 'MCLAREN');
INSERT INTO ivm VALUES (22222, 'ROLLS-ROYCE');
INSERT INTO ivm VALUES (33333, 'ROLLS-ROYCE');
INSERT INTO ivm VALUES (44444, 'ROLLS-ROYCE');
INSERT INTO ivm VALUES (44444, 'BENTLEY');
INSERT INTO ivm VALUES (55555, 'BENTLEY');
INSERT INTO ivm VALUES (66666, 'BENTLEY');
INSERT INTO ivm VALUES (77777, 'BENTLEY');
INSERT INTO ivm VALUES (88888, 'BENTLEY');

INSERT INTO retail_point VALUES ('GALP', 'Lisboa', 'Arieiro');
INSERT INTO retail_point VALUES ('BP', 'Porto', 'Baião');

INSERT INTO installed_at VALUES (11111, 'MCLAREN', 'GALP');
INSERT INTO installed_at VALUES (22222, 'ROLLS-ROYCE', 'GALP');
INSERT INTO installed_at VALUES (33333, 'ROLLS-ROYCE', 'GALP');
INSERT INTO installed_at VALUES (44444, 'ROLLS-ROYCE', 'BP');
INSERT INTO installed_at VALUES (44444, 'BENTLEY', 'BP');
INSERT INTO installed_at VALUES (55555, 'BENTLEY', 'BP');
INSERT INTO installed_at VALUES (66666, 'BENTLEY', 'BP');
INSERT INTO installed_at VALUES (77777, 'BENTLEY', 'BP');

INSERT INTO shelve VALUES (1, 44444, 'ROLLS-ROYCE', 'Fruta', 50);
INSERT INTO shelve VALUES (2, 44444, 'ROLLS-ROYCE', 'Sandes Pão-forma', 50);
INSERT INTO shelve VALUES (1, 33333, 'ROLLS-ROYCE', 'Sandes Pão-forma', 50);
INSERT INTO shelve VALUES (2, 33333, 'ROLLS-ROYCE', 'Sumos', 50);

INSERT INTO planogram VALUES (13, 1, 44444, 'ROLLS-ROYCE', 2, 10, 'location');
INSERT INTO planogram VALUES (1, 2, 44444, 'ROLLS-ROYCE', 2, 10, 'location');
INSERT INTO planogram VALUES (1, 1, 33333, 'ROLLS-ROYCE', 1, 10, 'location');
INSERT INTO planogram VALUES (3, 2, 33333, 'ROLLS-ROYCE', 2, 10, 'location');
INSERT INTO planogram VALUES (4, 2, 33333, 'ROLLS-ROYCE', 2, 10, 'location');

INSERT INTO retailer VALUES (1, 'João Maria');
INSERT INTO retailer VALUES (2, 'José Manel');

INSERT INTO responsible_for VALUES ('Sandes Baguete', 1, 11111, 'MCLAREN');
INSERT INTO responsible_for VALUES ('Sandes Pão-forma', 1, 22222, 'ROLLS-ROYCE');
INSERT INTO responsible_for VALUES ('Sumos', 1, 33333,'ROLLS-ROYCE');
INSERT INTO responsible_for VALUES ('Batidos', 1, 44444,'ROLLS-ROYCE');
INSERT INTO responsible_for VALUES ('Refrigerantes sem gás', 1, 44444,'BENTLEY');
INSERT INTO responsible_for VALUES ('Refrigerantes com gás', 1, 55555,'BENTLEY');
INSERT INTO responsible_for VALUES ('Fruta', 1, 66666,'BENTLEY');
INSERT INTO responsible_for VALUES ('Refrigerantes sem gás', 2, 77777,'BENTLEY');

INSERT INTO replenishment_event VALUES (13, 1, 44444, 'ROLLS-ROYCE', 10, 1, '08-Jan-1999');
INSERT INTO replenishment_event VALUES (1, 2, 44444, 'ROLLS-ROYCE', 9, 1, '08-Jan-1999');
INSERT INTO replenishment_event VALUES (1, 2, 44444, 'ROLLS-ROYCE', 9, 1, '10-Jan-1999');
INSERT INTO replenishment_event VALUES (1, 1, 33333, 'ROLLS-ROYCE', 8, 1, '08-Jan-1999');
INSERT INTO replenishment_event VALUES (3, 2, 33333, 'ROLLS-ROYCE', 10, 1, '08-Jan-1999');
INSERT INTO replenishment_event VALUES (3, 2, 33333, 'ROLLS-ROYCE', 9, 1, '09-Jan-1999');
INSERT INTO replenishment_event VALUES (3, 2, 33333, 'ROLLS-ROYCE', 10, 1, '10-Jan-1999');
INSERT INTO replenishment_event VALUES (4, 2, 33333, 'ROLLS-ROYCE', 7, 2, '08-Jan-1999');
/*
    -----------------------------------------------------------------------------
    # PSM
    -----------------------------------------------------------------------------
*/
CREATE OR REPLACE FUNCTION trigger_delete_from_category()
RETURNS TRIGGER AS
$$
    DECLARE sub_cats varchar(80)[] = (
            SELECT ARRAY_AGG(category) 
            FROM has_other
            WHERE super_category = OLD.category_name);
    BEGIN
        
        DELETE FROM responsible_for
        WHERE category_name = OLD.category_name;
        
        WITH products_to_be_deleted AS(
            SELECT ean 
            FROM product
            WHERE cat = OLD.category_name
            INTERSECT
            SELECT ean
            FROM has_category
            GROUP BY ean
            HAVING COUNT(*)=1
        ), shelves_to_be_deleted AS(
            SELECT nro, serial_number, manufacturer
            FROM shelve
            WHERE category_name = OLD.category_name 
        )
        DELETE FROM replenishment_event
        WHERE ean IN(
            SELECT ean FROM products_to_be_deleted
        ) 
            OR (nro, serial_number, manufacturer) IN(
                SELECT * FROM shelves_to_be_deleted
            );

         WITH products_to_be_deleted AS(
            SELECT ean 
            FROM product
            WHERE cat = OLD.category_name
            INTERSECT
            SELECT ean
            FROM has_category
            GROUP BY ean
            HAVING COUNT(*)=1
        ), shelves_to_be_deleted AS(
            SELECT nro, serial_number, manufacturer
            FROM shelve
            WHERE category_name = OLD.category_name 
        )   
        DELETE FROM planogram
       WHERE ean IN(
            SELECT ean FROM products_to_be_deleted
        ) 
            OR (nro, serial_number, manufacturer) IN(
                SELECT * FROM shelves_to_be_deleted
            );
        
        DELETE FROM shelve 
        WHERE category_name = OLD.category_name;

        DELETE FROM has_other
        WHERE super_category = OLD.category_name;

        DELETE FROM has_category 
        WHERE cat = OLD.category_name; 
        
        UPDATE product 
        SET cat = COALESCE(
            (SELECT DISTINCT ON(ean) cat 
            FROM has_category 
            WHERE ean = product.ean),
            product.cat
        ) 
        WHERE cat = OLD.category_name;

        DELETE FROM product
        WHERE cat = OLD.category_name;
        
        DELETE FROM super_category
        WHERE super_name = OLD.category_name;

        DELETE FROM simple_category
        WHERE simple_name = OLD.category_name;
          
        DELETE FROM category
        WHERE category_name = ANY(sub_cats);

    RETURN OLD; 
    END;
$$ LANGUAGE plpgsql; 

CREATE TRIGGER trigger_delete_from_category
BEFORE DELETE ON category
FOR EACH ROW EXECUTE PROCEDURE trigger_delete_from_category();