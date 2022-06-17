CREATE OR REPLACE FUNCTION chk_cat_autoreferenced()
RETURNS TRIGGER AS
$$
    BEGIN
          IF NEW.category = NEW.super_category THEN
                RAISE EXCEPTION 'Autoreferencing category'; 
          END IF;
          RETURN NEW;
    END;
$$ LANGUAGE plpgsql; 

CREATE TRIGGER cat_autoreferenced_trigger
BEFORE INSERT ON has_other  
FOR EACH ROW EXECUTE PROCEDURE chk_cat_autoreferenced();

CREATE OR REPLACE FUNCTION chk_product_overflow()
RETURNS TRIGGER AS
$$
DECLARE max_units INTEGER;
BEGIN
        SELECT units INTO max_units
        FROM planogram 
        WHERE ean=NEW.ean 
            AND nro=NEW.nro 
            AND serial_number=NEW.serial_number 
            AND manufacturer=NEW.manufacturer;

        IF NEW.units > max_units THEN 
            RAISE EXCEPTION 'Adding more units than specified in planogram'; 
        END IF;
    END;
$$ LANGUAGE plpgsql; 

CREATE TRIGGER product_overflow_trigger
BEFORE INSERT ON replenishment_event  
FOR EACH ROW EXECUTE PROCEDURE chk_product_overflow();
