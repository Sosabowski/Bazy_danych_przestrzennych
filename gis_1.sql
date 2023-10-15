create extension postgis
--tworzenie tabel
create schema mapa;
create table mapa.budynki(id INT PRIMARY KEY, geometria GEOMETRY NOT NULL, nazwa VARCHAR(25) NOT NULL);
create table mapa.drogi(id INT PRIMARY KEY, geometria GEOMETRY NOT NULL, nazwa VARCHAR(25) NOT NULL);
create table mapa.punkty_informacyjne(id INT PRIMARY KEY, geometria GEOMETRY NOT NULL, nazwa VARCHAR(25) NOT NULL);

--przypisywanie współrzędnych do tabel
INSERT INTO mapa.budynki VALUES
(1, ST_GeomFromText('POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))'), 'BuildingA'),
(2, ST_GeomFromText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))'), 'BuildingB'),
(3, ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))'), 'BuildingC'),
(4, ST_GeomFromText('POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))'), 'BuildingD'),
(5, ST_GeomFromText('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))'), 'BuildingF');

INSERT INTO mapa.drogi VALUES
(1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)'), 'RoadX'),
(2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)'), 'RoadY');

INSERT INTO mapa.punkty_informacyjne VALUES
(1, ST_GeomFromText('POINT(6 9.5)'), 'K'),
(2, ST_GeomFromText('POINT(6.5 6)'), 'J'),
(3, ST_GeomFromText('POINT(9.5 6)'), 'I'),
(4, ST_GeomFromText('POINT(1 3.5)'), 'G'),
(5, ST_GeomFromText('POINT(5.5 1.5)'), 'H');

--a)
SELECT SUM(ST_Length(geometria)) AS dlugowsc_drogi
FROM mapa.drogi;

--b)
SELECT ST_AsText(geometria) AS Geometria, 
ST_Area(geometria) AS Pole_powierzchni, 
ST_Perimeter(geometria) AS Obwod 
FROM mapa.budynki
WHERE nazwa='BuildingA';

--c)
SELECT nazwa, ST_Area(geometria) AS Pole_powierzchni 
FROM mapa.budynki
ORDER BY nazwa;

--d) 
SELECT nazwa, ST_Perimeter(geometria) AS Obwod 
FROM mapa.budynki
ORDER BY ST_Area(geometria) DESC LIMIT 2;

--e) 
SELECT ST_Distance(bud.geometria, infor.geometria) AS Odleglosc 
FROM mapa.budynki bud, mapa.punkty_informacyjne infor
WHERE bud.nazwa='BuildingC' AND infor.nazwa='G';

--f) 
SELECT ST_Area(ST_Difference(bbud.geometria, ST_Buffer(budd.geometria, 0.5))) AS pole_powierzchni
FROM mapa.budynki budd, mapa.budynki bbud
WHERE budd.nazwa='BuildingB' AND bbud.nazwa='BuildingC';


--g) 
SELECT b.nazwa, b.geometria 
FROM mapa.budynki b, mapa.drogi d
WHERE ST_Y(ST_Centroid(b.geometria)) > ST_Y(ST_Centroid(d.geometria))
AND d.nazwa = 'RoadX';

--h) 
SELECT ST_Area(ST_SymDifference(geometria, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')))
FROM mapa.budynki
WHERE nazwa='BuildingC';


						 