
CREATE TABLE obiekty(
	ID SERIAL PRIMARY KEY, 
	nazwa VARCHAR(20) NOT NULL, 
	geom GEOMETRY NOT NULL);

INSERT INTO obiekty(nazwa, geom) VALUES 
('obiekt1', ST_GeomFromEWKT( 'COMPOUNDCURVE( (0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1), CIRCULARSTRING(3 1, 4 2, 5 1), (5 1, 6 1))' )),
('obiekt2', ST_GeomFromEWKT( 'CURVEPOLYGON( COMPOUNDCURVE( (10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), CIRCULARSTRING(14 2, 12 0, 10 2), (10 2, 10 6)),COMPOUNDCURVE( CIRCULARSTRING(11 2, 12 3, 13 2), CIRCULARSTRING(13 2, 12 1, 11 2)))')),
('obiekt3', ST_GeomFromEWKT( 'TRIANGLE((7 15, 10 17, 12 13, 7 15))')),
('obiekt4', ST_GeomFromEWKT( 'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')),
('obiekt5', ST_GeomFromEWKT( 'MULTIPOINT((30 30 59), (38 32 234)')),
('obiekt6', ST_GeomFromEWKT( 'GEOMETRYCOLLECTION( LINESTRING(1 1, 3 2), POINT(4 2) )'));

SELECT ST_CurveToLine(geom) FROM obiekty;
DROP TABLE obiekty;
-- 1.

SELECT ST_Area(ST_Buffer(ST_ShortestLine
((SELECT geom FROM obiekty WHERE nazwa='obiekt3'),
(SELECT geom FROM obiekty WHERE nazwa='obiekt4')),5));
						 

-- 2.

UPDATE obiekty SET geom=ST_MakePolygon
(ST_LineMerge(ST_Union(geom, 'MULTILINESTRING((20.5 19.5, 20 20))')))
WHERE nazwa='obiekt4';


-- 3.
INSERT INTO obiekty(nazwa, geom) VALUES
('obiekt7', ST_Collect((SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'), (SELECT geom FROM obiekty WHERE nazwa = 'obiekt4')));


-- 4.

WITH Pbezlukow AS
(SELECT ST_Union(ARRAY(SELECT geom FROM obiekty
WHERE NOT ST_HasArc(geom))) as geom)
SELECT ST_Area(ST_Buffer(geom, 5))
FROM Pbezlukow;