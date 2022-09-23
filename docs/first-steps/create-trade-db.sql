\echo -- Creating the Trade database
CREATE DATABASE trade ;

\echo -- Configuring database
REVOKE all ON DATABASE postgres, template0, template1, trade FROM public, postgres;
REVOKE ALL ON SCHEMA public FROM public, postgres;
ALTER DEFAULT PRIVILEGES REVOKE all ON schemas FROM public ;

\echo -- Creating Schemas
CREATE SCHEMA if not exists Sales ;
CREATE SCHEMA if not exists Internal ;

\echo -- Protect the database from untrusted users
REVOKE ALL on database trade from public ;
REVOKE ALL on schema public from public ;
