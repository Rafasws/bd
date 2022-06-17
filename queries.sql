/*
    ------------------------------------------------------------------------------
    # (Qual o nome do retalhista (ou retalhistas) responsáveis pela reposição do maior 
    # número de categorias?
    ------------------------------------------------------------------------------
*/
SELECT retailer_name, amount 
FROM 
    (SELECT r.retailer_name AS retailer_name, COUNT(*) AS amount
     FROM retailer r JOIN replenishment_event e
        BY r.tin = e.tin
     GROUP BY r.retailer_name)
WHERE amount = (
    SELECT MAX(amount)
    FROM 
    .... INCOMPLETO
)


/*
    ------------------------------------------------------------------------------
    # Qual o nome do ou dos retalhistas que são responsáveis por todas as 
    # categorias simples?
    ------------------------------------------------------------------------------
*/

SELECT retailer_name 
    (
    SELECT retailer_name, COUNT(*) as num_of_categories
    FROM responsible_for rf JOIN retailer r JOIN simple_category c
        BY rf.tin = r.tin AND rf.category_name = c.category_name
    GROUP BY retailer_name
    WHERE num_of_categories = (
        SELECT MAX(num_of_categories)
        .... INCOMPLETO        
    )
/*
    ------------------------------------------------------------------------------
    # Quais os produtos (ean) que nunca foram repostos?
    ------------------------------------------------------------------------------
*/
SELECT ean 
FROM 
    (
        SELECT ean AS e
        FROM replenishment_event
    )
WHERE ean NOT IN e


/*
    ------------------------------------------------------------------------------
    # Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista?
    ------------------------------------------------------------------------------
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