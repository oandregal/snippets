-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- Reproject tables in a given schema to a new SRID
-- Will be reprojected all tables registered in geometry_columns table.
-- Before using this query, you may consider useful execute Probe_Geometry_Columns();
CREATE OR REPLACE FUNCTION reproyectarTablas (schname character varying, newsrid integer)
  RETURNS void AS
$BODY$
 DECLARE
   tblname text;
 BEGIN
  FOR tblname IN SELECT f_table_name FROM public.geometry_columns WHERE f_table_schema = schname
  LOOP
	PERFORM updategeometrysrid(schname, tblname, 'the_geom', newsrid);
	EXECUTE 'UPDATE "' || schname ||'"."' || tblname ||'" SET the_geom=st_transform(the_geom, ' || newsrid || ')';
  END LOOP;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
