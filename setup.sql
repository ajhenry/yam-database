/*
Andrew Henry
12/17/2018
Yam Database
*/

-- First need to delete everything
DROP SCHEMA yamschema CASCADE;
CREATE SCHEMA yamschema;

SET SCHEMA 'yamschema';

-- Extensions go here
CREATE EXTENSION postgis;
CREATE EXTENSION citext;

BEGIN;
\i setup-files/tables.sql
\i setup-files/functions.sql
\i setup-files/updates.sql
\i setup-files/datainsert.sql
COMMIT;

-- permissions have be last, as there is nothing created before
GRANT USAGE ON SCHEMA yamschema TO yamuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA yamschema TO yamuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA yamschema TO yamuser;
ALTER DATABASE yamdb SET search_path TO yamschema;


