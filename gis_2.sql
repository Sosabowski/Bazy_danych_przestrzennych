create extension postgis;


--4)

SELECT bud.* INTO tableb
FROM popp bud, majrivers r
WHERE bud.f_codedesc='Building' 
AND ST_DWithin(bud.geom, r.geom, 1000);

SELECT COUNT(f_codedesc) FROM tableb;

--5)
SELECT name, geom, elev INTO airportsNew
FROM airports;

--a)

SELECT name, ST_X(geom) AS west
FROM airportsNew 
ORDER BY west LIMIT 1

SELECT name, ST_X(geom) AS east
FROM airportsNew 
ORDER BY east DESC LIMIT 1


--b)

INSERT INTO airportsNew VALUES
('airportB',
(SELECT ST_Centroid(
ST_MakeLine((SELECT geom FROM airportsNew ORDER BY ST_X(geom) LIMIT 1), 
(SELECT geom FROM airportsNew ORDER BY ST_X(geom) DESC LIMIT 1)))),1);

SELECT * FROM airportsNew
WHERE name='airportB'

 --6)
SELECT ST_Area(ST_Buffer((ST_ShortestLine((
SELECT geom FROM lakes WHERE names='Iliamna Lake'),(
SELECT geom FROM airports WHERE name='AMBLER'))), 1000))

--7)

SELECT vegdesc, SUM(ST_Area(dr.geom)) 
FROM trees dr, tundra tu, swamp sw
WHERE ST_Within(dr.geom, tu.geom) OR St_Within(dr.geom, sw.geom)
GROUP BY dr.vegdesc


