CREATE VIEW Sales(ean, cat, year, quarter, day_of_month, day_of_week, district, council, units) AS
SELECT p.ean, p.cat, EXTRACT(YEAR FROM re.instant) AS year, EXTRACT(QUARTER FROM re.instant) AS quarter, EXTRACT(DAY FROM re.instant) AS day_of_month, EXTRACT(DOW FROM re.instant) AS day_of_week, rp.district, rp.council, re.units 
FROM replenishment_event re 
NATURAL JOIN instaled_at ia
NATURAL JOIN product p
JOIN retail_point rp ON rp.retail_name = ia.retail_point;