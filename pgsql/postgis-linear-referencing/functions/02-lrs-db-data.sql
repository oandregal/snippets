-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- LRS example: insert data

INSERT INTO public.routes (id_route, measure_start, measure_end, the_geom)
       VALUES ('GZ01', 8, 32,
              ST_GeomFromEWKT('SRID=23029;LINESTRING(1 1, 2 2, 4 4)'));
INSERT INTO public.routes (id_route, measure_start, measure_end, the_geom)
       VALUES ('GZ02', 0, 24,
              ST_GeomFromEWKT('SRID=23029;MULTILINESTRING((1 1, 2 4),(10 4, 20 4))'));

INSERT INTO public.events_point (id_route, measure) VALUES ('GZ01', 16);
INSERT INTO public.events_point (id_route, measure) VALUES ('GZ02', 16);

INSERT INTO public.events_line (id_route, measure_start, measure_end)
       VALUES ('GZ01', 10, 25);
INSERT INTO public.events_line (id_route, measure_start, measure_end)
       VALUES ('GZ02', 3, 18);
