-- This function creates a proper date field (in UNIX time) from an excel number field (in excel time).
-- The new field created is named after the old one.
--
-- Author: Andrés Maneiro <andres.maneiro@gmail.com>
--
-- Details:
-- * excel time starts in 00-01-1900.
-- * excel: when a date is converted to number, its representation is the number of days from 01-01-1900,
--          so _02-01-1900_ will be _2_ as a number.
-- * pgsql uses UNIX time, which represents the number of seconds from 01-01-1970.
-- * pgsql _to_timestamp_ method receives as a parameter the UNIX time (in seconds).
--
CREATE OR REPLACE FUNCTION create_date_field_from_excel_string_date_field(your_table character varying, string_field character varying)
  RETURNS void AS
$BODY$
BEGIN
       EXECUTE 'ALTER TABLE '||your_table||
               ' ADD COLUMN '||string_field||'_date date;';
       EXECUTE 'UPDATE '||your_table||
       ' SET '||string_field||'_date = CAST (to_timestamp(to_number('||string_field||', ''999999'')*24*60*60 - 2209161600) AS date);';
       -- EXECUTE 'ALTER TABLE '||your_table||
       --         ' ALTER COLUMN '||string_field||'DROP DEFAULT;';
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
