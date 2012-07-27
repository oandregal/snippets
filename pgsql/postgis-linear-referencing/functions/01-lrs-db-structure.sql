-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- LRS example: db structure

DROP TABLE IF EXISTS public.routes;
CREATE TABLE public.routes (
       id serial NOT NULL,
       id_route CHARACTER(4),
       measure_start float,
       measure_end float,
       CONSTRAINT pk_routes PRIMARY KEY (id)
);
DELETE FROM public.geometry_columns WHERE f_table_schema='public' AND f_table_name='routes';
SELECT AddGeometryColumn ('public', 'routes', 'the_geom', 23029, 'LINESTRINGM',3);
ALTER TABLE public.routes DROP CONSTRAINT enforce_dims_the_geom;
ALTER TABLE public.routes DROP CONSTRAINT enforce_geotype_the_geom;

DROP TABLE IF EXISTS public.events_point;
CREATE TABLE public.events_point (
       id serial NOT NULL,
       id_route CHARACTER(4),
       measure FLOAT,
       CONSTRAINT pk_events_point PRIMARY KEY (id)
);
DELETE FROM geometry_columns WHERE f_table_schema='public' AND f_table_name='events_point';
SELECT AddGeometryColumn('public', 'events_point', 'the_geom', 23029, 'POINTM', 3);
ALTER TABLE public.events_point DROP CONSTRAINT enforce_dims_the_geom;
ALTER TABLE public.events_point DROP CONSTRAINT enforce_geotype_the_geom;

DROP TABLE IF EXISTS public.events_line;
CREATE TABLE public.events_line(
       id serial NOT NULL,
       id_route CHARACTER(4),
       measure_start FLOAT,
       measure_end FLOAT,
       CONSTRAINT pk_events_line PRIMARY KEY (id)
);
DELETE FROM geometry_columns WHERE f_table_schema='public' AND f_table_name='events_line';
SELECT AddGeometryColumn('public', 'events_line', 'the_geom', 23029, 'LINESTRINGM', 3);
ALTER TABLE public.events_line DROP CONSTRAINT enforce_dims_the_geom;
ALTER TABLE public.events_line DROP CONSTRAINT enforce_geotype_the_geom;
