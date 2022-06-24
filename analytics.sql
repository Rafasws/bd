/*
    ------------------------------------------------------------------------------
    # 1. num dado período (i.e. entre duas datas), por dia da semana, 
    #  por concelho e no total
    ------------------------------------------------------------------------------
*/

SELECT day_of_week, council, SUM(units) AS sales
FROM Sales
WHERE 
    TO_TIMESTAMP(year||'-'||month||'-'||day_of_month, 'YYYY-MM-DD') 
        >= TIMESTAMP '1999-01-01 00:00:00' 
    AND 
    TO_TIMESTAMP(year||'-'||month||'-'||day_of_month, 'YYYY-MM-DD') 
        < TIMESTAMP '1999-06-24 00:00:00' 
GROUP BY 
    GROUPING SETS(
        (day_of_week), 
        (council),
        ()
    );

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
GROUP BY 
    GROUPING SETS(
        (council, cat, day_of_week),
        ()
    );

