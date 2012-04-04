-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- Clone table (structure + data) from one schema to another.
CREATE OR REPLACE FUNCTION clone_table (
       schema_src character varying,
       schema_dest character varying,
       table_src character varying) RETURNS void AS $BODY$
BEGIN
        EXECUTE 'CREATE TABLE '||schema_dest||'.'||table_src||
                ' (LIKE '||schema_src||'.'||table_src||' INCLUDING CONSTRAINTS INCLUDING INDEXES);';
        EXECUTE 'INSERT INTO '||schema_dest||'.'||table_src||
                ' SELECT * FROM '||schema_src||'.'||table_src||';';
END;
$BODY$ LANGUAGE plpgsql;
