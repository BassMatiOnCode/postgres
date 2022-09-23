-- Create user script
-- Parameters
-- :databaseName
-- :userName
-- :userMembership
-- :userSearchPath

\echo -- Creating user
CREATE USER :userName LOGIN ;
GRANT :userMembership TO :userName ;
ALTER USER :userName IN DATABASE :databaseName SET search_path to "$user", public, sales;