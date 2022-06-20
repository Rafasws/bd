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
