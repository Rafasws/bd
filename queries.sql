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
FROM 
    (
        SELECT ean AS e
        FROM replenishment_event
    )
WHERE ean NOT IN e


/*
    -----------------------------------------------------------------------------
    # Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista?
    -----------------------------------------------------------------------------
*/

SELECT ean, COUNT(*) AS num_of_retailers
FROM (
    SELECT ean, COUNT(*)
    FROM replenishment_event e JOIN product p JOIN retailer r
        BY e.ean = p.ean AND r.tin = e.tin
    GROUP BY p.ean, r.tin
)
GROUP BY ean
WHERE num_of_retailers = 1