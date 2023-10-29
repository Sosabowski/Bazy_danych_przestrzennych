--1. 
WITH 
NBudynki AS ( --Nowe Budynki
	SELECT kar19.* FROM t2019_kar_buildings kar19
	LEFT JOIN t2018_kar_buildings kar18 USING (polygon_id)
	WHERE kar18.polygon_id IS NULL
),
ReBudynki AS ( --Wyremontowane budynki
	SELECT kar19.* FROM t2018_kar_buildings kar18, t2019_kar_buildings kar19
	WHERE kar18.polygon_id = kar19.polygon_id
	AND (kar18.height <> kar19.height OR NOT ST_Equals(kar18.geom, kar19.geom))
)
SELECT * INTO tnowe_kar_buildings FROM NBudynki UNION
SELECT * FROM ReBudynki;

SELECT * FROM tnowe_kar_buildings;



--2. 
WITH
NPunkty
AS (
	SELECT pu.* FROM t2019_kar_poi_table pu
	LEFT JOIN t2018_kar_poi_table pp
	USING (poi_id) WHERE pp.poi_id IS NULL
)
SELECT np.type, COUNT(ST_DWithin(np.geom, (SELECT ST_Union(geom) FROM tnowe_kar_buildings), 500.0))
INTO NPunkty_w_buff FROM NPunkty np  GROUP BY np.type;


SELECT SUM(count) FROM NPunkty_w_buff;
SELECT * FROM NPunkty_w_buff;



-- 3.

CREATE TABLE streets_reprojected AS
SELECT * FROM t2019_kar_streets;

ALTER TABLE streets_reprojected
ALTER COLUMN geom
TYPE GEOMETRY(MULTILINESTRING, 3068) --3068 to ten epsg dla DHDN.Berlin/Cassini
USING ST_Transform(geom, 3068);

--SELECT ST_SRID(geom) FROM streets_reprojected;



-- 4. 

CREATE TABLE input_points(
	id INT PRIMARY KEY,
	name VARCHAR(20),
	geom GEOMETRY NOT NULL
);

INSERT INTO input_points VALUES (1, 'PunktA', ST_GeomFromText(('POINT(8.36093 49.03174)'), 4326));
INSERT INTO input_points VALUES (2, 'PunktB', ST_GeomFromText(('POINT(8.39876 49.00644)'), 4326));

--SELECT * FROM input_points;



-- 5. 

ALTER TABLE input_points
ALTER COLUMN geom
TYPE GEOMETRY(POINT, 3068)
USING ST_Transform(geom, 3068);

--SELECT ST_AsText(geom) FROM input_points;



-- 6. 

SELECT * FROM t2019_kar_street_node
WHERE ST_DWithin(geom,
				 (SELECT ST_Transform((ST_MakeLine(geom)), 4326) FROM input_points),
				 200.0, 
				 true); --200m mierzone na elipsoidzie; false - mierzone na sferze (wychodzi tutaj wiecej o 3 rows)
				 
				 
				 
-- 7. 

--2018
SELECT COUNT(type)
FROM t2018_kar_poi_table
WHERE type='Sporting Goods Store'
AND ST_DWithin(geom,(SELECT ST_Union(geom) FROM t2018_kar_land_use_a WHERE type ILIKE 'Park %'),300.0);
				 
--2019
SELECT COUNT(type)
FROM t2019_kar_poi_table
WHERE type='Sporting Goods Store'
AND ST_DWithin(geom,(SELECT ST_Union(geom) FROM t2019_kar_land_use_a WHERE type ILIKE 'Park %'),300.0);



-- 8. 
CREATE TABLE t2019_kar_bridges
AS (SELECT DISTINCT(ST_Intersection(rail.geom, wat.geom)) FROM t2019_kar_railways rail, t2019_kar_water_lines wat);
	
ALTER TABLE t2019_kar_bridges 
ADD COLUMN bridge_id SERIAL PRIMARY KEY;

SELECT * FROM t2019_kar_bridges;