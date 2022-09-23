\echo Creating Groups

CREATE ROLE SalesManager NOLOGIN ;
GRANT connect, temporary ON DATABASE demo TO SalesManager;
GRANT select,insert,update, delete, references, trigger ON all tables IN SCHEMA sales TO SalesManager;
ALTER Role SalesManager IN DATABASE demo SET search_path to "$user", public, sales;


