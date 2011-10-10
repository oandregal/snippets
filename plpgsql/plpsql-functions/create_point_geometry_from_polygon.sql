CREATE OR REPLACE FUNCTION create_point_geometry_from_polygon(
       the_schema_name TEXT,
       the_table_name TEXT,
       the_geom_polygon_name TEXT,
       the_geom_point_name TEXT,
       srid INT) RETURNS void AS $$
BEGIN
        EXECUTE 'SELECT AddGeometryColumn('||quote_literal(the_schema_name)||','||
                                          quote_literal(the_table_name)||','||
                                          quote_literal(the_geom_point_name)||','||
                                          srid||','||
                                          quote_literal('POINT')||
                                          ',2);';
        EXECUTE 'UPDATE '|| the_schema_name||'.'||the_table_name ||
                ' SET '||the_geom_point_name||' = ST_Centroid('||the_geom_polygon_name||');';
        EXECUTE 'CREATE INDEX geometry_index_the_geom_point_'||the_table_name||
                ' ON ' || the_schema_name ||'.'|| the_table_name ||
                ' USING GIST('||the_geom_polygon_name||');';
END
$$ LANGUAGE plpgsql;
