-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- The test will be done by creating a new geom field in events table
-- representing the localization of point in the route (events_point)
-- or the dynamic segmentation from the route (events_line).

-- create routes: calibrate line by setting the ends
UPDATE public.routes AS r1 SET the_geom = (
       SELECT ST_AddMeasure(the_geom, measure_start, measure_end)
       FROM public.routes AS r2
       WHERE r1.id_route = r2.id_route
);

-- locate points along routes
UPDATE events_point AS p1 SET the_geom = (
       SELECT ST_Locate_Along_Measure(r.the_geom, p2.measure)
       FROM public.routes AS r, public.events_point AS p2
       WHERE p1.id_route = p2.id_route AND r.id_route = p2.id_route
);

-- create dynamic segments from routes
UPDATE events_line AS l1 SET the_geom = (
       SELECT ST_Locate_Between_Measures(r.the_geom,
                                l2.measure_start,
                                l2.measure_end)
       FROM public.routes AS r, public.events_line AS l2
       WHERE l1.id_route = l2.id_route AND r.id_route = l2.id_route
);
