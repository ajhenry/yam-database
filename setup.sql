/*
Andrew Henry
12/17/2018
Yam Database
*/

-- First need to delete everything
DROP SCHEMA yamschema CASCADE;
CREATE SCHEMA yamschema;
ALTER DATABASE yamdb SET search_path TO yamschema;

SET SCHEMA 'yamschema';
BEGIN;
\i setup-files/tables.sql
\i setup-files/functions.sql
\i setup-files/updates.sql
\i setup-files/datainsert.sql
COMMIT;

