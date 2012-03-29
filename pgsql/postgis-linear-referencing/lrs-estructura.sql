-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- LRS example: db structure

-- createdb -h localhost -p 5432 -U postgres -w -O postgres -T template_postgis test_lrs
--DROP DATABASE IF EXISTS test_lrs;
--CREATE DATABASE test_lrs
--       WITH OWNER = 'postgresql'
--       TEMPLATE = 'template_postgis';

DROP TABLE IF EXISTS public.routes;
CREATE TABLE public.routes (
       id serial NOT NULL,
       id_route CHARACTER(4),
       measure_start float,
       measure_end float,
       CONSTRAINT pk_routes PRIMARY KEY (id)
);
DELETE FROM public.geometry_columns WHERE f_table_schema='public' AND f_table_name='routes';
SELECT AddGeometryColumn ('public','routes','the_geom',23029,'LINESTRING',2);
-- Drop default constraints to demo the use of M-coordinates
ALTER TABLE public.routes DROP CONSTRAINT enforce_geotype_the_geom;
ALTER TABLE public.routes DROP CONSTRAINT enforce_dims_the_geom;

DROP TABLE IF EXISTS public.events_point;
CREATE TABLE public.events_point (
       id serial NOT NULL,
       id_route CHARACTER(4),
       measure FLOAT,
       CONSTRAINT pk_events_point PRIMARY KEY (id)
);

DROP TABLE IF EXISTS public.events_line;
CREATE TABLE public.events_line(
       id serial NOT NULL,
       id_route CHARACTER(4),
       measure_start FLOAT,
       measure_end FLOAT,
       CONSTRAINT pk_events_line PRIMARY KEY (id)
);
