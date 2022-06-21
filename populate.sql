drop table category cascade;
drop table simple_category cascade;
drop table super_category cascade;
drop table has_other cascade;
drop table product cascade;
drop table has_category cascade;
drop table ivm cascade;
drop table installed_at cascade;
drop table retail_point cascade;
drop table shelve cascade;
drop table planogram cascade;
drop table retailer cascade;
drop table responsible_for cascade;
drop table replenishment_event cascade;

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


insert into category values ('Sandes');
insert into category values ('Sandes Baguete');
insert into category values ('Sandes Pão-forma');
insert into category values ('Bebidas');
insert into category values ('Sumos');
insert into category values ('Batidos');
insert into category values ('Refrigerantes');
insert into category values ('Refrigerantes sem gás');
insert into category values ('Refrigerantes com gás');
insert into category values ('Fruta');

insert into simple_category values ('Sandes Baguete');
insert into simple_category values ('Sandes Pão-forma');
insert into simple_category values ('Sumos');
insert into simple_category values ('Batidos');
insert into simple_category values ('Refrigerantes sem gás');
insert into simple_category values ('Refrigerantes com gás');
insert into simple_category values ('Fruta');

insert into super_category values ('Sandes');
insert into super_category values ('Bebidas');
insert into super_category values ('Refrigerantes');

insert into has_other values ('Sandes Baguete','Sandes');
insert into has_other values ('Sandes Pão-forma','Sandes');
insert into has_other values ('Sumos','Bebidas');
insert into has_other values ('Batidos','Bebidas');
insert into has_other values ('Refrigerantes sem gás','Refrigerantes');
insert into has_other values ('Refrigerantes com gás','Refrigerantes');
insert into has_other values ('Refrigerantes','Bebidas');

insert into product values (1,'Sandes Baguete', 'ATUM');
insert into product values (2,'Sandes Baguete', 'FRANGO');
insert into product values (3,'Sumos', 'COMPAL');
insert into product values (4,'Sumos', 'NECTAR');
insert into product values (5,'Refrigerantes sem gás', 'ICETEA PESSEGO');
insert into product values (6,'Refrigerantes sem gás', 'ICETEA LIMÃO');
insert into product values (7,'Refrigerantes com gás', 'COCA-COLA');
insert into product values (8,'Refrigerantes com gás', 'SUMOL');
insert into product values (9,'Refrigerantes com gás', '7-UP');
insert into product values (10,'Fruta', 'MAÇA');
insert into product values (11,'Fruta', 'BANANA');
insert into product values (12,'Fruta', 'MARACUJÁ');
insert into product values (13,'Fruta', 'PHYSALLIS');

insert into has_category values (12,'Fruta');

insert into ivm values (55555,'ROLLS-ROYCE');
insert into ivm values (12345,'ROLLS-ROYCE');

insert into retail_point values ('GALP','Lisboa', 'Arieiro');
insert into retail_point values ('BP','Porto', 'Porto');

insert into installed_at values (55555,'ROLLS-ROYCE', 'GALP');
insert into installed_at values (12345,'ROLLS-ROYCE', 'BP');

insert into shelve values (1, 55555, 'ROLLS-ROYCE', 'Fruta', 50);
insert into shelve values (2, 55555, 'ROLLS-ROYCE', 'Sandes', 50);
insert into shelve values (1, 12345, 'ROLLS-ROYCE', 'Sandes', 50);
insert into shelve values (2, 12345, 'ROLLS-ROYCE', 'Bebidas', 50);

insert into planogram values (12, 1, 55555, 'ROLLS-ROYCE', 2, 10, 'location');

insert into retailer values (1, 'João Maria');
insert into retailer values (2, 'José Manel');

insert into responsible_for values ('Sandes Baguete', 1, 55555,'ROLLS-ROYCE');
/*
insert into responsible_for values ('Sandes Pão-forma', 1, 55555,'ROLLS-ROYCE');
insert into responsible_for values ('Sumos', 1, 55555,'ROLLS-ROYCE');
insert into responsible_for values ('Batidos', 1, 55555,'ROLLS-ROYCE');
insert into responsible_for values ('Refrigerantes sem gas', 1, 55555,'ROLLS-ROYCE');
insert into responsible_for values ('Refrigerantes com gas', 1, 55555,'ROLLS-ROYCE');
insert into responsible_for values ('Frutas', 1, 55555,'ROLLS-ROYCE');
insert into responsible_for values ('Sandes', 2, 12345,'ROLLS-ROYCE');
insert into responsible_for values ('Bebidas', 2, 12345,'ROLLS-ROYCE');
*/

insert into replenishment_event values (12, 1 ,55555, 'ROLLS-ROYCE', 10, 1, '08-Jan-1999');

/*
    -----------------------------------------------------------------------------
    # PSM
    -----------------------------------------------------------------------------
*/

DROP FUNCTION trigger_delete_from_category();

CREATE FUNCTION trigger_delete_from_category()
RETURNS TRIGGER AS
$$
    BEGIN
          DELETE FROM has_other
          WHERE category IN (
            SELECT * 
            FROM has_other
            WHERE super_category=OLD.category_name);
          
          DELETE FROM category
          WHERE category_name IN (
            SELECT * 
            FROM has_other
            WHERE super_category=OLD.category_name);


    RETURN NEW; 
    END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE TRIGGER trigger_delete_from_category
BEFORE DELETE ON category
FOR EACH ROW EXECUTE PROCEDURE trigger_delete_from_category();
