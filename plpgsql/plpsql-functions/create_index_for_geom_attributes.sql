CREATE OR REPLACE FUNCTION create_index_for_geom_attribute(the_schema_name TEXT) RETURNS void AS $$
DECLARE
        my_row RECORD;
BEGIN
        FOR my_row IN SELECT schemaname, tablename FROM pg_tables WHERE schemaname=the_schema_name
        LOOP
                BEGIN
                        EXECUTE 'CREATE INDEX geometry_index_'||my_row.tablename||
                                ' ON ' || quote_ident(my_row.schemaname) || '.' || quote_ident(my_row.tablename) ||
                                ' USING GIST(the_geom);';
                EXCEPTION WHEN undefined_column THEN
                          RAISE NOTICE 'Undefined column the_geom in table';
                END;
        END LOOP;
        RETURN;
END
$$ LANGUAGE plpgsql;
