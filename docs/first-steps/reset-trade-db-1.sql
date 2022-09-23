-- Drops the entire trade db, recreates the structures and fills them with initial data.
-- HANDLE WITH CARE! Your data will be destroyed!
\c postgres
drop database trade;
\i create-trade-db-1.sql
\c trade
\i create-tables-1.sql
-- \i import-data-1.sql
