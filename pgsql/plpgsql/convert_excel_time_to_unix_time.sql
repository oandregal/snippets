-- @author: Andrés Maneiro <andres.maneiro@gmail.com>
-- @license: GPL v3

-- This function converts an excel string field representing a date into a proper pgsql date field.
--
-- Details:
-- * excel time starts in 00-01-1900.
-- * excel: when a date is converted to number, its representation is the number of days from 00-01-1900,
--          so _02-01-1900_ will be _2_ as a number.
-- * pgsql uses UNIX time, which represents the number of seconds from 01-01-1970.
-- * pgsql _to_timestamp_ method receives as a parameter the UNIX time (in seconds).
--
CREATE OR REPLACE FUNCTION convert_excel_string_field_to_pgsql_date_field(your_table character varying, string_field character varying)
  RETURNS void AS
$BODY$
BEGIN
        EXECUTE 'ALTER TABLE '||your_table||
               ' ALTER COLUMN '||string_field||' SET DATA TYPE date '||
               ' USING CAST (to_timestamp(to_number('||string_field||', ''999999'')*24*60*60 - 2209161600) AS date);';
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
