/*
    -----------------------------------------------------------------------------
    # (Qual o nome do retalhista (ou retalhistas) responsáveis pela reposição do maior 
    # número de categorias?
    -----------------------------------------------------------------------------
*/
SELECT retailer_name, COUNT(DISTINCT category_name)
FROM responsible_for NATURAL JOIN retailer
GROUP BY retailer_name  -- works because reatailer_name is unique on retailer relation
HAVING COUNT(DISTINCT category_name) >= ALL(
    SELECT COUNT(DISTINCT category_name)
    FROM responsible_for 
    GROUP BY tin
);


/*
    -----------------------------------------------------------------------------
    # Qual o nome do ou dos retalhistas que são responsáveis por todas as 
    # categorias simples?
    -----------------------------------------------------------------------------
*/
SELECT DISTINCT retailer_name
FROM responsible_for R NATURAL JOIN retailer 
WHERE NOT EXISTS(
    SELECT simple_name 
    FROM simple_category
    EXCEPT
    SELECT category_name
    FROM responsible_for RF
    WHERE RF.tin = R.tin
);


/*
    -----------------------------------------------------------------------------
    # Quais os produtos (ean) que nunca foram repostos?
    -----------------------------------------------------------------------------
*/
SELECT ean 
FROM product
EXCEPT
SELECT ean 
FROM replenishment_event;


/*
    -----------------------------------------------------------------------------
    # Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista?
    -----------------------------------------------------------------------------
*/
SELECT ean 
FROM replenishment_event
GROUP BY ean
HAVING COUNT(DISTINCT tin) = 1;