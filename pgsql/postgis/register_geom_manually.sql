-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

CREATE OR REPLACE FUNCTION register_geom_manually(the_schema_name text)
RETURNS void AS $$
DECLARE
        tblname text;
BEGIN
        FOR tblname IN SELECT table_name FROM information_schema.tables WHERE table_schema = the_schema_name
        LOOP
                EXECUTE 'INSERT INTO public.geometry_columns(
                       f_table_catalog, f_table_schema, f_table_name,
                       f_geometry_column, coord_dimension, srid, "type")
                       SELECT '''', '||quote_literal(the_schema_name)||', '||quote_literal(tblname)||','||
                              quote_literal('the_geom')||', ST_CoordDim(the_geom), ST_SRID(the_geom), GeometryType(the_geom)
                       FROM '||the_schema_name||'.'||tblname||' LIMIT 1;';
        END LOOP;
END
$$ LANGUAGE plpgsql;
