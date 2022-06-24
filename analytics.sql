/*
    ------------------------------------------------------------------------------
    # 1. num dado período (i.e. entre duas datas), por dia da semana, 
    #  por concelho e no total
    ------------------------------------------------------------------------------
*/

/*
    ------------------------------------------------------------------------------
    #                       (V1)
    ------------------------------------------------------------------------------
*/

SELECT day_of_week, council, SUM(units) AS sales
FROM Sales
WHERE 
    year >= 1999 AND quarter >= 1
    AND
    year <= 2000 AND quarter <= 3
GROUP BY CUBE(day_of_week, council);

/*
    ------------------------------------------------------------------------------
    # 2.num dado distrito (i.e. “Lisboa”), por concelho, categoria, dia da 
    # semana e no total
    ------------------------------------------------------------------------------
*/

SELECT council, cat, day_of_week, SUM(units) AS sales
FROM Sales NATURAL JOIN product
WHERE 
    district = 'Lisboa'
GROUP BY CUBE(council, cat, day_of_week);

