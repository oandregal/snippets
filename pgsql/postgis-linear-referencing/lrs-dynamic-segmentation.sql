-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- The test will be done by creating a new geom field in events table
-- representing the localization of point in the route (events_point)
-- or the dynamic segmentation from the route (events_line).

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

-- create routes: calibrate line by setting the ends
UPDATE public.routes SET the_geom = (
       SELECT ST_AddMeasure(the_geom, measure_start, measure_end)
       FROM public.routes AS r
       WHERE id_route = 'GZ01')
WHERE id_route = 'GZ01';

UPDATE public.routes SET the_geom = (
       SELECT ST_AddMeasure(the_geom, measure_start, measure_end)
       FROM public.routes AS r
       WHERE id_route = 'GZ02')
WHERE id_route = 'GZ02';

-- locate points along routes
UPDATE events_point SET the_geom = (
       SELECT ST_Locate_Along_Measure(r.the_geom, e.measure)
       FROM public.routes AS r, public.events_point AS e
       WHERE r.id_route = e.id_route AND r.id_route = 'GZ01')
WHERE id_route = 'GZ01';

UPDATE events_point SET the_geom = (
       SELECT ST_Locate_Along_Measure(r.the_geom, e.measure)
       FROM public.routes AS r, public.events_point AS e
       WHERE r.id_route = e.id_route AND r.id_route = 'GZ02')
WHERE id_route = 'GZ02';

-- create dynamic segments from routes
UPDATE events_line SET the_geom = (
       SELECT ST_Locate_Between_Measures(r.the_geom,
                                e.measure_start,
                                e.measure_end)
       FROM public.routes AS r, public.events_line AS e
       WHERE r.id_route = e.id_route AND r.id_route = 'GZ01')
WHERE id_route = 'GZ01';

UPDATE events_line SET the_geom = (
       SELECT ST_Locate_Between_Measures(r.the_geom,
                                e.measure_start,
                                e.measure_end)
       FROM public.routes AS r, public.events_line AS e
       WHERE r.id_route = e.id_route AND r.id_route = 'GZ02')
WHERE id_route = 'GZ02';
