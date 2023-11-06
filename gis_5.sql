

--Zad1

SELECT SUM(st_area(geom)) FROM trees
WHERE veg_id=50


--Zad2



SELECT * INTO Deciduous
FROM trees
WHERE veg_id=24



SELECT * INTO Evergreen
FROM trees
WHERE veg_id=25



SELECT * INTO Mixed
FROM trees
WHERE veg_id=50


--Zad3

WITH

zad3 AS 
(SELECT * FROM trails t WHERE ST_intersects(t.geom, (SELECT geom FROM regions WHERE name_2='Matanuska-Susitna')))
SELECT SUM(ST_Length(ST_Intersection))FROM ST_Intersection((SELECT ST_Union(geom) FROM matanuska_trails_plus), (SELECT geom FROM regions WHERE name_2='Matanuska-Susitna'))





--Zad4

--sr wysokosc

SELECT AVG(elev) 

FROM airports WHERE USE ILIKE 'Military';



 --ilosc lotnisk wojskowych

SELECT COUNT(id) 

FROM airports WHERE USE ILIKE 'Military';



--ilosc lotnisk spelnaijacych warunek

SELECT 	COUNT(id) FROM airports 

WHERE USE ILIKE 'Military' AND elev>1400;



--usuwanie

DELETE FROM airports

WHERE USE ILIKE 'Military' AND elev>1400;



--zad5



CREATE TABLE rejon_bristol_bay AS

SELECT * FROM popp p WHERE p.f_codedesc='Building' AND ST_Within(p.geom, (SELECT geom FROM regions WHERE name_2='Bristol Bay'));





--Ile budynkow?

SELECT COUNT(gid) FROM rejon_bristol_bay;



--Zad6





SELECT * FROM rejon_bristol_bay bb
WHERE ST_Within(bb.geom, ST_Buffer((SELECT ST_Union(r.geom) FROM rivers r), 100));
SELECT COUNT(*) FROM rejon_bristol_bay;


--Zad7 jpg

--Zad8



CREATE TABLE railroads_wezly AS SELECT ST_Node(geom) AS geom FROM railroads;
SELECT COUNT(geom) FROM railroads_wezly 



--Zad9

WITH 
lot_buffer AS 
(SELECT st_buffer(geom, 328083) as geom FROM airports),
tory_buffer AS 
(SELECT st_buffer(geom, 164041) as geom FROM railroads)


SELECT ST_Intersection(
(ST_Intersection((SELECT st_union(geom) FROM lot_buffer), r.geom)),(ST_Intersection((SELECT st_union(geom) FROM tory_buffer), r.geom))) as geom
FROM regions r


--Zad10



--Zwykle

SELECT SUM(ST_Npoints(geom)) as geom

FROM swamp



SELECT SUM(ST_Area(geom)) as geom

FROM swamp

--Uproszczone



SELECT SUM(ST_Npoints(ST_Simplify(geom, 100))) as geom

FROM swamp



SELECT SUM(ST_Area(ST_Simplify(geom, 100))) as geom

FROM swamp










