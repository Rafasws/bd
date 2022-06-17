drop table category cascade;
drop table simple_category cascade;
drop table super_category cascade;
drop table has_other cascade;
drop table product cascade;
drop table has_category cascade;
drop table ivm cascade;
drop table instaled_at cascade;
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
    (category_name 	varchar(80)	not null unique,
    constraint pk_category primary key(category_name));

CREATE TABLE simple_category
    (simple_name 	varchar(80)	not null unique,
    constraint pk_simple_category primary key(simple_name),
    constraint fk_simple_category foreign key(simple_name) references category(category_name));

CREATE TABLE super_category
    (super_name 	varchar(80)	not null unique,
    constraint pk_super_category primary key(super_name),
    constraint fk_super_category foreign key(super_name) references category(category_name));

CREATE TABLE has_other
    (category 	varchar(80)	not null unique,
     super_category 	varchar(80)	not null,
     constraint pk_has_other primary key(category),
     constraint fk_has_other_category foreign key(category) references category(category_name),
     constraint fk_has_other_super_category foreign key(super_category) references super_category(super_name));

CREATE TABLE product
    (ean 	integer not null unique,
     cat varchar(80) not null,
     descr varchar(500) not null,
     constraint pk_product_ean primary key(ean),
     constraint fk_product_category foreign key(cat) references category(category_name));


CREATE TABLE has_category
    (ean integer not null unique,
     cat varchar(80) not null unique,
     constraint fk_has_category_ean foreign key(ean) references product(ean),
     constraint fk_has_category_cat foreign key(cat) references category(category_name));


CREATE TABLE ivm
    (serial_number 	integer not null,
     manufacturer varchar(80) not null,
     constraint pk_ivm primary key(serial_number, manufacturer));


CREATE TABLE retail_point
    (retail_name 	varchar(80) not null unique,
     district       varchar(80) not null,
     council        varchar(80) not null,
     constraint pk_retail_point primary key(retail_name));


CREATE TABLE instaled_at
    (serial_number 	integer not null,
     manufacturer   varchar(80) not null,
     retail_point   varchar(80) not null,
     constraint pk_instaled_at primary key(serial_number, manufacturer),
     constraint fk_instaled_at_serial_number foreign key(serial_number, manufacturer) references ivm(serial_number, manufacturer),
     constraint fk_instaled_at_retail_point foreign key(retail_point) references retail_point(retail_name));

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
    (tin integer not null unique,
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