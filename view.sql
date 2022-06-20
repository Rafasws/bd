CREATE VIEW Sales(ean, cat, year, quarter, day_of_month, day_of_week, district, council, units) AS
SELECT p.ean, p.cat, EXTRACT(YEAR FROM re.instant) AS year, EXTRACT(QUARTER FROM re.instant) AS quarter, EXTRACT(DAY FROM re.instant) AS day_of_month, EXTRACT(DOW FROM re.instant) AS day_of_week, rp.district, rp.council, re.units 
FROM replenishment_event RE 
NATURAL JOIN installed_at IA
NATURAL JOIN product P
JOIN retail_point RP ON RP.retail_name = IA.retail_point;