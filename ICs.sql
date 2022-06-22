/*
    ------------------------------------------------------------------------------
    # (RI-1) Uma Categoria não pode estar contida em si própria
    ------------------------------------------------------------------------------
*/
CREATE OR REPLACE FUNCTION is_autoreferenced()
RETURNS TRIGGER AS
$$
    BEGIN
          IF NEW.category = NEW.super_category THEN
                RAISE EXCEPTION 'Autoreferencing category';
          END IF;
    RETURN NEW;
    END;
$$ LANGUAGE plpgsql; 

CREATE TRIGGER is_autoreferenced
BEFORE UPDATE OR INSERT ON category
FOR EACH ROW EXECUTE PROCEDURE is_autoreferenced();

/*
    ------------------------------------------------------------------------------
    # (RI-2) O número de unidades repostas num Evento de Reposição não pode 
    # exceder o número de unidades especificado no Planograma
    ------------------------------------------------------------------------------
*/
CREATE OR REPLACE FUNCTION handle_product_overflow_trigger()
RETURNS TRIGGER AS
$$
DECLARE max_units INTEGER;
BEGIN
        SELECT units INTO max_units
        FROM planogram 
        WHERE ean = NEW.ean
             AND nro = NEW.nro 
             AND serial_number = NEW.serial_number 
             AND manufacturer = NEW.manufacturer;

        IF NEW.units > max_units THEN 
            RAISE EXCEPTION 'Adding more units that specified in planogram'; 
        END IF;
END;
$$ LANGUAGE plpgsql; 

CREATE TRIGGER handle_product_overflow_trigger
BEFORE UPDATE OR INSERT ON shelve
FOR EACH ROW EXECUTE PROCEDURE handle_product_overflow_trigger();

/*
    ------------------------------------------------------------------------------
    # (RI-5) Um Produto só pode ser reposto numa Prateleira que apresente 
    # (pelo menos) uma das Categorias desse produto
    ------------------------------------------------------------------------------
*/

CREATE OR REPLACE FUNCTION handle_product_replenishment_trigger()
RETURNS TRIGGER AS
$$
    BEGIN
        IF NOT EXISTS  (
            SELECT cat
            FROM has_category
            WHERE ean = NEW.ean
            INTERSECT
            SELECT category_name 
            FROM shelve 
            WHERE nro = NEW.nro 
                AND serial_number = NEW.serial_number
                AND manufacturer = NEW.manufacturer
        )

        THEN 
            RAISE EXCEPTION 'The shelve does not display any of the product''s categories'; 
        END IF;
    END
$$ LANGUAGE plpgsql;


CREATE TRIGGER handle_product_replenishment_trigger
BEFORE UPDATE OR INSERT ON planogram
FOR EACH ROW EXECUTE PROCEDURE handle_product_replenishment_trigger();
