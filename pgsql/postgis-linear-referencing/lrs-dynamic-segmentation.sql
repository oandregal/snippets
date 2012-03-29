-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- The test will be done by creating a new geom field in events table
-- representing the localization of point in the route (events_point)
-- or the dynamic segmentation from the route (events_line).

DELETE FROM geometry_columns WHERE f_table_schema='public' AND f_table_name='events_point';
SELECT AddGeometryColumn('public','events_point','the_geom',23029,'POINT',2);

DELETE FROM geometry_columns WHERE f_table_schema='public' AND f_table_name='events_line';
SELECT AddGeometryColumn('public','events_line','the_geom',23029,'LINESTRING',2);

-- -- create route: calibrate line by setting the ends
-- UPDATE public.routes SET the_geom = (
--        SELECT ST_AddMeasure(the_geom, measure_start, measure_end)
--        FROM public.routes);

-- assign computed interpolated point from route
UPDATE events_point SET the_geom = (
       SELECT ST_Line_Interpolate_Point(r.the_geom,
              ((measure - r.measure_start)/(r.measure_end - r.measure_start)))
       FROM public.routes AS r);

-- assign computed interpolated line from route
UPDATE events_line SET the_geom = (
       SELECT ST_Line_Substring(r.the_geom,
              ((e.measure_start - r.measure_start) / (r.measure_end - r.measure_start)),
              ((e.measure_end - r.measure_start) / (r.measure_end - r.measure_start)))
       FROM public.routes AS r, public.events_line AS e);
