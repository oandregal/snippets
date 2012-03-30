-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

DELETE FROM geometry_columns WHERE f_table_schema='public' AND f_table_name='events_point';
SELECT AddGeometryColumn('public','events_point','the_geom',23029,'POINT',2);
-- Drop default constraints to demo the use of M-coordinates
ALTER TABLE public.events_point DROP CONSTRAINT enforce_geotype_the_geom;
ALTER TABLE public.events_point DROP CONSTRAINT enforce_dims_the_geom;

DELETE FROM geometry_columns WHERE f_table_schema='public' AND f_table_name='events_line';
SELECT AddGeometryColumn('public','events_line','the_geom',23029,'LINESTRING',2);
-- Drop default constraints to demo the use of M-coordinates
ALTER TABLE public.events_line DROP CONSTRAINT enforce_geotype_the_geom;
ALTER TABLE public.events_line DROP CONSTRAINT enforce_dims_the_geom;

-- create points along routes
UPDATE events_point
SET the_geom = (ST_GeomFromEWKT('SRID=23029;POINTM(1.5 1.5 1)'))
WHERE id=1;
INSERT INTO events_point (id_route, measure, the_geom)
       VALUES ('GZ01', 2, ST_GeomFromEWKT('SRID=23029;POINTM(2.5 2.5 2)'));
INSERT INTO events_point (id_route, measure, the_geom)
       VALUES ('GZ01', 4, ST_GeomFromEWKT('SRID=23029;POINTM(3.5 3.5 4)'));

UPDATE events_point
SET the_geom = (ST_GeomFromEWKT('SRID=23029;POINTM(1.5 3 1)'))
WHERE id = 2;
INSERT INTO events_point (id_route, measure, the_geom)
       VALUES ('GZ02', 1, ST_GeomFromEWKT('SRID=23029;POINTM(3 6 1)'));

-- ToDo: calibrate line with measured points
--
-- Algorithm:
-- STEP1 - use the measured points to take segments away from the linestring.
-- STEP2 - calibrate every segment taking as measures the measured points.
-- STEP3 - re-create the line from the segments measured.

-- S1: work in progress
-- SELECT ST_Line_Substring(r.the_geom,
--        ST_Line_Locate_Point(r.the_geom, sp.the_geom),
--        ST_Line_Locate_Point(r.the_geom, ep.the_geom))
-- FROM public.routes AS r,
--      (SELECT the_geom FROM public.events_point
--              WHERE id < (currval('events_point_id_seq')-1) ORDER BY id) AS sp,
--      (SELECT the_geom FROM public.events_point
--              WHERE id > 1 ORDER BY id) AS ep
-- WHERE p.id_route = r.id_route AND r.id_route = 'GZ01';


